module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name   = var.name
  cidr   = var.cidr
  azs    = var.azs

  public_subnets  = var.public_subnets
  private_subnets = var.private_app_subnets
  database_subnets = var.private_db_subnets

  enable_nat_gateway     = true
  one_nat_gateway_per_az = true

  create_database_subnet_group = true
}
