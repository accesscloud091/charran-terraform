resource "aws_codebuild_project" "auth" {
  name          = "${var.project_name}-${var.environment}-auth-build"
  service_role  = aws_iam_role.accounting_service_role.arn
  build_timeout = var.pipeline.build_timeout
  # concurrent_build_limit = var.pipeline.concurrent_build_limit

  artifacts {
    name = "${var.project_name}-${var.environment}-auth-build"
    packaging = "NONE"
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = var.pipeline.auth_privileged_mode

    environment_variable {
        name  = "AWS_ACCESS_KEY_ID"
        type  = "SECRETS_MANAGER"
        value = "${var.auth_secret_arn}:AWS_ACCESS_KEY_ID" 
            
            }
    environment_variable {
        name  = "AWS_SECRET_ACCESS_KEY"
        type  = "SECRETS_MANAGER"
        value = "${var.auth_secret_arn}:AWS_SECRET_ACCESS_KEY" 
                
            }
    environment_variable {
        name  = "AWS_DEFAULT_REGION"
        type  = "PLAINTEXT"
        value = var.region
            }
    environment_variable {
        name  = "CONFIG_DB_HOST" 
        type  = "SECRETS_MANAGER"
        value = "${var.auth_secret_arn}:CONFIG_DB_HOST" 
            }
    environment_variable {
        name  = "CONFIG_DB_PORT" 
        type  = "SECRETS_MANAGER" 
        value = "${var.auth_secret_arn}:CONFIG_DB_PORT"
            }
    environment_variable {
        name  = "CONFIG_DB_USERNAME" 
        type  = "SECRETS_MANAGER" 
        value = "${var.auth_secret_arn}:CONFIG_DB_USERNAME" 
            }
    environment_variable {
        name  = "CONFIG_DB_NAME" 
        type  = "SECRETS_MANAGER" 
        value = "${var.auth_secret_arn}:CONFIG_DB_NAME" 
            }
    environment_variable {
        name  = "CONFIG_DB_PASSWORD" 
        type  = "SECRETS_MANAGER" 
        value = "${var.auth_secret_arn}:CONFIG_DB_PASSWORD" 
            }


  }

  source {
    buildspec       =  file("${path.module}/auth_buildspec.yaml")
    type            = "CODEPIPELINE"
    git_clone_depth = var.pipeline.git_clone_depth
    insecure_ssl = var.pipeline.insecure_ssl
    report_build_status = var.pipeline.report_build_status
  }

  vpc_config {
    security_group_ids = [
        aws_security_group.codebuild_database_access_service_sg.id,
        # aws_security_group.restaurant_service_sg.id,
        aws_security_group.auth_service_sg.id,
        aws_security_group.auth_rds_sg.id

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
 



}


