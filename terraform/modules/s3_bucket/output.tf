output "s3_bucket_arn" {
    value = "${aws_s3_bucket.bucket.arn}"
}

output "s3_bucket_origin" {
    value = "${aws_s3_bucket.bucket.bucket_domain_name}"
}