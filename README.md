# Infrastructure
Terraform infrastructures for static website hosted on AWS S3 with CD implemented via CodePipeline and CodeBuild.  
Tfstate is stored on S3 bucket and locking state is managed on a DynamoDB table.

## Folder Structure

```
.
└── terraform
    ├── develop
    │   ├── main.tf
    │   └── variables.tf
    ├── global
    │   ├── route53
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   └── s3_tfstate
    │       ├── main.tf
    │       └── variables.tf
    └── modules
        ├── cloudfront
        │   ├── main.tf
        │   ├── output.tf
        │   └── variables.tf
        ├── codebuild
        │   ├── main.tf
        │   ├── output.tf
        │   └── variables.tf
        ├── pipeline
        │   ├── main.tf
        │   └── variables.tf
        ├── route53
        │   ├── main.tf
        │   └── variables.tf
        ├── s3_bucket
        │   ├── main.tf
        │   ├── output.tf
        │   └── variables.tf
        └── templates
            ├── assume_role.json
            ├── codebuild_policy.json
            ├── pipeline_policy.json
            └── s3_policy.json
```

## Requirements

```
Terraform ">= 0.12"
AWS "~> 2.0"
```
GitHub API Token needed for CodePipeline integration.
```
$ export GITHUB_TOKEN=api_token
```

## Usage
Cloudfront distribution takes ~15min to deploy.
```
$ export AWS_PROFILE=profile
$ terraform init
$ terraform apply
```
