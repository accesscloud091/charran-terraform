############################################
# ALB SECURITY GROUP
############################################

resource "aws_security_group" "lb_sg" {
  name        = "${var.environment}-${var.lb.sg_name}"

  description = "${var.environment}-${var.lb.sg_description}"
  vpc_id      = var.vpc_id
 
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }
  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }

  ingress {
    from_port   = 3002
    to_port     = 3002
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self = false 



  }
  ingress {
    from_port   = 3003
    to_port     = 3003
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }
  ingress {
    from_port   = 3004
    to_port     = 3004
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }
  ingress {
    from_port   = 3005
    to_port     = 3005
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }
  ingress {
    from_port   = 3006
    to_port     = 3006
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }
  

  ingress {
    from_port   = 6001
    to_port     = 6001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }

  ingress {
    from_port   = 6002
    to_port     = 6002
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }
  
  ingress {
    from_port   = 6003
    to_port     = 6003
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-ecs-load-balancer-sg" 
  }

  revoke_rules_on_delete = null
}



############################################
# LOAD BALANCER
############################################

resource "aws_lb" "lb" {
  name               = var.lb.name
  load_balancer_type = var.lb.type  
  internal           = false
  ip_address_type    = var.lb.ip_address_type
  security_groups    = [aws_security_group.lb_sg.id]
  enable_deletion_protection =  var.lb.enable_deletion_protection
  idle_timeout = var.lb.idle_timeout
  access_logs {
    enabled = true
    bucket = var.lb_s3_logs_bucket
    

  }

  subnets = [
    var.public_subnet1,
    var.public_subnet2,
    var.public_subnet3
  ]
}


############################################
# TARGET GROUPS 
############################################
resource "aws_lb_target_group" "super_admin" {
  name        = "${var.lb.target_name}-${var.environment}-super-admin"
  port        = var.lb.super_admin_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  lambda_multi_value_headers_enabled  = var.lb.lambda_multi_value_headers_enabled
  proxy_protocol_v2 = var.lb.proxy_protocol_v2

  health_check {
    protocol = "HTTP"
    path     = "/"
    port = var.lb.super_admin_port
    healthy_threshold = var.lb.healthy_threshold
    unhealthy_threshold = var.lb.unhealthy_threshold
  }
}

resource "aws_lb_target_group" "auth_service" {
  # name        = replace("${var.lb.target_name}-${var.environment}-auth-service", "_", "-")
  name        = "${var.lb.target_name}-${var.environment}-auth-service"
  port        = var.lb.auth_service_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  lambda_multi_value_headers_enabled  = var.lb.lambda_multi_value_headers_enabled
  proxy_protocol_v2 = var.lb.proxy_protocol_v2

  health_check {
    protocol = "HTTP"
    path     = "/"
    port = var.lb.auth_service_port
    healthy_threshold = var.lb.healthy_threshold
    unhealthy_threshold = var.lb.unhealthy_threshold

  }
}

resource "aws_lb_target_group" "customer_support" {
  # name        = replace("${var.lb.target_name}-${var.environment}-customer-support", "_", "-")
  name        = "${var.lb.target_name}-${var.environment}-customer-support"
  port        = var.lb.customer_support_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  lambda_multi_value_headers_enabled  = var.lb.lambda_multi_value_headers_enabled
  proxy_protocol_v2 = var.lb.proxy_protocol_v2


  health_check {
    protocol = "HTTP"
    path     = "/"
    port = var.lb.customer_support_port
    healthy_threshold = var.lb.healthy_threshold
    unhealthy_threshold = var.lb.unhealthy_threshold
  }
}

resource "aws_lb_target_group" "accounting_service" {
  # name        = replace("${var.lb.target_name}-${var.environment}-accounting-service", "_", "-")
  name        = "${var.lb.target_name}-${var.environment}-accounting-service"
  port        = var.lb.accounting_service_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  lambda_multi_value_headers_enabled  = var.lb.lambda_multi_value_headers_enabled
  proxy_protocol_v2 = var.lb.proxy_protocol_v2

  health_check {
    protocol = "HTTP"
    path     = "/"
    port = var.lb.accounting_service_port
    healthy_threshold = var.lb.healthy_threshold
    unhealthy_threshold = var.lb.unhealthy_threshold
  }
}

resource "aws_lb_target_group" "restaurant_web" {
  # name        = replace("${var.lb.target_name}-${var.environment}-restaurant-web", "_", "-")
  name        = "${var.lb.target_name}-${var.environment}-restaurant-web"
  port        = var.lb.restaurant_web_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  lambda_multi_value_headers_enabled  = var.lb.lambda_multi_value_headers_enabled
  proxy_protocol_v2 = var.lb.proxy_protocol_v2


  health_check {
    protocol = "HTTP"
    path     = "/"
    port = var.lb.restaurant_web_port
    healthy_threshold = var.lb.healthy_threshold
    unhealthy_threshold = var.lb.unhealthy_threshold
  }
}

resource "aws_lb_target_group" "restaurant_service" {
  # name        = replace("${var.lb.target_name}-${var.environment}-restaurant-service", "_", "-")
  name        = "${var.lb.target_name}-${var.environment}-restaurant-service"
  port        = var.lb.restaurant_service_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  lambda_multi_value_headers_enabled  = var.lb.lambda_multi_value_headers_enabled
  proxy_protocol_v2 = var.lb.proxy_protocol_v2

  health_check {
    protocol = "HTTP"
    path     = "/"
    port = var.lb.restaurant_service_port
    healthy_threshold = var.lb.healthy_threshold
    unhealthy_threshold = var.lb.unhealthy_threshold
  }
}

resource "aws_lb_target_group" "mobile_service" {
  # name        = replace("${var.lb.target_name}-${var.environment}-mobile-service", "_", "-")
  name        = "${var.lb.target_name}-${var.environment}-mobile-service"
  port        = var.lb.mobile_service_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  lambda_multi_value_headers_enabled  = var.lb.lambda_multi_value_headers_enabled
  proxy_protocol_v2 = var.lb.proxy_protocol_v2

  health_check {
    protocol = "HTTP"
    path     = "/"
    port = var.lb.mobile_service_port
    healthy_threshold = var.lb.healthy_threshold
    unhealthy_threshold = var.lb.unhealthy_threshold
  }
}

resource "aws_lb_target_group" "nginx_service" {
  # name        = replace("${var.lb.target_name}-${var.environment}-nginx-service", "_", "-")
  name        = "${var.lb.target_name}-${var.environment}-nginx-service"
  port        = var.lb.nginx_service_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  lambda_multi_value_headers_enabled  = var.lb.lambda_multi_value_headers_enabled
  proxy_protocol_v2 = var.lb.proxy_protocol_v2

  health_check {
    protocol = "HTTP"
    path     = "/healthcheck"
    # port = var.lb.nginx_service_port
    port = "traffic-port"
    healthy_threshold = var.lb.healthy_threshold
    unhealthy_threshold = var.lb.unhealthy_threshold
  }
}

resource "aws_lb_target_group" "notification" {
  # name        = replace("${var.lb.target_name}-${var.environment}-notification", "_", "-")
  name        = "${var.lb.target_name}-${var.environment}-notification"
  port        = var.lb.notification_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  lambda_multi_value_headers_enabled  = var.lb.lambda_multi_value_headers_enabled
  proxy_protocol_v2 = var.lb.proxy_protocol_v2

  health_check {
    protocol = "HTTP"
    path     = "/"
    port = var.lb.notification_port
    healthy_threshold = var.lb.healthy_threshold
    unhealthy_threshold = var.lb.unhealthy_threshold
  }
}

resource "aws_lb_target_group" "user_service" {
  # name        = replace("${var.lb.target_name}-${var.environment}-user-service", "_", "-")
  name        = "${var.lb.target_name}-${var.environment}-user-service"
  port        = var.lb.user_service_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  lambda_multi_value_headers_enabled  = var.lb.lambda_multi_value_headers_enabled
  proxy_protocol_v2 = var.lb.proxy_protocol_v2


  health_check {
    protocol = "HTTP"
    path     = "/"
    port = var.lb.user_service_port
    healthy_threshold = var.lb.healthy_threshold
    unhealthy_threshold = var.lb.unhealthy_threshold
  
  }
}

resource "aws_lb_target_group" "gift_service" {
  # name        = replace("${var.lb.target_name}-${var.environment}-gift-service", "_", "-")
  name        = "${var.lb.target_name}-${var.environment}-gift-service"
  port        = var.lb.gift_service_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  lambda_multi_value_headers_enabled  = var.lb.lambda_multi_value_headers_enabled
  proxy_protocol_v2 = var.lb.proxy_protocol_v2

  health_check {
    protocol = "HTTP"
    path     = "/"
    port = var.lb.gift_service_port
    healthy_threshold = var.lb.healthy_threshold
    unhealthy_threshold = var.lb.unhealthy_threshold
  }
}

############################################
# HTTP LISTENERS 
############################################

resource "aws_lb_listener" "super_admin" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 6003
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.super_admin.arn
    forward {
      stickiness {
        duration = 3600
        enabled = false
      }

      target_group {
        arn = aws_lb_target_group.super_admin.arn
        weight = 1
      }
    }
       
      }
}

resource "aws_lb_listener" "auth_service" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 3001
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.auth_service.arn
    forward {
      stickiness {
        duration = 3600
        enabled = false
      }

      target_group {
        arn = aws_lb_target_group.auth_service.arn
        weight = 1
      }
    }
  }
}

resource "aws_lb_listener" "customer_support" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 3002
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.customer_support.arn
    forward {
      stickiness {
        duration = 3600
        enabled = false
      }

      target_group {
        arn = aws_lb_target_group.customer_support.arn
        weight = 1
      }
    }
  }
}

resource "aws_lb_listener" "accounting_service" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 3000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.accounting_service.arn
    forward {
      stickiness {
        duration = 3600
        enabled = false
      }

      target_group {
        arn = aws_lb_target_group.accounting_service.arn
        weight = 1
      }
    }
  }
}

resource "aws_lb_listener" "restaurant_web" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 6002
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.restaurant_web.arn
    forward {
      stickiness {
        duration = 3600
        enabled = false
      }

      target_group {
        arn = aws_lb_target_group.restaurant_web.arn
        weight = 1
      }
    }
  }
}

resource "aws_lb_listener" "restaurant_service" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 3004
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.restaurant_service.arn
    forward {
      stickiness {
        duration = 3600
        enabled = false
      }

      target_group {
        arn = aws_lb_target_group.restaurant_service.arn
        weight = 1
      }
    }
  }
}

resource "aws_lb_listener" "mobile_service" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 6001
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mobile_service.arn
    forward {
      stickiness {
        duration = 3600
        enabled = false
      }

      target_group {
        arn = aws_lb_target_group.mobile_service.arn
        weight = 1
      }
    }
  }
}

resource "aws_lb_listener" "nginx_service_http" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_service.arn
    forward {
      stickiness {
        duration = 3600
        enabled = false
      }

      target_group {
        arn = aws_lb_target_group.nginx_service.arn
        weight = 1
      }
    }
  }
}

resource "aws_lb_listener" "notification" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 3003
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.notification.arn
    forward {
      stickiness {
        duration = 3600
        enabled = false
      }

      target_group {
        arn = aws_lb_target_group.notification.arn
        weight = 1
      }
    }
  }
}

# resource "aws_lb_listener" "user_service" {
#   load_balancer_arn = aws_lb.lb.arn
#   port              = 3005
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.user_service.arn
#   }
# }

resource "aws_lb_listener" "user_service" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 3005
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.user_service.arn
    forward {
      stickiness {
        duration = 3600
        enabled = false
      }

      target_group {
        arn = aws_lb_target_group.user_service.arn
        weight = 1
      }
    }
  }
}

resource "aws_lb_listener" "gift_service" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 3006
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gift_service.arn
    forward {
      stickiness {
        duration = 3600
        enabled = false
      }

      target_group {
        arn = aws_lb_target_group.gift_service.arn
        weight = 1
      }
    }
  }
}

resource "aws_lb_listener" "lb_https" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_service.arn
    forward {
      stickiness {
        duration = 3600
        enabled = false
      }

      target_group {
        arn = aws_lb_target_group.nginx_service.arn
        weight = 1
      }
    }
  }
}

resource "aws_lb_listener_rule" "auth_nginx_service_rule" {
  listener_arn = aws_lb_listener.lb_https.arn
  priority     = 1

  action {
    type             = "forward"
    # target_group_arn = aws_lb_target_group.nginx_service.arn
    forward {
    target_group {
      arn = aws_lb_target_group.nginx_service.arn
    }
    stickiness {
      duration = 3600
      enabled = false
    }
  }
  }


  condition {
    path_pattern {
      values = ["/auth/*"]
    }
  }
}

resource "aws_lb_listener_rule" "admin_web_nginx_service_rule" {
  listener_arn = aws_lb_listener.lb_https.arn
  priority     = 2

  action {
    type             = "forward"
    # target_group_arn = aws_lb_target_group.nginx_service.arn
    forward {
    target_group {
      arn = aws_lb_target_group.nginx_service.arn
    }
    stickiness {
      duration = 3600
      enabled = false
    }
  }
  }


  condition {
    path_pattern {
      values = ["/admin-web/*"]
    }
  }
}

resource "aws_lb_listener_rule" "restaurant_web_nginx_service_rule" {
  listener_arn = aws_lb_listener.lb_https.arn
  priority     = 3

  action {
    type             = "forward"
    # target_group_arn = aws_lb_target_group.nginx_service.arn
    forward {
    target_group {
      arn = aws_lb_target_group.nginx_service.arn
    }
    stickiness {
      duration = 3600
      enabled = false
    }
  }
  }


  condition {
    path_pattern {
      values = ["/restaurant-web/*"]
    }
  }
}

resource "aws_lb_listener_rule" "mobile_nginx_service_rule" {
  listener_arn = aws_lb_listener.lb_https.arn
  priority     = 4

  action {
    type             = "forward"
    # target_group_arn = aws_lb_target_group.nginx_service.arn
    forward {
    target_group {
      arn = aws_lb_target_group.nginx_service.arn
    }
    stickiness {
      duration = 3600
      enabled = false
    }
  }
  }


  condition {
    path_pattern {
      values = ["/mobile/*"]
    }
  }
}

resource "aws_lb_listener_rule" "notification_nginx_service_rule" {
  listener_arn = aws_lb_listener.lb_https.arn
  priority     = 5

  action {
    type             = "forward"
    forward {
    target_group {
      arn = aws_lb_target_group.nginx_service.arn
    }
    stickiness {
      duration = 3600
      enabled = false
    }
  }
  }


  condition {
    path_pattern {
      values = ["/notification/*"]
    }
  }
}

resource "aws_lb_listener_rule" "customer_support_nginx_service_rule" {
  listener_arn = aws_lb_listener.lb_https.arn
  priority     = 6

  action {
    type             = "forward"
    # target_group_arn = aws_lb_target_group.nginx_service.arn
    forward {
    target_group {
      arn = aws_lb_target_group.nginx_service.arn
    }
    stickiness {
      duration = 3600
      enabled = false
    }
  }
  }


  condition {
    path_pattern {
      values = ["/customer-support/*"]
    }
  }
}

resource "aws_lb_listener_rule" "gift_nginx_service_rule" {
  listener_arn = aws_lb_listener.lb_https.arn
  priority     = 8

  action {
    type             = "forward"
    # target_group_arn = aws_lb_target_group.nginx_service.arn
    forward {
    target_group {
      arn = aws_lb_target_group.nginx_service.arn
    }
    stickiness {
      duration = 3600
      enabled = false
    }
  }
  }


  condition {
    path_pattern {
      values = ["/gift/*"]
    }
  }
}

resource "aws_lb_listener_rule" "restaurant_nginx_service_rule" {
  listener_arn = aws_lb_listener.lb_https.arn
  priority     = 9

  action {
    type             = "forward"
    # target_group_arn = aws_lb_target_group.nginx_service.arn
    forward {
    target_group {
      arn = aws_lb_target_group.nginx_service.arn
    }
    stickiness {
      duration = 3600
      enabled = false
    }
  }
  }

  condition {
    path_pattern {
      values = ["/restaurant/*"]
    }
  }
}

resource "aws_lb_listener_rule" "user_nginx_service_rule" {
  listener_arn = aws_lb_listener.lb_https.arn
  priority     = 10

  action {
    type             = "forward"
    # target_group_arn = aws_lb_target_group.nginx_service.arn
    # order            = 1

    forward {
      target_group {
        arn    = aws_lb_target_group.nginx_service.arn
        weight = 1
      }

      stickiness {
        enabled  = false
        duration = 3600
      }
    }
  }

  condition {
    path_pattern {
      values = ["/user/*"]
    }
  }
}


resource "aws_lb_listener_rule" "accounting_nginx_service_rule" {
  listener_arn = aws_lb_listener.lb_https.arn
  priority     = 11

  action {
    type             = "forward"
    # target_group_arn = aws_lb_target_group.nginx_service.arn
  

    forward {
    target_group {
      arn = aws_lb_target_group.nginx_service.arn
    }
    stickiness {
      duration = 3600
      enabled = false
    }
  }
  }

  condition {
    path_pattern {
      values = ["/accounting/*"]
    }
  }
}

#######################################sg

resource "aws_security_group" "kowl_lb_sg" {
  name        = var.kowl_lb.sg_name

  description = var.kowl_lb.sg_description
  vpc_id      = var.vpc_id
 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  

  revoke_rules_on_delete = null
}


############################################kowlUI lb
resource "aws_lb" "kowlUI" {
  name               = var.kowl_lb.name
  load_balancer_type = var.kowl_lb.type  
  internal           = var.kowl_lb.internal
  ip_address_type    = var.kowl_lb.ip_address_type
  security_groups    = [aws_security_group.kowl_lb_sg.id]
  enable_deletion_protection =  var.kowl_lb.enable_deletion_protection
  idle_timeout = var.kowl_lb.idle_timeout
  # access_logs {
  #   enabled = true
  #   bucket = var.s3_lb_access_logs
    

  # }
  # connection_logs {
  #   enabled = var.kowl_lb.enable_connection_logs
  # }
  subnets = [
    var.private_subnet1,
    var.private_subnet2,
    var.private_subnet6
  ]
}


############################################
# TARGET GROUPS 
############################################
resource "aws_lb_target_group" "kowlUI_target_group" {
  name        = "${var.project_name}-${var.environment}-kowlUI-targetg"
  port        = var.kowl_lb.tg_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  lambda_multi_value_headers_enabled  = var.lb.lambda_multi_value_headers_enabled
  proxy_protocol_v2 = var.lb.proxy_protocol_v2

  health_check {
    protocol = "HTTP"
    path     = "/"
    port = var.kowl_lb.health_check_port
    healthy_threshold = var.lb.healthy_threshold
    unhealthy_threshold = var.lb.unhealthy_threshold
  }
  stickiness {
    cookie_duration = var.kowl_lb.cookie_duration
    enabled = var.kowl_lb.stickiness_enabled
    type = var.kowl_lb.stickiness_type
  }
  target_group_health {
    dns_failover {
        minimum_healthy_targets_count = "1"
        minimum_healthy_targets_percentage = "off"
      
     
  }
    unhealthy_state_routing {
      minimum_healthy_targets_count = "1"
        minimum_healthy_targets_percentage = "off"
      
    }
     
      # dns_failover {
      #   minimum_healthy_targets_count = "1"
      #   minimum_healthy_targets_percentage = "off"
      
     
  }
}


############################################
# HTTP LISTENERS 
############################################

resource "aws_lb_listener" "kowlUI_listener" {
  load_balancer_arn = aws_lb.kowlUI.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06" 
  certificate_arn   = var.kowl_certificate_arn


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kowlUI_target_group.arn
    forward {
      # stickiness {
      #   duration = 1
      #   enabled = false
      # }
     

      target_group {
        arn = aws_lb_target_group.kowlUI_target_group.arn
        weight = 1
      }
      # mutual_authentication {
      #   ignore_client_certificate_expiry = false
      #   mode = "off"
      # }
    }
       
      }
      # mutual_authentication {
      #   ignore_client_certificate_expiry = false
      #   mode = "off"
      # }
}

# resource "aws_lb_listener_rule" "kowlUI_listener_rule" {
#   listener_arn = aws_lb_listener.kowlUI_listener.arn
#   priority     = 99999

#   action {
#     type             = "forward"
#     # order = 0
#     # target_group_arn = aws_lb_target_group.nginx_service.arn
#     forward {
#     target_group {
#       arn = aws_lb_target_group.kowlUI_target_group.arn
#       weight = 1
#     }
#     # stickiness {
#     #   duration = 0
#     #   enabled = false
#     # }
#   }
#   }


#   # condition {
#   #   # path_pattern {
#   #   #   values = ["/restaurant-web/*"]
#   #   #   regex_values = []
#   #   # }
#   # }
# }

