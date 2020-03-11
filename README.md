# Infrastructure
Terraform infrastructures for static website hosted on AWS S3 with CD implemented via CodePipeline and CodeBuild.

## Folder Structure

```
├── develop
│   ├── main.tf
│   └── variables.tf
├── global
│   └── s3_tfstate
│       ├── main.tf
│       └── variables.tf
└── modules
    ├── codebuild
    │   ├── main.tf
    │   ├── output.tf
    │   └── variables.tf
    ├── pipeline
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
GitHub API Token needed for CodePipeline integration
```
$ export GITHUB_TOKEN=api_token
```

## Usage
```
$ export AWS_PROFILE=profile
$ terraform init
$ terraform apply
```
