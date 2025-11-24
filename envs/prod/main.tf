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

module "load_balancer" {
  source = "../../modules/load_balancer"
  lb = var.lb 
  environment = var.environment
  vpc_id = module.vpc.vpc_id
  public_subnet1 = module.vpc.public_subnet1
  public_subnet2 = module.vpc.public_subnet2
  public_subnet3 = module.vpc.public_subnet3
}

module "route53" {
  source = "../../modules/route53"
  route53 = var.route53
  lb_name =  module.load_balancer.lb_name
  lb_zone_id = module.load_balancer.lb_zone_id
  record_name = module.acm.record_name
  record_type = module.acm.record_type
  record_value = module.acm.record_value
}

module "acm" {
  source = "../../modules/acm"
  acm = var.acm
  environment = var.environment
  validation_record_fqdns = module.route53.validation_record_fqdns

}