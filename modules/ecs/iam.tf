resource "aws_iam_role" "ecs_task_definition_role" {
  name = "${var.project_name}-${var.environment}-ecs-task-defination-role"
  description = "Allows ECS tasks to call AWS services on your behalf."
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
  role = aws_iam_role.ecs_task_definition_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonMSKFullAccess" {
  role = aws_iam_role.ecs_task_definition_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonMSKFullAccess"
}

resource "aws_iam_role_policy_attachment" "AmazonS3FullAccess" {
  role = aws_iam_role.ecs_task_definition_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
  role = aws_iam_role.ecs_task_definition_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "CloudWatchEventsFullAccess" {
  role = aws_iam_role.ecs_task_definition_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchEventsFullAccess"
}

resource "aws_iam_role_policy" "secret_manager_policy" {
  name = var.task_definition_policy_name
  role = aws_iam_role.ecs_task_definition_role.name
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


#######################role for kowl

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "opatab-ecs-task-execution-role-production"
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

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn =  "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

















resource "aws_security_group" "accounting_service_sg" {
  name        = "accounting-${var.environment}-sg"

  description = "Created in ECS Console"
  vpc_id      = var.vpc_id
 
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = []
    self = false
    security_groups = [ var.load_balancer_sg_id ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }

  tags = {
    Name = "accounting-${var.environment}-sg" 
  }

  # revoke_rules_on_delete = null
}

resource "aws_security_group" "auth_service_sg" {
  name        = "auth-${var.environment}-sg"

  description = "Created in ECS Console"
  vpc_id      = var.vpc_id
 
  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = []
    self = false
    security_groups = [ var.load_balancer_sg_id ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }
}

resource "aws_security_group" "customer_support_service_sg" {
  name        = "customer-support-${var.environment}-tg"

  description = "Created in ECS Console"
  vpc_id      = var.vpc_id
 
  ingress {
    from_port   = 3002
    to_port     = 3002
    protocol    = "tcp"
    cidr_blocks = []
    self = false
    security_groups = [ var.load_balancer_sg_id ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }

}

resource "aws_security_group" "gift_service_sg" {
  name        = "gift-production-sg"
  description = "Created in ECS Console"
  vpc_id      = var.vpc_id
 
  ingress {
    from_port   = 3006
    to_port     = 3006
    protocol    = "tcp"
    cidr_blocks = []
    self = false
    security_groups = [ var.load_balancer_sg_id ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }

}

resource "aws_security_group" "mobile_service_sg" {
  name        = "mobile-${var.environment}-sg"
  description = "Created in ECS Console"
  vpc_id      = var.vpc_id
 
  ingress {
    from_port   = 6001
    to_port     = 6001
    protocol    = "tcp"
    cidr_blocks = []
    self = false
    security_groups = [ var.load_balancer_sg_id ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }

}

resource "aws_security_group" "notifcation_service_sg" {
  name        = "${var.environment}-notification-sg"
  description = "Created in ECS Console"
  vpc_id      = var.vpc_id
 
  ingress {
    from_port   = 3003
    to_port     = 3003
    protocol    = "tcp"
    cidr_blocks = []
    self = false
    security_groups = [ var.load_balancer_sg_id ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }

}


resource "aws_security_group" "nginx_service_sg" {
  name        = "ecs-nginx-service"
  description = "Created in ECS Console"
  vpc_id      = var.vpc_id
 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = []
    self = false
    security_groups = [ var.load_balancer_sg_id ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }

}




