resource "aws_secretsmanager_secret" "app_secrets" {
  name = "${var.secret.app_secrets_name}"
  recovery_window_in_days = null
  force_overwrite_replica_secret = null
}

resource "aws_secretsmanager_secret" "accounting_secrets" {
  name = "${var.project_name}/${var.environment}/accounting"
  recovery_window_in_days = null
  force_overwrite_replica_secret = null
}

resource "aws_secretsmanager_secret" "restaurant_secrets" {
  name = "${var.project_name}/${var.environment}/restaurant"
  description = "opalink/prod/restaurant"
  recovery_window_in_days = null
  force_overwrite_replica_secret = null
}

resource "aws_secretsmanager_secret" "auth_secrets" {
  name = "${var.project_name}/${var.environment}/auth"
  description = "opalink/prod/auth"
  recovery_window_in_days = null
  force_overwrite_replica_secret = null
}

resource "aws_secretsmanager_secret" "gift_secrets" {
  name = "${var.project_name}/${var.environment}/gift"
  recovery_window_in_days = null
  force_overwrite_replica_secret = null
}