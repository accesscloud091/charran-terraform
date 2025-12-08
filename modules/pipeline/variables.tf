variable "region" {
    type = string
  
}
variable "vpc_id" {
    type = string
  
}
variable "project_name" {
    type = string
  
}

variable "environment" {
    type = string
  
}

variable "accounting_secret_arn" {
    type = string
  
}
variable "account_id" {
    type = string
  
}

variable "provider_type" {
    type = string
  
} 

variable "service_role_path" {
    type = string
  
}
variable "pipeline" {
    type = any
  
}
variable "restaurant_secret_arn" {
    type = string
  
}
variable "restaurant_ecs_sg" {
    type = string
  
}
variable "openvpn_sg" {
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
variable "private_subnet4" {
    type = string
  
}
variable "private_subnet5" {
    type = string
  
}
variable "private_subnet6" {
    type = string
  
}

variable "ecs_cluster_name" {
    type = string
  
}
variable "accounting_service_name" {
    type = string
  
}
variable "restaurant_service_name" {
    type = string
  
}
variable "auth_secret_arn" {
    type = string
  
}

variable "load_balancer_sg_id" {
    type = string
  
}
variable "auth_service_name" {
    type = string
  
}

variable "gift_service_name" {
    type = string
  
}