resource "aws_iam_role" "example" {
  name = "example"

  assume_role_policy = templatefile("${path.root}/modules/templates/codebuild_role.json", {})
}

resource "aws_iam_role_policy" "example" {
  role = aws_iam_role.example.name

  policy = templatefile("${path.root}/modules/templates/codebuild_policy.json", {})
}

resource "aws_codebuild_project" "example" {
  name          = var.codebuild_name
  description   = var.codebuild_desc
  build_timeout = "5"
  service_role  = aws_iam_role.example.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
  }

#   logs_config {
#     cloudwatch_logs {
#       group_name = "log-group"
#       stream_name = "log-stream"
#     }
#   }

  source {
    type            = "CODEPIPELINE"
    git_clone_depth = 1
  }

  source_version = "master"

}
