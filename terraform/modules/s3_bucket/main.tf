resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = "public-read"
  force_destroy = true
  policy = templatefile(
    "${path.root}/../modules/templates/s3_policy.json", {
      bucket_name = var.bucket_name
    }
  )

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}
