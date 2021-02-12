# Terraform requirements
terraform{
  required_version = ">= 0.13"
}

# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket         = "santonastaso-tfstate"
    # Path in S3 Bucket to locate tfstate file
    key            = "master/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "santonastaso-tfstate-locks"
    encrypt        = true
  }
}

# Initialising s3 bucket
module "s3_bucket" {
  source            = "../modules/s3_bucket"

  bucket_name       = var.bucket_name
}

module "cloudfront" {
  source            = "../modules/cloudfront"

  s3_bucket_name    = var.bucket_name
  s3_origin_domain  = module.s3_bucket.s3_bucket_origin
  domain_name       = var.bucket_name
  route53_zone      = var.origin_repo
}

module "pipeline" {
  source          = "../modules/pipeline"

  pipeline_name   = var.pipeline_name
  s3_bucket_name  = var.bucket_name
  s3_bucket_arn   = module.s3_bucket.s3_bucket_arn
  origin_org      = var.origin_org
  origin_repo     = var.origin_repo
  origin_branch   = var.origin_branch
}

module "route53" {
  source            = "../modules/route53"

  domain_name       = var.origin_repo
  environment       = var.origin_branch
  cloudfront_domain = module.cloudfront.domain_name
  cloudfront_zone   = module.cloudfront.hosted_zone_id
}