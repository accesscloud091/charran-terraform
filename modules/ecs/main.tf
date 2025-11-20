resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs.cluster_name

}


resource "aws_ecs_task_definition" "accounting_task_definition" {
  family                   = var.ecs.accounting_task_family
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs.accounting_cpu
  memory                   = var.ecs.memory
  network_mode             = var.ecs.network_mode
  execution_role_arn       = var.ecs_accounting_execution_role
  task_role_arn            = var.ecs.task_role


  container_definitions = jsonencode([
    {
      name  = "service1"
      image = var.service1_image

      portMappings = [{
        containerPort = 8080
        protocol      = "tcp"
      }]
    }
  ])
}

resource "aws_ecs_service" "service1" {
  name            = "service1"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.service1.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [aws_security_group.service1.id]
    assign_public_ip = false
  }
}
