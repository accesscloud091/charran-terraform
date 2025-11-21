# module "vpc" {
#   source = "../../modules/vpc"

#   name   = "opalink-prod-vpc"
#   cidr   = "172.20.0.0/16"

#   azs = ["us-east-1a", "us-east-1b", "us-east-1c"]

#   public_subnets = [
#     "172.20.1.0/24",
#     "172.20.2.0/24",
#     "172.20.3.0/24"
#   ]

#   private_app_subnets = [
#     "172.20.11.0/24",
#     "172.20.21.0/24",
#     "172.20.31.0/24"
#   ]

#   private_db_subnets = [
#     "172.20.12.0/24",
#     "172.20.22.0/24",
#     "172.20.32.0/24"
#   ]
# }


module "vpc" {
  source = "../../modules/vpc"
  vpc = var.vpc
}

# module "ecr" {
#   source = "../../modules/ecr"
#   ecr = var.ecr
  
# }

# module "ecs" {
#   source = "../../modules/ecs"
#   ecr = var.ecs
  
# }


module "route53" {
  source = "../../modules/route53"
  route53 = var.route53
  
}