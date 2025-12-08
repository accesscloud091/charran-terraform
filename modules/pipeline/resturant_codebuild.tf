resource "aws_codebuild_project" "resturant" {
  name          = "${var.project_name}-${var.environment}-resturant-build"
  service_role = aws_iam_role.codepipeline_role.arn
  # service_role  = aws_iam_role.accounting_service_role.arn
  build_timeout = var.pipeline.resturant_build_timeout

  artifacts {
    encryption_disabled = false
    override_artifact_name = false
    name = "${var.project_name}-${var.environment}-resturant-build"
    packaging = "NONE"
    type = "CODEPIPELINE"
  }

  

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = var.pipeline.resturant_privileged_mode

    environment_variable {
      name  = "AWS_ACCESS_KEY_ID"
      type = "SECRETS_MANAGER"
      value = "${var.restaurant_secret_arn}:AWS_ACCESS_KEY_ID"
    }
    environment_variable {
      name  = "AWS_SECRET_ACCESS_KEY"
      type  = "SECRETS_MANAGER"
      value = "${var.restaurant_secret_arn}:AWS_SECRET_ACCESS_KEY"
            }
    
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      type  = "PLAINTEXT"
      value = var.region
            }
    environment_variable {
      name  = "CONFIG_DB_NAME"
      type  = "PLAINTEXT"
      value = "${var.restaurant_secret_arn}:CONFIG_DB_PASSWORD"
            }
    environment_variable {
      name  = "CONFIG_DB_USERNAME"
      type  = "PLAINTEXT"
      value = "${var.restaurant_secret_arn}:CONFIG_DB_USERNAME"
            }
    environment_variable {
      name  = "CONFIG_DB_PASSWORD"
      type  = "PLAINTEXT"
      value = "opalink/prod/restaurant:CONFIG_DB_PASSWORD"
            }
    
    environment_variable {
      name  = "CONFIG_DB_PORT"
      type  = "PLAINTEXT"
      value = "${var.restaurant_secret_arn}:CONFIG_DB_PORT"
            }
    environment_variable {
      name  = "CONFIG_DB_HOST"
      type  = "PLAINTEXT"
      value = "${var.restaurant_secret_arn}:CONFIG_DB_HOST" 
            }



  }
  cache {
    modes = []
    type = var.pipeline.cache_type
  }
  logs_config {
    cloudwatch_logs {
      status = var.pipeline.cloudwatch_logs_status
     
    }
    s3_logs {
      encryption_disabled = var.pipeline.s3_logs_encryption_disabled
      status = var.pipeline.s3_logs_status
    }
  }

  
  
  vpc_config {
    security_group_ids = [
        aws_security_group.codebuild_database_access_service_sg.id,
        aws_security_group.restaurant_service_sg.id

    ]
    subnets = [
        var.private_subnet2,
        var.private_subnet1,
        var.private_subnet6,
        var.private_subnet3,
        var.private_subnet5,
        var.private_subnet4

    ]
    vpc_id = var.vpc_id
  }
 

  source {
    type            = "CODEPIPELINE"
    buildspec       =  file("${path.module}/resturant_buildspec.yaml")
    git_clone_depth = var.pipeline.git_clone_depth
    insecure_ssl = var.pipeline.insecure_ssl
    report_build_status = var.pipeline.report_build_status
  }

  tags = {}


}
