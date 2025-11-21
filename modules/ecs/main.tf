resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs.cluster_name

}

resource "aws_ecs_task_definition" "accounting_task_definition" {
  family                   = var.ecs.accounting_task_family
  requires_compatibilities = [ var.ecs.accounting_requires_capabilities ]
  network_mode             = var.ecs.network_mode

  cpu                      = var.ecs.cpu                # "1024"
  memory                   = var.ecs.memory             # "2048"

  execution_role_arn       = var.aws_iam_role.ecs_task_definition_role.arn
  task_role_arn            = var.aws_iam_role.ecs_task_definition_role.arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name         = var.ecs.accounting_container_name
      image        = var.accounting_service_image_arn
      essential    = true
      cpu          = 1024
      memory       = 2048

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
          appProtocol   = "http"
          name          = var.ecs.accounting_port_mapping_name   
        }
      ]

      environment = [
        {
          name  = "AWS_SECRET_ACCESS_KEY"
          value = var.aws_secret_value_arn    
        }
      ]

      secrets = [
        {
          name      = "AWS_ACCESS_KEY_ID"
          valueFrom = var.aws_secret_value_arn
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         =  aws_cloudwatch_log_group.ecs_accounting_task_definition.name
          awslogs-stream-prefix = "ecs"
          awslogs-region        = var.ecs.logs_region           
          awslogs-create-group  = var.ecs.create_cloudwatch_group 
          mode                  = "non-blocking"
          max-buffer-size       = "25m"
        }
      }
    },

    # --- Sidecar container (AWS OTEL Collector) ---
    {
      name      = var.ecs.accounting_otel_collector_container_name
      image     = var.ecs.accounting_otel_image_arn   
      essential = true

      command = [
        "--config=/etc/ecs/ecs-cloudwatch.yaml"
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.accounting_otel_sidecar_collector.arn      
          awslogs-stream-prefix = "ecs"
          awslogs-region        = var.ecs.logs_region 
          awslogs-create-group  = var.ecs.create_cloudwatch_group 
          mode                  = "non-blocking"
          max-buffer-size       = "25m"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "accounting_service" {
  name            = var.ecs.accounting_ecs_service_name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.accounting_task_definition.arn
  launch_type     = "FARGATE"
  desired_count   = var.ecs.desired_count

  deployment_configuration {
    strategy = var.ecs.deployment_strategy
  }

  load_balancer {
    target_group_arn = var.ecs.target_group_arn
    container_name    = var.ecs.accounting_container_name
    container_port    = 3000
  }

  network_configuration {
    subnets          = [ var.private_subnet1,
    var.private_subnet2, var.private_subnet3 ]

    security_groups  = [aws_security_group.service1.id]
    assign_public_ip = true
  }

  health_check_grace_period_seconds = 0
}
