# resource "aws_codebuild_project" "project-with-cache" {
#     name = "${var.projcet_name}-${var.environment}-accounting-build"
#     service_role = aws_iam_role.accounting_service_role.arn
#     environment {
#         compute_type = "EC2"
#         image = "aws/codebuild/standard:7.0"

      
#     }
#     artifacts {
#       encryption_disabled = true
#     }
#     source {
#         type = 

      
#     }

# }

resource "aws_codebuild_project" "project_with_cache" {
  name          = "${var.project_name}-${var.environment}-accounting-build"
#   description   = "CodeBuild project for ${var.environment} accounting service"
  service_role  = aws_iam_role.accounting_service_role.arn
  build_timeout = 30

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true

    environment_variable {
      name  = "ENVIRONMENT"
      value = var.environment
    }
  }

  source {
    type            = "GITHUB"
    location        = var.github_repo_url
    buildspec       = "buildspec.yml"
  }

  artifacts {
    type                  = "S3"
    # location              = var.s3_bucket
    packaging             = "ZIP"
    path                  = "codebuild/artifacts"
    encryption_disabled   = false
  }

#   cache {
#     type     = "LOCAL"
#     modes    = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
#   }

  logs_config {
    cloudwatch_logs {
      group_name = "/aws/codebuild/${var.project_name}-${var.environment}-accounting"
      stream_name = "build-log"
    }

    s3_logs {
      status            = "DISABLED"
      location          = "${var.s3_bucket}/codebuild/logs/"
      encryption_disabled = true
    }
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
