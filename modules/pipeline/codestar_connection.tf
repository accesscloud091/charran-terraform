resource "aws_codestarconnections_connection" "codestar_connection" {
  name          = "github-${var.project_name}-${var.environment}-connection"
  provider_type = var.provider_type
}