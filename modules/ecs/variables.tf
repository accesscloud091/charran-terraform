variable "ecs" {
    type = any
}

variable "task_definition_policy_name" {
    type = string
  
}

variable "accounting_requires_capabilities" {
    type = string
}
variable "accounting_service_image_arn" {
    type = string
}

variable "aws_secret_value_arn" {
    type = string
}

variable "ecs_task_definition_role_name" {
    type = string
  
}

variable "private_subnet1" {
    type = string
  
}
variable "private_subnet2" {
    type = string
  
}
variable "private_subnet3" {
    type = string
  
}