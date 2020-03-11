# Terraform requirements
terraform{
  required_version = ">= 0.12"
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
    key            = "develop/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "santonastaso-tfstate-locks"
    encrypt        = true
  }
}

# Initialising s3 bucket
module "s3_bucket" {
  source        = "../modules/s3_bucket"

  bucket_name   = var.bucket_name
}

module "pipeline" {
  source        = "../modules/pipeline"

  pipeline_name = var.bucket_name
  s3_bucket_arn = module.s3_bucket.s3_bucket_arn
  origin_org    = var.origin_org
  origin_repo   = var.origin_repo
  origin_branch = var.origin_branch
}