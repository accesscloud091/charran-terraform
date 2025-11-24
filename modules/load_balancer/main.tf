

# resource "aws_lb" "lb" {
#   name               = var.lb.name
#   load_balancer_type = var.lb.type  
#   internal           = false
#   ip_address_type    = var.lb.ip_address_type       
#   security_groups    = [aws_security_group.lb_sg.id]

#   subnets = [
#     var.public_subnet1,
#     var.public_subnet2,
#     var.public_subnet3
#   ]

# }


# locals {
#   tg_definitions = {
#     super_admin         = { port = var.lb.super_admin_port }
#     auth_service        = { port = var.lb.auth_service_port }
#     customer_support    = { port = var.lb.customer_support_port }
#     accounting_service  = { port = var.lb.accounting_service_port }
#     restaurant_web      = { port = var.lb.restaurant_web_port }
#     restaurant_service  = { port = var.lb.restaurant_service_port }
#     mobile_service      = { port = var.lb.mobile_service_port }
#     nginx_service       = { port = var.lb.nginx_service_port }
#     notification        = { port = var.lb.notification_port  }
#     user_service        = { port = var.lb.user_service_port  }
#     gift_service        = { port = var.lb.gift_service_port  }
#   }
# }

# resource "aws_lb_target_group" "lb_target_group" {
#   for_each = local.tg_definitions

#   name        = "${var.alb.target_name}-${each.key}"
#   port        = each.value.port
#   protocol    = "HTTP"
#   target_type = "ip"
#   vpc_id      = var.vpc_id

#   health_check {
#     protocol = "HTTP"
#     path     = "/"
#   }
# }

# resource "aws_lb_listener" "lb_listeners" {
#   for_each = {
#     6003 = "super_admin"
#     3001 = "auth_service"
#     3002 = "customer_support"
#     3000 = "accounting_service"
#     6002 = "restaurant_web"
#     3004 = "restaurant_service"
#     6001 = "mobile_service"
#     80   = "nginx_service"
#     3003 = "notification"
#     3005 = "user_service"
#     3006 = "gift_service"
#   }

#   load_balancer_arn = aws_lb.lb_sg.arn
#   port              = tonumber(each.key)
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.lb_target_group[each.value].arn
#   }
# }


# resource "aws_lb_listener" "lb_https" {
#   load_balancer_arn = aws_lb.lb_sg.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"

#   certificate_arn   = var.certificate_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.lb_target_group["nginx_service"].arn
#   }
# }


# resource "aws_lb_target_group_attachment" "attach" {
#   target_group_arn = aws_lb_target_group.lb_target_group["nginx_service"].arn
#   target_id        = "i-xxxxxxxx"
#   port             = 80
# }        


############################################
# ALB SECURITY GROUP
############################################

resource "aws_security_group" "lb_sg" {
  name        = "${var.environment}-${var.lb.sg_name}"
  description = "${var.environment}-${var.lb.sg_description}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3006
    to_port     = 3006
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3004
    to_port     = 3004
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 6003
    to_port     = 6003
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3005
    to_port     = 3005
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3003
    to_port     = 3003
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3002
    to_port     = 3002
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "HTTPS"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6002
    to_port     = 6002
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 6001
    to_port     = 6001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
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

  subnets = [
    var.public_subnet1,
    var.public_subnet2,
    var.public_subnet3
  ]
}


############################################
# TARGET GROUPS (ONE PER SERVICE)
############################################

locals {
  tg_definitions = {
    super_admin         = { port = var.lb.super_admin_port }
    auth_service        = { port = var.lb.auth_service_port }
    customer_support    = { port = var.lb.customer_support_port }
    accounting_service  = { port = var.lb.accounting_service_port }
    restaurant_web      = { port = var.lb.restaurant_web_port }
    restaurant_service  = { port = var.lb.restaurant_service_port }
    mobile_service      = { port = var.lb.mobile_service_port }
    nginx_service       = { port = var.lb.nginx_service_port }
    notification        = { port = var.lb.notification_port }
    user_service        = { port = var.lb.user_service_port }
    gift_service        = { port = var.lb.gift_service_port }
  }
}

resource "aws_lb_target_group" "lb_target_group" {
  for_each = local.tg_definitions

  name        = "${var.lb.target_name}-${var.environment}-${each.key}"
  port        = each.value.port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    protocol = "HTTP"
    path     = "/"
  }
}


############################################
# HTTP LISTENERS (Dynamic Loop)
############################################

resource "aws_lb_listener" "lb_listeners" {
  for_each = {
    6003 = "super_admin"
    3001 = "auth_service"
    3002 = "customer_support"
    3000 = "accounting_service"
    6002 = "restaurant_web"
    3004 = "restaurant_service"
    6001 = "mobile_service"
    80   = "nginx_service"
    3003 = "notification"
    3005 = "user_service"
    3006 = "gift_service"
  }

  load_balancer_arn = aws_lb.lb.arn
  port              = tonumber(each.key)
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group[each.value].arn
  }
}


############################################
# HTTPS LISTENER
############################################

resource "aws_lb_listener" "lb_https" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group["nginx_service"].arn
  }
}


############################################
# HTTPS PATH BASED ROUTING RULES
############################################

variable "https_path_rules" {
  type = list(string)
  default = [
    "/auth/*",
    "/admin-web/*",
    "/restaurant-web/*",
    "/mobile/*",
    "/notification/*",
    "/customer-support/*",
    "/gift/*",
    "/restaurant/*",
    "/user/*",
    "/accounting/*"
  ]
}

resource "aws_lb_listener_rule" "https_rules" {
  for_each = { for idx, path in var.https_path_rules : idx => path }

  listener_arn = aws_lb_listener.lb_https.arn
  priority     = each.key + 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group["nginx_service"].arn
  }

  condition {
    path_pattern {
      values = [each.value]
    }
  }
}
