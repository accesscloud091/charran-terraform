resource "aws_codebuild_project" "resturant" {
  name          = "${var.project_name}-${var.environment}-resturant-build"
  service_role  = aws_iam_role.accounting_service_role.arn
  build_timeout = var.pipeline.resturant_build_timeout

  artifacts {
    name = "${aws_s3_buckets3_bucket_restaurant_codepipeline.arn}/${project_name}-restaurant-p/BuildArtif/pW9vwkr"
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
  }


}
