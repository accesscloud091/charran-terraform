resource "aws_secretsmanager_secret" "app_secrets" {
  name = "${var.secret.app_secrets_name}"
  recovery_window_in_days = null
  force_overwrite_replica_secret = false
}