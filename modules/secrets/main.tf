resource "aws_secretsmanager_secret" "app_secrets" {
  name = "${var.secret.app_secrets_name}"
  recovery_window_in_days = 30
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
