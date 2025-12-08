output "app_secret_arn" {
    value = aws_secretsmanager_secret.app_secrets.arn
  
}

output "accounting_secret_arn" {
    value = aws_secretsmanager_secret.accounting_secrets.arn
  
}

output "restaurant_secret_arn" {
    value = aws_secretsmanager_secret.restaurant_secrets.name
  
}
output "auth_secret_arn" {
    value = aws_secretsmanager_secret.auth_secrets.name
  
}

output "gift_secret_arn" {
    value = aws_secretsmanager_secret.gift_secrets
  
}