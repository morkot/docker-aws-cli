#!/usr/bin/env bash

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
    [ -n "${!env_var_name}" ] && eval "$cmd ${!env_var_name}"
  done
}

set_s3_conf

exec "${@}"
