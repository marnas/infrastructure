# Infrastructure
Terraform infrastructures for static website hosting on AWS S3 with CD implemented via CodePipeline and CodeBuild.

## Requirements

```
Terraform ">= 0.12.1"
AWS "~> 2.0"
```
GitHub API Token needed for CodePipeline integration
```
$ export GITHUB_TOKEN=api_token
```

## Usage
```
$ export AWS_PROFILE=profile
$ cd terraform
$ terraform init
$ terraform apply
```
