resource "aws_s3_bucket" "codepipeline_bucket" {
    bucket = "${var.pipeline_name}-pipeline"
    acl    = "private"
    force_destroy = true
}

resource "aws_iam_role" "codepipeline_role" {
  name = "${var.pipeline_name}-pipeline"

  assume_role_policy = templatefile(
    "${path.root}/modules/templates/assume_role.json", {
      service = "codepipeline"
    }
  )
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${var.pipeline_name}-pipeline"
  role = aws_iam_role.codepipeline_role.id
  policy = templatefile(
    "${path.root}/modules/templates/pipeline_policy.json", {
      codepipeline_bucket_arn = aws_s3_bucket.codepipeline_bucket.arn,
      codebuild_arn           = module.codebuild.codebuild_arn
    }
  )
}

# data "aws_kms_alias" "s3kmskey" {
#   name = "alias/myKmsKey"
# }

module "codebuild" {
    source = "../codebuild"

    s3_bucket_arn   = var.s3_bucket_arn
    s3_bucket       = var.pipeline_name
    s3_pipeline_arn = aws_s3_bucket.codepipeline_bucket.arn
    codebuild_name  = "${var.pipeline_name}-project"
}

resource "aws_codepipeline" "codepipeline" {
  name     = var.pipeline_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"

    # encryption_key {
    #   id   = data.aws_kms_alias.s3kmskey.arn
    #   type = "KMS"
    # }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner  = var.origin_org
        Repo   = var.origin_repo
        Branch = var.origin_branch
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = module.codebuild.codebuild_name
      }
    }
  }

}
