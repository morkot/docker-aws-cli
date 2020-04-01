#!/usr/bin/env bash

set -e

log() {
  level="$1"
  shift
  message="$@"
  echo "[$level] $message"
}

set_s3_conf() {
  param_list="max_concurrent_requests 
  max_queue_size
  multipart_threshold
  multipart_chunksize
  max_bandwidth
  use_accelerate_endpoint
  addressing_style"
  cmd_prefix="aws configure set default.s3."
  env_var_prefix="AWS_CONF_S3_"

  for param in $(echo $param_list); do
    cmd="$cmd_prefix$param"
    param_upper=$(echo "$param" | tr '[:lower:]' '[:upper:]')
    env_var_name="$env_var_prefix$param_upper"
    if [ -n "${!env_var_name}" ]; then
      log "INFO" "Setting aws s3 cli parameter: $cmd"
      eval "$cmd ${!env_var_name}"
    fi
  done
}

assume_iam_role() {
  duration=${AWS_CLI_ASSUME_ROLE_DURATION:-3600}
  if [ -n "${AWS_CLI_ASSUME_ROLE_ARN}" ]; then
    log "INFO" "Assuming role: $AWS_CLI_ASSUME_ROLE_ARN"
    assume_json=$(aws sts assume-role --role-arn "$AWS_CLI_ASSUME_ROLE_ARN" \
                                      --role-session-name "assumed_by_docker_aws_cli"\
                                      --duration-seconds "$duration")
    
    export AWS_ACCESS_KEY_ID=$(echo "$assume_json" | jq --raw-output '.Credentials.AccessKeyId')
    export AWS_SECRET_ACCESS_KEY=$(echo "$assume_json" | jq --raw-output '.Credentials.SecretAccessKey') 
    export AWS_SESSION_TOKEN=$(echo "$assume_json" | jq --raw-output '.Credentials.SessionToken')
  fi
}

term_handler() {
  #
  # Handle SIGTERM signal sent by `docker stop`
  # https://medium.com/@gchudnov/trapping-signals-in-docker-containers-7a57fdda7d86
  #
  if [ $pid -ne 0 ]; then
    kill -SIGTERM "$pid"
    wait "$pid"
  fi
  exit 143; # 128 + 15 -- SIGTERM
}

set_s3_conf
assume_iam_role

log "INFO" "Running command <${@}>"

trap 'log "ERROR" "Command <${@}> has stopped with error code $?"' ERR
trap 'log "ERROR" "Command <${@}> has been stopped" && kill ${!}; term_handler' SIGTERM

${@} &
pid="$!"
wait $pid

log "INFO" "Command <${@}> has finished successfully"
