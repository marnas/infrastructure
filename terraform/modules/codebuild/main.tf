resource "aws_iam_role" "codebuild_role" {
  name = "${var.codebuild_name}-codebuild"

  assume_role_policy = templatefile(
    "${path.root}/../modules/templates/assume_role.json", {
      service = "codebuild"
    }
  )
}

resource "aws_iam_role_policy" "codebuild_policy" {
  role = aws_iam_role.codebuild_role.name

  policy = templatefile(
    "${path.root}/../modules/templates/codebuild_policy.json", {
      s3_pipeline_arn = var.s3_pipeline_arn,
      s3_bucket_arn   = var.s3_bucket_arn
    }
  )
}

resource "aws_codebuild_project" "codebuild" {
  name          = var.codebuild_name
  description   = var.codebuild_desc
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
  
    environment_variable {
      name  = "S3_BUCKET"
      value = var.s3_bucket
    }
  }

#   logs_config {
#     cloudwatch_logs {
#       group_name = "log-group"
#       stream_name = "log-stream"
#     }
#   }

  source {
    type            = "CODEPIPELINE"
  }

  source_version = "master"

}
