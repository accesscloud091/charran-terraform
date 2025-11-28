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

resource "aws_codebuild_project" "accounting" {
  name          = "${var.project_name}-${var.environment}-accounting-build"
  service_role  = aws_iam_role.accounting_service_role.arn
  build_timeout = 60

  # tags = {
  #   Environment = var.environment
  #   Project = var.project_name
  # }

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
      value = var.accounting_secret_arn
            }
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      type  = "PLAINTEXT"
      value = "${var.accounting_secret_arn}:AWS_SECRET_ACCESS_KEY"
            }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "buildspec.yml"
  }

}
