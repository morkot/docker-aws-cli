# docker-aws-cli

![Docker Image CI](https://github.com/morkot/docker-aws-cli/workflows/Docker%20Image%20CI/badge.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/morkot/aws-cli)

This docker image designed for CI workflows with AWS CLI. E.g. when you need to sync objects between
buckets. Often such activities need to be performed from one AWS account into another. In this case
the best way to access resources in account is STS Assume Role API call which provides client with
API token. 

Also, sometimes, there is a need to use more resources for AWS S3 operations. Then, AWS CLI can be
configured to use more threads, longer queue etc. See [AWS CLI S3
Configuration](https://docs.aws.amazon.com/cli/latest/topic/s3-config.html#aws-cli-s3-configuration)

## Usage

1. Pull the image

```shell
docker pull morkot/aws-cli
```

2. Set options via environment variables and run. Example

```shell
docker run -it --rm -e "AWS_CONF_S3_MAX_QUEUE_SIZE=10000" aws-cli aws s3 sync s3://bucket1 s3://bucket2
```

## Available S3 options

```shell
AWS_CONF_S3_MAX_CONCURRENT_REQUESTS 
AWS_CONF_S3_MAX_QUEUE_SIZE
AWS_CONF_S3_MULTIPART_THRESHOLD
AWS_CONF_S3_MULTIPART_CHUNKSIZE
AWS_CONF_S3_MAX_BANDWIDTH
AWS_CONF_S3_USE_ACCELERATE_ENDPOINT
AWS_CONF_S3_ADDRESSING_STYLE
```


## Assuming an IAM role

You can specify role ARN to assume before any command will be executed. Just specify
`AWS_CLI_ASSUME_ROLE_ARN` environment variable to the container. Default duration of token is 1
hour. If you need more, then specify `AWS_CLI_ASSUME_ROLE_DURATION` environment variable.

:exclamation: When you assume role using another role it considered role chaining. Role chaining
limits your AWS CLI or AWS API role session to a maximum of one hour. AWS does not treat using roles
to grant permissions to applications that run on EC2 instances as role chaining. So it should work
when assume role from EC2. Learn more
[here](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_terms-and-concepts.html).
