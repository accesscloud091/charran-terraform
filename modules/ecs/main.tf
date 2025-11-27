resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs.cluster_name

}

# resource "aws_ecs_task_definition" "accounting_task_definition" {
#   family                   = var.ecs.accounting_task_family
#   requires_compatibilities = [ var.ecs.accounting_requires_capabilities ]
#   network_mode             = var.ecs.network_mode

#   cpu                      = var.ecs.cpu                # "1024"
#   memory                   = var.ecs.memory             # "2048"

#   execution_role_arn       = aws_iam_role.ecs_task_definition_role.arn
#   task_role_arn            = aws_iam_role.ecs_task_definition_role.arn

#   runtime_platform {
#     cpu_architecture        = "X86_64"
#     operating_system_family = "LINUX"
#   }

#   # container_definitions = jsonencode([
#   #   {
#   #     name         = var.ecs.accounting_container_name
#   #     image        = var.accounting_service_image_arn
#   #     essential    = true
#   #     cpu          = 1024
#   #     memory       = 2048

#   #     portMappings = [
#   #       {
#   #         containerPort = 3000
#   #         hostPort      = 3000
#   #         protocol      = "tcp"
#   #         appProtocol   = "http"
#   #         name          = var.ecs.accounting_port_mapping_name   
#   #       }
#   #     ]

#   #     # environment = [
#   #     #   {
#   #     #     name  = "AWS_SECRET_ACCESS_KEY"
#   #     #     value = var.aws_secret_value_arn    
#   #     #   }
#   #     # ]

#   #     # secrets = [
#   #     #   {
#   #     #     name      = "AWS_ACCESS_KEY_ID"
#   #     #     valueFrom = var.aws_secret_value_arn
#   #     #   }
#   #     # ]

#   #     logConfiguration = {
#   #       logDriver = "awslogs"
#   #       options = {
#   #         awslogs-group         =  aws_cloudwatch_log_group.accounting.name
#   #         awslogs-stream-prefix = "ecs"
#   #         awslogs-region        = var.ecs.logs_region           
#   #         awslogs-create-group  = var.ecs.create_cloudwatch_group 
#   #         mode                  = "non-blocking"
#   #         max-buffer-size       = "25m"
#   #       }
#   #     }
#   #   },

#   #   # --- Sidecar container (AWS OTEL Collector) ---
#   #   {
#   #     name      = var.ecs.accounting_otel_collector_container_name
#   #     image     = var.ecs.accounting_otel_image_arn   
#   #     essential = true

#   #     command = [
#   #       "--config=/etc/ecs/ecs-cloudwatch.yaml"
#   #     ]

#   #     logConfiguration = {
#   #       logDriver = "awslogs"
#   #       options = {
#   #         awslogs-group         = aws_cloudwatch_log_group.accounting_otel_sidecar_collector.arn      
#   #         awslogs-stream-prefix = "ecs"
#   #         awslogs-region        = var.ecs.logs_region 
#   #         awslogs-create-group  = var.ecs.create_cloudwatch_group 
#   #         mode                  = "non-blocking"
#   #         max-buffer-size       = "25m"
#   #       }
#   #     }
#   #   }
#   # ])

#   container_definitions = jsonencode([
#     {
#       name         = var.ecs.accounting_container_name
#       image        = var.accounting_service_image_repository_url
#       mountPoints = []
#       systemControls = []
#       volumesFrom = []
#       essential    = true
#       cpu          = 1024
#       memory       = 2048
     
#       portMappings = [
#         {
#           containerPort = 3000
#           hostPort      = 3000
#           protocol      = "tcp"
#           appProtocol   = "http"
#           name          = var.ecs.accounting_port_mapping_name
#         }
#       ]


#       environment = [
#         {
#         name = "AWS_SECRET_ACCESS_KEY"
#         value = var.app_secret
#         }
#       ]

#       secrets = [
#         {
#           name      = "AWS_ACCESS_KEY_ID"
#           valueFrom = var.app_secret
#         }
#       ]



#       logConfiguration = {
#         logDriver = "awslogs"
#         options = {
#           awslogs-group         = aws_cloudwatch_log_group.accounting.name
#           awslogs-stream-prefix = "ecs"
#           awslogs-region        = var.ecs.logs_region
#           awslogs-create-group  = tostring(var.ecs.create_cloudwatch_group) 
#           mode                  = "non-blocking"
#           max-buffer-size       = "25m"
#         }
#       }
#     },

#     # --- AWS OTEL Collector Sidecar ---
#     {
#       name      = var.ecs.accounting_otel_collector_container_name
#       image     = var.accounting_otel_image_url
#       environment      = []
#       mountPoints      = []
#       portMappings     = []
#       systemControls   = []
#       volumesFrom      = []
#       cpu = 1024
#       memory = 2048
#       network_mode = "awsvpc"
#       requires_compatibilities = "FARGATE"
#       skip_destroy = null
#       tags = {}
#       runtime_platform = [
#         {
#         cpu_architecture = "x86_64"
#         operating_system_family = "LINUX"
#         }
#       ]

#       essential = true

#       command = [
#         "--config=/etc/ecs/ecs-cloudwatch.yaml"
#       ]

#       logConfiguration = {
#         logDriver = "awslogs"
#         options = {
#           awslogs-group         = aws_cloudwatch_log_group.accounting_otel_sidecar_collector.name
#           awslogs-stream-prefix = "ecs"
#           awslogs-region        = var.ecs.logs_region
#           awslogs-create-group  = tostring(var.ecs.create_cloudwatch_group) 
#           mode                  = "non-blocking"
#           max-buffer-size       = "25m"
#         }
#       }
#     }
#   ])
# }
resource "aws_ecs_task_definition" "accounting_task_definition" {
  family                   = "accounting-${var.environment}-task-defination"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs.cpu
  memory                   = var.ecs.memory
  # revision = var.ecs.accounting_task_definition_revision

  # execution_role_arn = "arn:aws:iam::263427518575:role/opalink-prod-ecs-task-defination-role"
  # task_role_arn      = "arn:aws:iam::263427518575:role/opalink-prod-ecs-task-defination-role"
  execution_role_arn = aws_iam_role.ecs_task_definition_role.arn
  task_role_arn      = aws_iam_role.ecs_task_definition_role.arn
  
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name       = var.ecs.accounting_container_name
      image      = "263427518575.dkr.ecr.us-east-1.amazonaws.com/accounting-prod:458dca2-20250929-224918"
      essential  = true
      cpu        = 1024
      memory     = 2048

      environment = [
        {
          name  = "AWS_SECRET_ACCESS_KEY"
          # value = "arn:aws:secretsmanager:us-east-1:263427518575:secret:opalink/prod/app-secreats-LRAUm9"
          value = var.app_secret_arn
        }
      ]

      secrets = [
        {
          name      = "AWS_ACCESS_KEY_ID"
          # valueFrom = "arn:aws:secretsmanager:us-east-1:263427518575:secret:opalink/prod/app-secreats-LRAUm9"
          valueFrom = var.app_secret_arn
        }
      ]

      mountPoints      = []
      systemControls   = []
      volumesFrom      = []

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
          appProtocol   = "http"
          name          = "accounting-${var.environment}-port"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/accounting-${var.environment}-task-defination"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
          mode                  = "non-blocking"
          max-buffer-size       = "25m"
        }
      }
    },

    {
      name       = "aws-otel-collector"
      image      = "public.ecr.aws/aws-observability/aws-otel-collector:v0.43.3"
      essential  = true

      command = ["--config=/etc/ecs/ecs-cloudwatch.yaml"]

      environment    = []
      mountPoints    = []
      portMappings   = []
      systemControls = []
      volumesFrom    = []

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/ecs-aws-otel-sidecar-collector"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
          mode                  = "non-blocking"
          max-buffer-size       = "25m"
        }
      }
    }
  ])
}


resource "aws_ecs_service" "accounting" {
  name = "accounting-${var.environment}-service-8ia6ni4r"
  # force_new_deployment = true
  desired_count = var.ecs.accounting_desired_count
  enable_ecs_managed_tags = var.ecs.enable_ecs_managed_tags
  enable_execute_command  = var.ecs.enable_execute_command
  # task_definition = aws_ecs_task_definition.accounting_task_definition.arn
  # task_definition = aws_ecs_task_definition.accounting_task_definition.id
  task_definition = "${aws_ecs_task_definition.accounting_task_definition.family}:${aws_ecs_task_definition.accounting_task_definition.revision}"


  wait_for_steady_state  = null

  capacity_provider_strategy {
    base = 0
    capacity_provider = "FARGATE"
    weight = 1
  }

  deployment_circuit_breaker {
    enable = true
    rollback = true
  }

  load_balancer {
    container_name = "accounting"
    container_port = 3000
    target_group_arn = var.accounting_target_group_arn
  }

  network_configuration {
    assign_public_ip = true
    security_groups = [ aws_security_group.accounting_service_sg.id ]
    subnets = [
      var.private_subnet1,
      var.private_subnet2,
      var.private_subnet3
    ]
}
}