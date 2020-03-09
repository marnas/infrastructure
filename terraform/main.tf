# Terraform requirements
terraform{
  required_version = ">= 0.12.1"
}

# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-1"
}

# Initialising s3 bucket
module "s3_bucket" {
  source        = "./modules/s3_bucket"

  bucket_name   = var.bucket_name
}

module "pipeline" {
  source        = "./modules/pipeline"

  pipeline_name = var.bucket_name
  origin_org    = var.origin_org
  origin_repo   = var.origin_repo
  origin_branch = var.origin_branch
}