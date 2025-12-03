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