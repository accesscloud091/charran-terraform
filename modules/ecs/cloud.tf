resource "aws_cloudwatch_log_group" "accounting" {
  name              = var.accounting_cloudwatch_log_name
#   retention_in_days = 30
}
         
resource "aws_cloudwatch_log_group" "accounting_otel_sidecar_collector" {
  name              = var.accounting_otel_sidecar_collector
#   retention_in_days = 30
}
    