resource "aws_codepipeline" "auth_codepipeline" {
  name            = "${var.project_name}-auth-${var.environment}-pipeline"
  pipeline_type   =  var.pipeline.codepipeline_type                       
  execution_mode  = var.pipeline.execution_mode
  role_arn        = aws_iam_role.codepipeline_role.arn
#   role_arn = aws_iam_role.accounting_service_role.arn


  artifact_store {
    location = aws_s3_bucket.s3_bucket_codepipeline.bucket
    type     = "S3"
  }

  # -------------------------
  # STAGE 1: SOURCE
  # -------------------------
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      run_order        = 1
      output_artifacts = ["SourceArtifact"]

      configuration = {
        Branch       = "feature/main"
        Owner = "${var.project_name}-app"
        PollForSourceChanges = false
        Repo = "auth-service"
        OAuthToken = null
       
      }
      input_artifacts = []
      namespace = "SourceVariables"
      region = var.region
     
     
    }
    on_failure {
      result = "RETRY"

    retry_configuration {
        retry_mode = "ALL_ACTIONS"
                }
            }
  }

  # -------------------------
  # STAGE 2: BUILD
  # -------------------------
  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      configuration = {
        ProjectName = aws_codebuild_project.auth.name
      }
      input_artifacts  = [
        "SourceArtifact",
        ]
      namespace = "BuildVariables" 
      output_artifacts = ["BuildArtifact"]
      
      owner            = "AWS"
      provider         = "CodeBuild"
      region = var.region
      version          = "1"
      run_order        = 1
      
    }
    on_failure {
      result = var.pipeline.build_stage_on_failure

      retry_configuration {
        retry_mode = "ALL_ACTIONS"
      }
    }
  }

  # -------------------------
  # STAGE 3: DEPLOY
  # -------------------------
  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
       configuration = {
        ClusterName = var.ecs_cluster_name
        ServiceName = var.auth_service_name
        DeploymentTimeout = "10"
      }
      input_artifacts = [
        "BuildArtifact"
      ]
      namespace = "DeployVariables"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      run_order       = 1
      output_artifacts = []
    
      region = var.region
    }
    on_failure {
      result = var.pipeline.deploy_stage_on_failure
    }
  }

}
