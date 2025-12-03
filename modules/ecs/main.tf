resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs.cluster_name

}

resource "aws_ecs_task_definition" "accounting_task_definition" {
  family                   = "accounting-${var.environment}-task-defination"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs.cpu
  memory                   = var.ecs.memory
  task_role_arn      = aws_iam_role.ecs_task_definition_role.arn
  skip_destroy = null
  execution_role_arn = aws_iam_role.ecs_task_definition_role.arn
  
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name       = var.ecs.accounting_container_name,
      image      = "263427518575.dkr.ecr.us-east-1.amazonaws.com/accounting-prod:458dca2-20250929-224918"
      essential  = true
      cpu        = 1024
      memory     = 2048

      environment = [
        {
          name  = "AWS_SECRET_ACCESS_KEY"
          value = var.app_secret_arn
        }
      ]

      secrets = [
        {
          name      = "AWS_ACCESS_KEY_ID"
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
      name       = var.ecs.otel_collector_container_name
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
          awslogs-region        = var.region
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
  desired_count = var.ecs.desired_count
  enable_ecs_managed_tags = var.ecs.enable_ecs_managed_tags
  enable_execute_command  = var.ecs.enable_execute_command
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



##############################################################################################
##auth service


resource "aws_ecs_task_definition" "auth_task_definition" {
  family                   = "auth-${var.environment}-task-defination"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs.cpu
  memory                   = var.ecs.memory
  task_role_arn      = aws_iam_role.ecs_task_definition_role.arn
  skip_destroy = null
  execution_role_arn = aws_iam_role.ecs_task_definition_role.arn
  
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name       = var.ecs.auth_container_name,
      image      = "263427518575.dkr.ecr.us-east-1.amazonaws.com/auth-prod:6c01fe5-20251017-124435"
      essential  = true
      cpu        = 1024
      memory     = 2048

      # environment = [
      #   {
      #     name  = "AWS_SECRET_ACCESS_KEY"
      #     value = var.app_secret_arn
      #   }
      # ]

      
      mountPoints      = []
      systemControls   = []
      volumesFrom      = []

      portMappings = [
        {
          containerPort = 3001
          hostPort      = 3001
          protocol      = "tcp"
          appProtocol   = "http"
          name          = "auth-${var.environment}-port"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/auth-${var.environment}-task-defination"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
          mode                  = "non-blocking"
          max-buffer-size       = "25m"
        }
      }
    },

    {
      name       = var.ecs.otel_collector_container_name
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
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
          mode                  = "non-blocking"
          max-buffer-size       = "25m"
        }
      }
    }
  ])
}


resource "aws_ecs_service" "auth_service" {
  name = "auth-${var.environment}-service"
  desired_count = var.ecs.desired_count
  enable_ecs_managed_tags = var.ecs.enable_ecs_managed_tags
  enable_execute_command  = var.ecs.enable_execute_command
  task_definition = "${aws_ecs_task_definition.auth_task_definition.family}:${aws_ecs_task_definition.auth_task_definition.revision}"


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
    container_name = "auth"
    container_port = 3001
    target_group_arn = var.auth_target_group_arn
  }

  network_configuration {
    assign_public_ip = true
    security_groups = [ aws_security_group.auth_service_sg.id ]
    subnets = [
      var.private_subnet1,
      var.private_subnet2,
      var.private_subnet3
    ]
}
}



##############################################################################################
##customer support

resource "aws_ecs_task_definition" "customer_support_task_defination" {
  family                   = "customer-support-${var.environment}-task-defination"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs.cpu
  memory                   = var.ecs.memory
  task_role_arn            = aws_iam_role.ecs_task_definition_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_definition_role.arn
  tags = {}

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = var.ecs.otel_collector_container_name
      image     = var.ecs.otel_collector_image_arn
      essential = true
      command   = ["--config=/etc/ecs/ecs-cloudwatch.yaml"]
      environment = []
      mountPoints = []
      portMappings = []
      systemControls = []
      volumesFrom = []

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.ecs.otel_collector_log_group_name
          awslogs-create-group  = "true"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
          max-buffer-size = "25m"
          mode = "non-blocking"

        }
        secretOptions = []
      }
    },

    {
      name      = var.ecs.customer_container_name
      image     = "263427518575.dkr.ecr.us-east-1.amazonaws.com/customer-support-prod:617ee76-20250701-060519"
      essential = true
      cpu       = var.ecs.cpu
      memory    = var.ecs.memory
      environment = []


      logConfiguration = {
        logDriver = "awslogs"
        secretOptions = []
        options = {
          awslogs-group         = "/ecs/customer-support-${var.environment}-task-defination"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
          awslogs-create-group  = "true"
          max-buffer-size = "25m"
          mode = "non-blocking"
        }
        
      }

      portMappings = [{
        name = "customer-support-${var.environment}-port"
        containerPort = 3002
        hostPort      = 3002
        protocol      = "tcp"
        appProtocol   = "http"
      }]
    }
  ])
}



resource "aws_ecs_service" "customer_support_service" {
  name = "customer-support-${var.environment}-service"
  desired_count = var.ecs.desired_count
  enable_ecs_managed_tags = var.ecs.enable_ecs_managed_tags
  enable_execute_command  = var.ecs.enable_execute_command
  task_definition = "${aws_ecs_task_definition.customer_support_task_defination.family}:${aws_ecs_task_definition.customer_support_task_defination.revision}"


  wait_for_steady_state  = null
  alarms {
    alarm_names = []
    enable = false 
    rollback = false 
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_configuration {
    bake_time_in_minutes = "0"
    strategy = "ROLLING"
  }

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
    container_name = var.ecs.customer_container_name
    container_port = 3002
    target_group_arn = var.customer_support_target_group_arn
  }

  network_configuration {
    assign_public_ip = true
    security_groups = [ aws_security_group.customer_support_service_sg.id ]
    subnets = [
      var.private_subnet1,
      var.private_subnet2,
      var.private_subnet3
    ]
}
}

##############################################################################################
##gift service
resource "aws_ecs_task_definition" "gift_task_defination" {
  family                   = "gift-${var.environment}-task-defination"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs.cpu
  memory                   = var.ecs.memory
  task_role_arn            = aws_iam_role.ecs_task_definition_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_definition_role.arn
  

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = var.ecs.otel_collector_container_name
      image     = var.ecs.otel_collector_image_arn
      essential = true
      command   = ["--config=/etc/ecs/ecs-cloudwatch.yaml"]
      environment = []
      mountPoints = []
      portMappings = []
      systemControls = []
      volumesFrom = []

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.ecs.otel_collector_log_group_name
          awslogs-create-group  = "true"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
          max-buffer-size = "25m"
          mode = "non-blocking"

        }
      }
    },

    {
      name      = var.ecs.gift_container_name
      image     = "263427518575.dkr.ecr.us-east-1.amazonaws.com/gift-prod:ca7a6ee-20251009-155657"
      essential = true
      cpu       = var.ecs.cpu
      memory    = var.ecs.memory
      environment = []


      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/accounting-gift-task-defination"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
          awslogs-create-group  = "true"
          max-buffer-size = "25m"
          mode = "non-blocking"
        }
        
      }

      portMappings = [{
        name = "gift-${var.environment}-port"
        containerPort = 3006
        hostPort      = 3006
        protocol      = "tcp"
        appProtocol   = "http"
      }]
    }
  ])
}



resource "aws_ecs_service" "gift_service" {
  name = "gift-${var.environment}-service"
  desired_count = var.ecs.desired_count
  enable_ecs_managed_tags = var.ecs.enable_ecs_managed_tags
  enable_execute_command  = var.ecs.gift_enable_execute_command
  task_definition = "${aws_ecs_task_definition.gift_task_defination.family}:${aws_ecs_task_definition.gift_task_defination.revision}"


  wait_for_steady_state  = null
  alarms {
    alarm_names = []
    enable = false 
    rollback = false 
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_configuration {
    bake_time_in_minutes = "0"
    strategy = "ROLLING"
  }

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
    container_name = var.ecs.gift_container_name
    container_port = 3006
    target_group_arn = var.gift_target_group_arn
  }

  network_configuration {
    assign_public_ip = true
    security_groups = [ aws_security_group.gift_service_sg.id ]
    subnets = [
      var.private_subnet1,
      var.private_subnet2,
      var.private_subnet3
    ]
}
}


##############################################################################################
# ## kowlUI service

resource "aws_ecs_task_definition" "kowlUI_task_defination" {
  family                   = "kowlUI-task-defination-${var.project_name}-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs.cpu
  memory                   = var.ecs.memory
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([

    # ------------------------------
    # 1. AWS OTEL SIDE CAR
    # ------------------------------
    {
      name      = "aws-otel-collector"
      essential = true
      image     = var.ecs.kowlUI_otel_collector_image_arn

      command = ["--config=/etc/ecs/ecs-cloudwatch.yaml"]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/ecs-aws-otel-sidecar-collector"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    },

    # ------------------------------
    # 2. Redpanda Console (UI)
    # ------------------------------
    {
      name      = "console"
      essential = true
      cpu       = var.ecs.cpu
      image     = "redpandadata/console:latest"

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/kowlUI-task-defination-${var.project_name}-${var.environment}"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    },

    # ------------------------------
    # 3. Kowl Backend
    # ------------------------------
    {
      name   = "kowl"
      memory = var.ecs.memory

      portMappings = [
        {
          appProtocol   = "http"
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
          name          = "kowl-port"
        }
      ]

      environment = [
        {
          name  = "KAFKA_BROKERS"
          value = "b-3.opalinkproductionmskcl.mptzy4.c1.kafka.us-east-1.amazonaws.com:9096,b-2.opalinkproductionmskcl.mptzy4.c1.kafka.us-east-1.amazonaws.com:9096,b-1.opalinkproductionmskcl.mptzy4.c1.kafka.us-east-1.amazonaws.com:9096"
        },
        {
          name  = "KAFKA_SASL_ENABLED"
          value = "true"
        },
        {
          name  = "KAFKA_SASL_MECHANISM"
          value = "SCRAM-SHA-512"
        },
        {
          name  = "KAFKA_SASL_PASSWORD"
          value = "sdas24324@"
        },
        {
          name  = "KAFKA_SASL_USERNAME"
          value = "admin"
        },
        {
          name = "KAFKA_TLS_ENABLED"
          value = "true"
        }
      ]
    }

  ])

  enable_fault_injection = false
  skip_destroy           = false
  tags                   = {}
  tags_all               = {}
}



resource "aws_ecs_service" "kowlUI_service" {
  name = "gift-${var.environment}-service"
  desired_count = var.ecs.desired_count
  enable_ecs_managed_tags = var.ecs.enable_ecs_managed_tags
  enable_execute_command  = var.ecs.gift_enable_execute_command
  task_definition = "${aws_ecs_task_definition.gift_task_defination.family}:${aws_ecs_task_definition.gift_task_defination.revision}"


  wait_for_steady_state  = null
  alarms {
    alarm_names = []
    enable = false 
    rollback = false 
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_configuration {
    bake_time_in_minutes = "0"
    strategy = "ROLLING"
  }

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
    container_name = var.ecs.gift_container_name
    container_port = 3006
    target_group_arn = var.gift_target_group_arn
  }

  network_configuration {
    assign_public_ip = true
    security_groups = [ aws_security_group.gift_service_sg.id ]
    subnets = [
      var.private_subnet1,
      var.private_subnet2,
      var.private_subnet3
    ]
}
}

########################################## mobile

resource "aws_ecs_task_definition" "mobile_task_defination" {
  family                   = "mobile-${var.environment}-task-defination"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs.cpu
  memory                   = var.ecs.memory
  task_role_arn            = aws_iam_role.ecs_task_definition_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_definition_role.arn
  

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = var.ecs.otel_collector_container_name
      image     = var.ecs.otel_collector_image_arn
      essential = true
      command   = [
        "--config=/etc/ecs/ecs-cloudwatch.yaml"
        ]
      environment = []
      mountPoints = []
      portMappings = []
      systemControls = []
      volumesFrom = []

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.ecs.otel_collector_log_group_name
          awslogs-create-group  = "true"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
          max-buffer-size = "25m"
          mode = "non-blocking"

        }
      }
    },

    {
      name      = var.ecs.mobile_container_name
      image     = "263427518575.dkr.ecr.us-east-1.amazonaws.com/mobile-prod:14b4aff-20250629-113650" 
      essential = true
      cpu       = var.ecs.cpu
      memory    = var.ecs.memory
      environment = []


      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/mobile-${var.environment}-task-defination" 
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
          awslogs-create-group  = "true"
          max-buffer-size = "25m"
          mode = "non-blocking"
        }
        
      }

      portMappings = [{
        name = "mobile-${var.environment}-port"
        containerPort = 6001
        hostPort      = 6001
        protocol      = "tcp"
        appProtocol   = "http"
        tag = {}
      }]
    }
  ])
}



resource "aws_ecs_service" "mobile_service" {
  name = "mobile-${var.environment}-service"
  desired_count = var.ecs.desired_count
  enable_ecs_managed_tags = var.ecs.enable_ecs_managed_tags
  enable_execute_command  = var.ecs.mobile_enable_execute_command
  task_definition = "${aws_ecs_task_definition.mobile_task_defination.family}:${aws_ecs_task_definition.mobile_task_defination.revision}"

  alarms {
    alarm_names = []
    enable = false 
    rollback = false 
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_configuration {
    bake_time_in_minutes = "0"
    # strategy = "ROLLING"
  }

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
    container_name = var.ecs.mobile_container_name
    container_port = 6001
    target_group_arn = var.mobile_target_group_arn
  }

  network_configuration {
    assign_public_ip = true
    security_groups = [ aws_security_group.mobile_service_sg.id ]
    subnets = [
      var.private_subnet1,
      var.private_subnet2,
      var.private_subnet3
    ]
}
}



########################################## notification

resource "aws_ecs_task_definition" "notification_task_defination" {
  family                   = "notification-${var.environment}-task-defination"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs.cpu
  memory                   = var.ecs.memory
  task_role_arn            = aws_iam_role.ecs_task_definition_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_definition_role.arn
  

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = var.ecs.otel_collector_container_name
      image     = var.ecs.otel_collector_image_arn
      essential = true
      command   = [
        "--config=/etc/ecs/ecs-cloudwatch.yaml"
        ]
      environment = []
      mountPoints = []
      portMappings = []
      systemControls = []
      volumesFrom = []

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.ecs.otel_collector_log_group_name
          awslogs-create-group  = "true"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
          max-buffer-size = "25m"
          mode = "non-blocking"

        }
      }
    },

    {
      name      = var.ecs.notification_container_name
      image     = "263427518575.dkr.ecr.us-east-1.amazonaws.com/notification-prod:f16c2bd-20251009-155525"
      essential = true
      cpu       = var.ecs.cpu
      memory    = var.ecs.memory
      environment = []


      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/notification-${var.environment}-task-defination" 
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
          awslogs-create-group  = "true"
          max-buffer-size = "25m"
          mode = "non-blocking"
        }
        
      }

      portMappings = [{
        name = "notification-${var.environment}-port"
        containerPort = 3003
        hostPort      = 3003
        protocol      = "tcp"
        appProtocol   = "http"
        tag = {}
      }]
    }
  ])
}



resource "aws_ecs_service" "notification_service" {
  name = "notification-${var.environment}-service"
  desired_count = var.ecs.desired_count
  enable_ecs_managed_tags = var.ecs.enable_ecs_managed_tags
  enable_execute_command  = var.ecs.notification_enable_execute_command
  health_check_grace_period_seconds = 0
  task_definition = "${aws_ecs_task_definition.notification_task_defination.family}:${aws_ecs_task_definition.notification_task_defination.revision}"
  propagate_tags = "NONE"
  
  tags = {}
  alarms {
    alarm_names = []
    enable = false 
    rollback = false 
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_configuration {
    bake_time_in_minutes = "0"
    strategy = "ROLLING"
  }

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
    container_name = var.ecs.notification_container_name
    container_port = 3003
    target_group_arn = var.notification_target_group_arn
  }

  network_configuration {
    assign_public_ip = true
    security_groups = [ aws_security_group.notifcation_service_sg.id ]
    subnets = [
      var.private_subnet1,
      var.private_subnet2,
      var.private_subnet3
    ]
}
}

########################################## nginx

resource "aws_ecs_task_definition" "nginx_task_defination" {
  family                   = "${var.project_name}-${var.environment}-nginx-service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs.cpu
  memory                   = var.ecs.memory
  task_role_arn            = aws_iam_role.ecs_task_definition_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_definition_role.arn
  

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = var.ecs.nginx_container_name
      image     = "263427518575.dkr.ecr.us-east-1.amazonaws.com/opalink/prod/nginx/auth"
      essential = true
      cpu = var.ecs.cpu
      
      # command   = [
      #   "--config=/etc/ecs/ecs-cloudwatch.yaml"
      #   ]
      environment = []
      mountPoints = []
      portMappings = []
      systemControls = []
      volumesFrom = []

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project_name}-${var.environment}-nginx-service"
          awslogs-create-group  = "true"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
          max-buffer-size = "25m"
          mode = "non-blocking"

        }
        secretOptions = []
      }
      portMappings = [{
        name = "nginx-port"
        containerPort = 80
        hostPort      = 80
        protocol      = "tcp"
        appProtocol   = "http"
        tag = {}
      }]
      ulimits = []
      memory = var.ecs.memory
    }
  ])
}



resource "aws_ecs_service" "nginx_service" {
  name = "${var.project_name}-${var.environment}-nginx-service"
  desired_count = var.ecs.desired_count
  enable_ecs_managed_tags = var.ecs.enable_ecs_managed_tags
  enable_execute_command  = var.ecs.notification_enable_execute_command
  health_check_grace_period_seconds = 0
  task_definition = "${aws_ecs_task_definition.nginx_task_defination.family}:${aws_ecs_task_definition.nginx_task_defination.revision}"
  propagate_tags = "NONE"
  
  tags = {}
  alarms {
    alarm_names = []
    enable = false 
    rollback = false 
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_configuration {
    bake_time_in_minutes = "0"
    strategy = "ROLLING"
  }

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
    container_name = var.ecs.nginx_container_name
    container_port = 80
    target_group_arn = var.nginx_target_group_arn
  }

  network_configuration {
    assign_public_ip = true
    security_groups = [ aws_security_group.nginx_service_sg.id ]
    subnets = [
      var.private_subnet1,
      var.private_subnet2,
      var.private_subnet3
    ]
}
}

########################################## restaurant

resource "aws_ecs_task_definition" "restaurant_task_defination" {
  family                   = "restaurant-${var.environment}-task-defination"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs.cpu
  memory                   = var.ecs.memory
  task_role_arn            = aws_iam_role.ecs_task_definition_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_definition_role.arn
  

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = var.ecs.otel_collector_container_name
      image     = var.ecs.otel_collector_image_arn
      essential = true
      # cpu = var.ecs.cpu
      
      command   = [
        "--config=/etc/ecs/ecs-cloudwatch.yaml"
        ]
      environment = []
      mountPoints = []
      portMappings = []
      systemControls = []
      volumesFrom = []

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/ecs-aws-otel-sidecar-collector"
          awslogs-create-group  = "true"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
          max-buffer-size = "25m"
          mode = "non-blocking"

        }
       
      },
      environment = []
      mountPoints = []
      name = var.ecs.otel_collector_container_name
      systemControls = []
      volumesFrom = []
    },
    {
      cpu = var.ecs.cpu
      essential = true 
      image = "263427518575.dkr.ecr.us-east-1.amazonaws.com/resturant-prod:911fb2a-20251121-212653"
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group = "true"
          awslogs-group = "/ecs/restaurant-${var.environment}-task-defination"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
          max-buffer-size       = "25m"
          mode                  = "non-blocking"
        }
      }
      memory = var.ecs.memory
      name = var.ecs.restaurant_container_name
      portMappings = [
        {
          appProtocol = "http"
          containerPort = 3004
          hostPort = 3004
          name = "restaurant-${var.environment}-port"
          protocol = "tcp"
          
        },
      ]
  
    }
  ])
}



resource "aws_ecs_service" "restaurant_service" {
  name = "${var.project_name}-${var.environment}-nginx-service"
  desired_count = var.ecs.desired_count
  enable_ecs_managed_tags = var.ecs.enable_ecs_managed_tags
  enable_execute_command  = var.ecs.notification_enable_execute_command
  health_check_grace_period_seconds = 0
  task_definition = "${aws_ecs_task_definition.nginx_task_defination.family}:${aws_ecs_task_definition.nginx_task_defination.revision}"
  propagate_tags = "NONE"
  
  tags = {}
  alarms {
    alarm_names = []
    enable = false 
    rollback = false 
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_configuration {
    bake_time_in_minutes = "0"
    strategy = "ROLLING"
  }

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
    container_name = var.ecs.nginx_container_name
    container_port = 80
    target_group_arn = var.nginx_target_group_arn
  }

  network_configuration {
    assign_public_ip = true
    security_groups = [ aws_security_group.nginx_service_sg.id ]
    subnets = [
      var.private_subnet1,
      var.private_subnet2,
      var.private_subnet3
    ]
}
}

