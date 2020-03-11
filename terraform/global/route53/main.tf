resource "aws_route53_zone" "route_zone" {
  name = var.zone_name
}

terraform {
  backend "s3" {
    bucket         = "santonastaso-tfstate"
    # Path in S3 Bucket to locate tfstate file
    key            = "global/route53/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "santonastaso-tfstate-locks"
    encrypt        = true
  }
}
