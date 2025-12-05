variable "ecs" {
    type = any
}

variable "environment" {
    type = string
  
}

variable "region" {
    type = string
  
}

variable "project_name" {
    type = string
  
}
variable "accounting_service_image_arn" {
    type = string
  
}

variable "accounting_cloudwatch_log_name" {
    type = string
}

variable "accounting_otel_sidecar_collector" {
    type = string
  
}

variable "accounting_otel_image_url" {
    type = string
  
}
variable "app_secret_arn" {
    type = string
  
}
variable "accounting_service_image_repository_url" {
    type = string
  
}
variable "task_definition_policy_name" {
    type = string
  
}

# variable "accounting_requires_capabilities" {
#     type = string
# }
# variable "accounting_service_image_arn" {
#     type = string
# }


# variable "ecs_task_definition_role_name" {
#     type = string
  
# }

variable "private_subnet1" {
    type = string
  
}
variable "private_subnet2" {
    type = string
  
}
variable "private_subnet3" {
    type = string
  
}

variable "load_balancer_sg_id" {
    type = string
  
}
variable "vpc_id" {
    type = string
  
}

variable "accounting_target_group_arn" {
    type = string
  
}

variable "accounting_repository_url" {
    type = string
  
}

variable "auth_target_group_arn" {
    type = string
  
}

variable "customer_support_target_group_arn" {
    type = string
  
}

variable "gift_target_group_arn" {
    type = string
  
}

variable "mobile_target_group_arn" {
    type = string
  
}
variable "notification_target_group_arn" {
    type = string
  
}
variable "nginx_target_group_arn" {
    type = string
  
}

variable "restaurant_target_group_arn" {
    type = string
  
}
variable "private_subnet4" {
    type = string
  
}
variable "private_subnet5" {
    type = string
  
}

variable "private_subnet6" {
    type = string
  
}
variable "restaurant_web_target_group_arn" {
    type = string
  
}
variable "super_admin_target_group_arn" {
    type = string
  
}
variable "user_service_target_group_arn" {
    type = string
  
}
variable "kowl_target_group_arn" {
    type = string
  
}
variable "kowl_load_balancer_sg_id" {
    type = string
  
}