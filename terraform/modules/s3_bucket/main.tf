resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = "public-read"
  policy = templatefile("${path.module}/templates/policy.json", { bucket_name = var.bucket_name })

  website {
    index_document = "index.html"
    error_document = "error.html"

    routing_rules = <<EOF
    [{
      "Condition": {
        "KeyPrefixEquals": "docs/"
      },
      "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
      }
    }]
    EOF
  }
}
