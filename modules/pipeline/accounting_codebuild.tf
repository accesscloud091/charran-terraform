resource "aws_codebuild_project" "accounting" {
  name          = "${var.project_name}-${var.environment}-accounting-build"
  service_role  = aws_iam_role.accounting_service_role.arn
  build_timeout = var.pipeline.build_timeout
  # concurrent_build_limit = var.pipeline.concurrent_build_limit

  artifacts {
    name = "${var.project_name}-${var.environment}-accounting-build"
    packaging = "NONE"
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false

    environment_variable {
      name  = "AWS_ACCESS_KEY_ID"
      type = "SECRETS_MANAGER"
      value = "${var.accounting_secret_arn}:AWS_ACCESS_KEY_ID"
    }
    environment_variable {
      name  = "AWS_SECRET_ACCESS_KEY"
      type  = "SECRETS_MANAGER"
      value = "${var.accounting_secret_arn}:AWS_SECRET_ACCESS_KEY"
            }
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      type  = "PLAINTEXT"
      value = var.region
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

  source {
    type            = "CODEPIPELINE"
    buildspec       =  file("${path.module}/buildspec.yml")
    git_clone_depth = var.pipeline.git_clone_depth
    insecure_ssl = var.pipeline.insecure_ssl
    report_build_status = var.pipeline.report_build_status
  }

}


