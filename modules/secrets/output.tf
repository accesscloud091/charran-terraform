output "app_secret_arn" {
    value = aws_secretsmanager_secret.app_secrets.arn
  
}

output "accounting_secret_arn" {
    value = aws_secretsmanager_secret.accounting_secrets.arn
  
}
