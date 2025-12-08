output "restaurant_ecs_sg" {
    value = aws_security_group.restaurant_service_sg.id
  
}
output "ecs_cluster_name" {
    value = aws_ecs_cluster.ecs_cluster.name
  
}
output "accounting_service_name" {
    value = aws_ecs_service.accounting.name 
  
}
output "restaurant_service_name" {
    value = aws_ecs_service.restaurant_service.name
  
}
output "auth_service_name" {
    value = aws_ecs_service.auth_service.name
  
}