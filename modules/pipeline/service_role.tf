resource "aws_iam_role" "accounting_service_role" {
  name = "codebuild-${var.project_name}-${var.environment}-accounting-build-service-role"
  description = "Allows ECS tasks to call AWS services on your behalf."
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
  name = "CodeBuildBasePolicy-${var.project_name}-${var.environment}-accounting-${var.region}"
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
        Resource = [
                "*"
        ]
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
  name = "CodeBuildSecretsManagerPolicy-${var.project_name}-${var.environment}-accounting-${var.region}"
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

resource "aws_iam_policy" "secret_manager_policy_auth" {
  name = "CodeBuildSecretsManagerPolicy-${var.project_name}-${var.environment}-accounting-${var.region}"
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
  name = "CodeBuildSecretsManagerPolicy-${var.project_name}-${var.environment}-accounting-${var.region}"
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

resource "aws_iam_policy" "secret_manager_policy_mobile" {
  name = "CodeBuildSecretsManagerPolicy-${var.project_name}-${var.environment}-accounting-${var.region}"
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

resource "aws_iam_policy" "secret_manager_policy_notification" {
  name = "CodeBuildSecretsManagerPolicy-${var.project_name}-${var.environment}-accounting-${var.region}"
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

resource "aws_iam_policy" "secret_manager_policy_resturant" {
  name = "CodeBuildSecretsManagerPolicy-${var.project_name}-${var.environment}-accounting-${var.region}"
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

resource "aws_iam_policy" "secret_manager_policy_resturant_web" {
  name = "CodeBuildSecretsManagerPolicy-${var.project_name}-${var.environment}-accounting-${var.region}"
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

resource "aws_iam_policy" "secret_manager_policy_user" {
  name = "CodeBuildSecretsManagerPolicy-${var.project_name}-${var.environment}-accounting-${var.region}"
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
  policy_arn = aws_iam_policy.accounting_policy.name
}

resource "aws_iam_role_policy_attachment" "secret_manager_policy_accounting_attachment" {
  role = aws_iam_role.accounting_service_role.name
  policy_arn = aws_iam_policy.secret_manager_policy_accounting.name
}

resource "aws_iam_role_policy_attachment" "secret_manager_policy_authg_attachment" {
  role = aws_iam_role.accounting_service_role.name
  policy_arn = aws_iam_policy.secret_manager_policy_auth.name
}

resource "aws_iam_role_policy_attachment" "secret_manager_policy_gift_attachment" {
  role = aws_iam_role.accounting_service_role.name
  policy_arn = aws_iam_policy.secret_manager_policy_gift.name
}

resource "aws_iam_role_policy_attachment" "secret_manager_policy_mobile_attachment" {
  role = aws_iam_role.accounting_service_role.name
  policy_arn = aws_iam_policy.secret_manager_policy_mobile.name
}

resource "aws_iam_role_policy_attachment" "secret_manager_policy_notification_attachment" {
  role = aws_iam_role.accounting_service_role.name
  policy_arn = aws_iam_policy.secret_manager_policy_notification.name
}
resource "aws_iam_role_policy_attachment" "secret_manager_policy_resturant_attachment" {
  role = aws_iam_role.accounting_service_role.name
  policy_arn = aws_iam_policy.secret_manager_policy_resturant.name
}

resource "aws_iam_role_policy_attachment" "secret_manager_policy_resturant_web_attachment" {
  role = aws_iam_role.accounting_service_role.name
  policy_arn = aws_iam_policy.secret_manager_policy_resturant_web.name
}

resource "aws_iam_role_policy_attachment" "secret_manager_policy_user_attachment" {
  role = aws_iam_role.accounting_service_role.name
  policy_arn = aws_iam_policy.secret_manager_policy_user.name
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

resource "aws_iam_role_policy_attachment" "secret_manager_policy_user_attachment" {
  role = aws_iam_role.accounting_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}