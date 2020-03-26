# docker-aws-cli



![Docker Image CI](https://github.com/morkot/docker-aws-cli/workflows/Docker%20Image%20CI/badge.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/morkot/aws-cli)

## Usage

1. Pull the image

```shell
docker pull morkot/aws-cli
```

2. Set s3 options and run

```shell
docker run -it --rm -e "AWS_CONF_S3_MAX_QUEUE_SIZE=10000" aws-cli aws s3 ls
```
