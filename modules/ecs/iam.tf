resource "aws_iam_role" "ecs_task_definition_role" {
  name = var.ecs_task_definition_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_defination_attachment1" {
  role = aws_iam_role.test_role.ecs_task_definition_role
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonMSKFullAccess" {
  role = aws_iam_role.test_role.ecs_task_definition_role
  policy_arn = "arn:aws:iam::aws:policy/AmazonMSKFullAccess"
}

resource "aws_iam_role_policy_attachment" "AmazonMSKFullAccess" {
  role = aws_iam_role.test_role.ecs_task_definition_role
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "AmazonMSKFullAccess" {
  role = aws_iam_role.test_role.ecs_task_definition_role
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "AmazonMSKFullAccess" {
  role = aws_iam_role.test_role.ecs_task_definition_role
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchEventsFullAccess"
}

resource "aws_iam_policy" "secret_manager_policy" {
  name = var.task_definition_policy_name
  policy = jsonencode({  
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:secretsmanager:us-east-1:263427518575:secret:opalink/prod/app-secreats-LRAUm9"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "secret_manager_policy_attachment" {
  role = aws_iam_role.test_role.ecs_task_definition_role
  policy_arn = aws_iam_policy.secret_manager_policy.arn
}





######## cloudwatch log group

resource "aws_cloudwatch_log_group" "ecs_accounting_task_definition" {
  name              = var.ecs.accounting_log_group_name
  # retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "accounting_otel_sidecar_collector" {
  name              = var.ecs.accounting_otel_sidecar_collector_name
  # retention_in_days = 30
}

