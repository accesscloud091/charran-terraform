resource "aws_codepipeline" "accounting_codepipeline" {
  name            = "${var.project_name}-accounting-${var.environment}-pipeline"
  pipeline_type   = "V2"
  execution_mode  = "QUEUED"
  role_arn        = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.s3_bucket_accounting_codepipeline.bucket
    type     = "S3"
  }

  # -------------------------
  # GIT SOURCE CONFIGURATION
  # -------------------------
#   git_configuration {
#     source_action_name = "Source"
#     provider_type      = "CodeStarSourceConnection"

#     push {
#       branches {
#         includes = ["feature/main"]
#       }
#     }
#   }

  # -------------------------
  # STAGE 1: SOURCE
  # -------------------------
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      run_order        = 1
      output_artifacts = ["SourceOutput"]

      configuration = {
        BranchName         = "feature/main"
        FullRepositoryId   = "opalink-app/accounting-service"
        ConnectionArn      = aws_codestarconnections_connection.codestar_connection.arn
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  # -------------------------
  # STAGE 2: BUILD
  # -------------------------
  stage {
    name = "Build"

    action {
      name             = "${var.project_name}-${var.environment}-accounting-build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      run_order        = 1
      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["BuildOutput"]

      configuration = {
        ProjectName = aws_codebuild_project.project_with_cache.name
      }
    }
  }

  # -------------------------
  # STAGE 3: DEPLOY (CloudFormation)
  # -------------------------
  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudFormation"
      version         = "1"
      run_order       = 1
      input_artifacts = ["BuildOutput"]

      configuration = {
        ActionMode     = "REPLACE_ON_FAILURE"
        Capabilities   = "CAPABILITY_IAM"
        StackName      = "OpalinkAccounting"
        TemplatePath   = "BuildOutput::sam-templated.yaml"
      }
    }
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
