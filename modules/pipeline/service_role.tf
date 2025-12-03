resource "aws_iam_role" "accounting_service_role" {
  name = "codebuild-${var.project_name}-${var.environment}-accounting-build-service-role"
  path = var.service_role_path
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "accounting_policy" {
  name = "CodeBuildBasePolicy-${var.project_name}-${var.environment}-accounting-build-${var.region}"
  description = "Policy used in trust relationship with CodeBuild" 
  path = var.service_role_path
  policy = jsonencode({  
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = [
               "arn:aws:logs:us-east-1:263427518575:log-group:/aws/codebuild/opalink-prod-accounting-build",
                "arn:aws:logs:us-east-1:263427518575:log-group:/aws/codebuild/opalink-prod-accounting-build:*",
                "arn:aws:logs:us-east-1:263427518575:log-group:/aws/codebuild/opalink-prod-resturant-build",
                "arn:aws:logs:us-east-1:263427518575:log-group:/aws/codebuild/opalink-prod-resturant-build:*",
                "arn:aws:logs:us-east-1:263427518575:log-group:/aws/codebuild/opalink-prod-super-admin-build",
                "arn:aws:logs:us-east-1:263427518575:log-group:/aws/codebuild/opalink-prod-super-admin-build:*",
                "arn:aws:logs:us-east-1:263427518575:log-group:/aws/codebuild/opalink-prod-notification-build",
                "arn:aws:logs:us-east-1:263427518575:log-group:/aws/codebuild/opalink-prod-notification-build:*",
                "arn:aws:logs:us-east-1:263427518575:log-group:/aws/codebuild/opalink-prod-auth-build",
                "arn:aws:logs:us-east-1:263427518575:log-group:/aws/codebuild/opalink-prod-auth-build:*",
                "arn:aws:logs:us-east-1:263427518575:log-group:/aws/codebuild/opalink-prod-gift-build",
                "arn:aws:logs:us-east-1:263427518575:log-group:/aws/codebuild/opalink-prod-gift-build:*",
                "arn:aws:logs:us-east-1:263427518575:log-group:/aws/codebuild/opalink-prod-user-build",
                "arn:aws:logs:us-east-1:263427518575:log-group:/aws/codebuild/opalink-prod-user-build:*",
                "arn:aws:logs:us-east-1:263427518575:log-group:/aws/codebuild/opalink-prod-customer-support-build",
                "arn:aws:logs:us-east-1:263427518575:log-group:/aws/codebuild/opalink-prod-customer-support-build:*",
                "arn:aws:logs:us-east-1:263427518575:log-group:/aws/codebuild/opalink-prod-mobile-build",
                "arn:aws:logs:us-east-1:263427518575:log-group:/aws/codebuild/opalink-prod-mobile-build:*",
                "arn:aws:logs:us-east-1:263427518575:log-group:/aws/codebuild/opalink-prod-resturant-web-app-build",
                "arn:aws:logs:us-east-1:263427518575:log-group:/aws/codebuild/opalink-prod-resturant-web-app-build:*"

        ]
      },
      {
        Action = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:GetBucketAcl",
            "s3:GetBucketLocation"
        ]
        Effect   = "Allow"
        Resource = [
               "arn:aws:s3:::codepipeline-${var.region}-*",
               "arn:aws:s3:::codepipeline-${var.region}-*/*"
        ]

      },
      
         {
        Action = [
            "codebuild:CreateReportGroup",
            "codebuild:CreateReport",
            "codebuild:UpdateReport",
            "codebuild:BatchPutTestCases",
            "codebuild:BatchPutCodeCoverages"
        ]
        Effect   = "Allow"
        Resource = [
                "arn:aws:codebuild:us-east-1:263427518575:report-group/opalink-prod-accounting-build-*",
                "arn:aws:codebuild:us-east-1:263427518575:report-group/opalink-prod-resturant-build-*",
                "arn:aws:codebuild:us-east-1:263427518575:report-group/opalink-prod-super-admin-build-*",
                "arn:aws:codebuild:us-east-1:263427518575:report-group/opalink-prod-notification-build-*",
                "arn:aws:codebuild:us-east-1:263427518575:report-group/opalink-prod-auth-build-*",
                "arn:aws:codebuild:us-east-1:263427518575:report-group/opalink-prod-gift-build-*",
                "arn:aws:codebuild:us-east-1:263427518575:report-group/opalink-prod-user-build-*",
                "arn:aws:codebuild:us-east-1:263427518575:report-group/opalink-prod-customer-support-build-*",
                "arn:aws:codebuild:us-east-1:263427518575:report-group/opalink-prod-mobile-build-*",
                "arn:aws:codebuild:us-east-1:263427518575:report-group/opalink-prod-resturant-web-app-build-*"
        ]
         },
         {
        Action = [
            "ecr:GetAuthorizationToken"
        ]
        Effect   = "Allow"
        Resource = "*"
         },
         
          {
        Action = [
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:ListImages",
                "ecr:DescribeRepositories",
                "ecr:BatchGetImage",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload"
        ]
        Effect   = "Allow"
        Resource = [
                "arn:aws:ecr:us-east-1:263427518575:repository/accounting-prod",
                "arn:aws:ecr:us-east-1:263427518575:repository/auth-prod",
                "arn:aws:ecr:us-east-1:263427518575:repository/customer-support-prod",
                "arn:aws:ecr:us-east-1:263427518575:repository/gift-prod",
                "arn:aws:ecr:us-east-1:263427518575:repository/mobile-prod",
                "arn:aws:ecr:us-east-1:263427518575:repository/notification-prod",
                "arn:aws:ecr:us-east-1:263427518575:repository/resturant-prod",
                "arn:aws:ecr:us-east-1:263427518575:repository/super-admin-prod",
                "arn:aws:ecr:us-east-1:263427518575:repository/user-prod",
                "arn:aws:ecr:us-east-1:263427518575:repository/restaurant-web-prod"
        ]
         }
    ]
  }
  )

  }

resource "aws_iam_policy" "secret_manager_policy_accounting" {
  name = "CodeBuildSecretsManagerPolicy-${var.project_name}-${var.environment}-accounting-build-${var.region}"
  description = "Policy used in trust relationship with CodeBuild" 
  path = var.service_role_path
  tags = {}

  policy = jsonencode({  
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
        Resource = [
           "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:/CodeBuild/*"
        ]
      
      }
    ]
  })
}

resource "aws_iam_policy" "secret_manager_policy_auth" {
  name = "CodeBuildSecretsManagerPolicy-${var.project_name}-${var.environment}-auth-build-${var.region}"
  description = "Policy used in trust relationship with CodeBuild"
  path = var.service_role_path
  tags = {}
  policy = jsonencode({  
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
       Resource = "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:/CodeBuild/*"
        
      }
    ]
  })
}

resource "aws_iam_policy" "secret_manager_policy_gift" {
  name = "CodeBuildSecretsManagerPolicy-${var.project_name}-${var.environment}-gift-build-${var.region}"
  description = "Policy used in trust relationship with CodeBuild"
  path = var.service_role_path
  policy = jsonencode({  
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
       Resource = [
         "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:/CodeBuild/*"
       ]
        
      }
    ]
  })
}

resource "aws_iam_policy" "secret_manager_policy_mobile" {
  name = "CodeBuildSecretsManagerPolicy-${var.project_name}-${var.environment}-mobile-build-${var.region}"
  description = "Policy used in trust relationship with CodeBuild"
  path = var.service_role_path
  policy = jsonencode({  
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
       Resource = [
         "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:/CodeBuild/*"
       ]
        
      }
    ]
  })
}

resource "aws_iam_policy" "secret_manager_policy_notification" {
  name = "CodeBuildSecretsManagerPolicy-${var.project_name}-${var.environment}-notification-build-${var.region}"
  description = "Policy used in trust relationship with CodeBuild"
  path = var.service_role_path
  policy = jsonencode({  
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
       Resource = [
         "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:/CodeBuild/*"
       ]
        
      }
    ]
  })
}

resource "aws_iam_policy" "secret_manager_policy_resturant" {
  name = "CodeBuildSecretsManagerPolicy-${var.project_name}-${var.environment}-resturant-build-${var.region}"
  description = "Policy used in trust relationship with CodeBuild"
  path = var.service_role_path
  policy = jsonencode({  
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
       Resource = [
         "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:/CodeBuild/*"
       ]
        
      }
    ]
  })
}

resource "aws_iam_policy" "secret_manager_policy_resturant_web" {
  name = "CodeBuildSecretsManagerPolicy-${var.project_name}-${var.environment}-resturant-web-app-build-${var.region}"
  description = "Policy used in trust relationship with CodeBuild"
  path = var.service_role_path
  policy = jsonencode({  
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
       Resource = [
        "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:/CodeBuild/*"
       ]
        
      }
    ]
  })
}

resource "aws_iam_policy" "secret_manager_policy_user" {
  name = "CodeBuildSecretsManagerPolicy-${var.project_name}-${var.environment}-user-build-${var.region}"
  description = "Policy used in trust relationship with CodeBuild"
  path = var.service_role_path
  policy = jsonencode({  
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
       Resource = "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:/CodeBuild/*"
        
      }
    ]
  })
}

resource "aws_iam_role_policy" "EC2VpcAccess" {
    name = "EC2VpcAccess"
    role = aws_iam_role.accounting_service_role.name
    policy = jsonencode({  
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "Statement1",
        Action = [
                "ec2:CreateNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeDhcpOptions",
                "ec2:DescribeVpcs",
                "ec2:CreateNetworkInterfacePermission"
        ]
        Effect   = "Allow"
        Resource = "*"
        
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "accounting_attachment" {
  role = aws_iam_role.accounting_service_role.name
  policy_arn = aws_iam_policy.accounting_policy.arn
}

resource "aws_iam_role_policy_attachment" "secret_manager_policy_accounting_attachment" {
  role = aws_iam_role.accounting_service_role.name
  policy_arn = aws_iam_policy.secret_manager_policy_accounting.arn
}

resource "aws_iam_role_policy_attachment" "secret_manager_policy_auth_attachment" {
  role = aws_iam_role.accounting_service_role.name
  policy_arn = aws_iam_policy.secret_manager_policy_auth.arn
}

resource "aws_iam_role_policy_attachment" "secret_manager_policy_gift_attachment" {
  role = aws_iam_role.accounting_service_role.name
  policy_arn = aws_iam_policy.secret_manager_policy_gift.arn
}

resource "aws_iam_role_policy_attachment" "secret_manager_policy_mobile_attachment" {
  role = aws_iam_role.accounting_service_role.name
  policy_arn = aws_iam_policy.secret_manager_policy_mobile.arn
}

resource "aws_iam_role_policy_attachment" "secret_manager_policy_notification_attachment" {
  role = aws_iam_role.accounting_service_role.name
  policy_arn = aws_iam_policy.secret_manager_policy_notification.arn
}
resource "aws_iam_role_policy_attachment" "secret_manager_policy_resturant_attachment" {
  role = aws_iam_role.accounting_service_role.name
  policy_arn = aws_iam_policy.secret_manager_policy_resturant.arn
}

resource "aws_iam_role_policy_attachment" "secret_manager_policy_resturant_web_attachment" {
  role = aws_iam_role.accounting_service_role.name
  policy_arn = aws_iam_policy.secret_manager_policy_resturant_web.arn
}

resource "aws_iam_role_policy_attachment" "secret_manager_policy_user_attachment" {
  role = aws_iam_role.accounting_service_role.name
  policy_arn = aws_iam_policy.secret_manager_policy_user.arn
}
# resource "aws_iam_role_policy" "secret_manager_policy" {
#   name = var.task_definition_policy_name
#   role = aws_iam_role.ecs_task_definition_role.name
#   policy = jsonencode({  
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "secretsmanager:GetSecretValue"
#         ]
#         Effect   = "Allow"
#         Resource = "arn:aws:secretsmanager:us-east-1:263427518575:secret:opalink/prod/app-secreats-LRAUm9"
#       }
#     ]
#   })
# }

resource "aws_iam_role_policy_attachment" "secret_manager_read_write_attachment" {
  role = aws_iam_role.accounting_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}




######################### accounting codepipeline service codepipeline ###################

resource "aws_iam_role" "codepipeline_role" {
  name = "AWSCodePipelineServiceRole-${var.region}-${var.project_name}-accounting-${var.environment}-pipeline"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codepipeline.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# ----------------------------------------
# Policy 1: S3 Access
# ----------------------------------------
resource "aws_iam_policy" "pipeline_s3_policy" {
  name = "AWSCodePipelineServiceRole-${var.region}-${var.project_name}-accounting-${var.environment}-pipeline"
  description      = "Policy used in trust relationship with CodePipeline for service role"
  path = var.service_role_path


  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowS3BucketAccess"
        Effect = "Allow"
        Action = [
          "s3:GetBucketVersioning",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ]
        Resource = [
          "arn:aws:s3:::codepipeline-us-east-1-70012dd85603-407e-918b-b915aa801171"
        ]
        Condition = {
          StringEquals = {
            "aws:ResourceAccount" = "263427518575"
          }
        }
      },
      {
        Sid    = "AllowS3ObjectAccess"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:GetObjectVersion"
        ]
        Resource = [
          "arn:aws:s3:::codepipeline-us-east-1-70012dd85603-407e-918b-b915aa801171/*"
        ]
        Condition = {
          StringEquals = {
            "aws:ResourceAccount" = "263427518575"
          }
        }
      }
    ]
  })
}

# ----------------------------------------
# Policy 2: CodeBuild Access
# ----------------------------------------
resource "aws_iam_policy" "accounting_codebuild_pipeline_policy" {
  name = "CodePipeline-CodeBuild-${var.region}-${var.project_name}-accounting-${var.environment}-pipeline"
  description      = "Policy used in trust relationship with CodePipeline for CodeBuild Action"
  path = var.service_role_path

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild",
        "codebuild:BatchGetBuildBatches",
        "codebuild:StartBuildBatch"
      ]
      Resource = [
        "arn:aws:codebuild:*:263427518575:project/opalink-prod-accounting-build"
      ]
    }]
  })
}

# ----------------------------------------
# Policy 3: CodeStar / CodeConnections
# ----------------------------------------
resource "aws_iam_policy" "pipeline_codestar_policy" {
  name = "CodePipeline-CodeConnections-${var.region}-${var.project_name}-accounting-${var.environment}-pipeline"
  description  = "Policy used in trust relationship with CodePipeline for CodeConnections Action"
  path = var.service_role_path

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "codeconnections:UseConnection",
        "codestar-connections:UseConnection"
      ]
      Resource = [
        "arn:aws:codestar-connections:*:263427518575:connection/57d4aa90-7e69-4249-b1ac-41a8cf6e6e42",
        "arn:aws:codeconnections:*:263427518575:connection/57d4aa90-7e69-4249-b1ac-41a8cf6e6e42"
      ]
    }]
  })
}

# ----------------------------------------
# Policy 4: ECS Deployment Permissions
# ----------------------------------------
resource "aws_iam_policy" "pipeline_ecs_policy" {
  name = "CodePipeline-ECSDeploy-us-east-1-opalink-accounting-prod-pipeline"
  description = "Policy used in trust relationship with CodePipeline for ECS Action"
  path = var.service_role_path

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "TaskDefinitionPermissions"
        Effect = "Allow"
        Action = [
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition"
        ]
        Resource = [ 
          "*"
        ]
      },
      {
        Sid    = "ECSServicePermissions"
        Effect = "Allow"
        Action = [
          "ecs:DescribeServices",
          "ecs:UpdateService"
        ]
        Resource = [
          "arn:aws:ecs:*:263427518575:service/ProdCluster/*"
        ]
      },
      {
        Sid    = "ECSTagResource"
        Effect = "Allow"
        Action = [
          "ecs:TagResource"
        ]
        Resource = [
          "arn:aws:ecs:*:263427518575:task-definition/arn:aws:ecs:us-east-1:263427518575:task-definition/accounting-prod-task-defination:9:*"
        ]
        Condition = {
          StringEquals = {
            "ecs:CreateAction" = ["RegisterTaskDefinition"]
          }
        }
      },
      {
        Sid    = "IamPassRolePermissions"
        Effect = "Allow"
        Action = "iam:PassRole"
        Resource = [
          "arn:aws:iam::263427518575:role/opalink-prod-ecs-task-defination-role"
        ]
        Condition = {
          StringEquals = {
            "iam:PassedToService" = [
              "ecs.amazonaws.com",
              "ecs-tasks.amazonaws.com"
            ]
          }
        }
      }
    ]
  })
}

# ----------------------------------------
# Attach all Policies to the Role
# ----------------------------------------
resource "aws_iam_role_policy_attachment" "attach_s3" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.pipeline_s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_codebuild" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.accounting_codebuild_pipeline_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_codestar" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.pipeline_codestar_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_ecs" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.pipeline_ecs_policy.arn
}
