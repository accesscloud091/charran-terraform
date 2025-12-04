output "lb_name" {
    value = aws_lb.lb.dns_name
}

output "lb_zone_id" {
    value = aws_lb.lb.zone_id 
}

output "accounting_service_tg" {
    value = aws_lb_target_group.accounting_service.arn
  
}
output "load_balancer_sg_id" {
    value = aws_security_group.lb_sg.id
  
}
output "accounting_target_group_arn" {
    value = aws_lb_target_group.accounting_service.arn
  
}

output "auth_target_group_arn" {
    value = aws_lb_target_group.auth_service.arn
  
}

output "customer_support_target_group_arn" {
    value = aws_lb_target_group.customer_support.arn
  
}

output "gift_target_group_arn" {
    value = aws_lb_target_group.gift_service.arn
  
}

output "mobile_target_group_arn" {
    value = aws_lb_target_group.mobile_service.arn
  
}

output "notification_target_group_arn" {
    value = aws_lb_target_group.notification.arn
  
}

output "nginx_target_group_arn" {
    value = aws_lb_target_group.nginx_service.arn
  
}

output "restaurant_target_group_arn" {
    value =  aws_lb_target_group.restaurant_service.arn
}

output "restaurant_web_target_group_arn" {
    value = aws_lb_target_group.restaurant_web.arn
  
}

output "super_admin_target_group_arn" {
    value = aws_lb_target_group.super_admin.arn
  
}
output "user_service_target_group_arn" {
    value = aws_lb_target_group.user_service.arn
  
}

# output "kowl_target_group_arn" {
#     value = aws_lb_target_group.
  
# }

output "kowl_lb_name" {
    value = aws_lb.kowlUI.dns_name
  
}

output "kowl_lb_zone_id" {
    value = aws_lb.kowlUI.zone_id
  
}