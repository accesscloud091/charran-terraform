resource "aws_codepipeline" "restaurant_codepipeline" {
  name            = "${var.project_name}-restaurant-${var.environment}-pipeline"
  pipeline_type   =  var.pipeline.codepipeline_type                       
  execution_mode  = var.pipeline.restaurant_execution_mode
  # role_arn        = aws_iam_role.codepipeline_role.arn
  role_arn = aws_iam_role.accounting_service_role.arn
  region = var.region

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
      namespace = "SourceVariables"
      category         = "Source"
      configuration = {
        DetectChanges = "true"
        BranchName         = "feature/main"
        FullRepositoryId   = "opalink-app/restaurant-service"
        ConnectionArn      = aws_codestarconnections_connection.codestar_connection.arn
        OutputArtifactFormat = "CODE_ZIP"
      }
      input_artifacts = []
      output_artifacts = ["SourceArtifact"]
      owner            = "AWS"
      provider         = var.pipeline.provider
      region = var.region
      version          = "1"
      run_order        = 1
    }
    on_failure {
      result = var.pipeline.source_stage_on_failure
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
      namespace = "BuildVariables"
      configuration = {
        ProjectName = aws_codebuild_project.resturant.name
      }
      input_artifacts  = [
        "SourceArtifact",
      ]
       output_artifacts = [ 
        "BuildArtifact",
        ]
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      run_order        = 1
      region = var.region
      
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
      namespace = "DeployVariables"
      configuration = {
        ClusterName = var.ecs_cluster_name
        ServiceName = var.restaurant_service_name
      }
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      run_order       = 1
      input_artifacts = ["BuildArtifact"]
      output_artifacts   = [] 

      
    }
  }

}
