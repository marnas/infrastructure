resource "aws_s3_bucket" "codepipeline_bucket" {
    bucket = "${var.pipeline_name}-pipeline"
    acl    = "private"
    force_destroy = true
}

resource "aws_iam_role" "codepipeline_role" {
  name = "test-role"

  assume_role_policy = templatefile("${path.root}/modules/templates/assume_role.json", { service = "codepipeline" })
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = aws_iam_role.codepipeline_role.id
  policy = templatefile("${path.root}/modules/templates/pipeline_policy.json", {resource = aws_s3_bucket.codepipeline_bucket.arn})
}

# data "aws_kms_alias" "s3kmskey" {
#   name = "alias/myKmsKey"
# }

module "codebuild" {
    source = "../codebuild"

    codebuild_name = "santonastaso-project"
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
