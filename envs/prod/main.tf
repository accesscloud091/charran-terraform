module "vpc" {
  source = "../../modules/vpc"
  vpc = var.vpc
}

module "ecr" {
  source = "../../modules/ecr"
  ecr = var.ecr
  
}

module "ecs" {
  source = "../../modules/ecs"
  ecs = var.ecs
  environment = var.environment
  region = var.region
  customer_support_target_group_arn = module.load_balancer.customer_support_target_group_arn
  project_name = var.project_name
  accounting_service_image_arn = module.ecr.accounting_repository_arn
  accounting_cloudwatch_log_name = var.accounting_cloudwatch_log_name
  accounting_otel_sidecar_collector = var.accounting_otel_sidecar_collector
  app_secret_arn = module.secrets.app_secret_arn
  accounting_otel_image_url = var.accounting_otel_image_url
  accounting_service_image_repository_url = module.ecr.accounting_repository_url
  task_definition_policy_name = var.task_definition_policy_name
  # ecs_task_definition_role_name = var.ecs_task_definition_role_name
  load_balancer_sg_id = module.load_balancer.load_balancer_sg_id
  vpc_id = module.vpc.vpc_id
  private_subnet1 = module.vpc.private_subnet1
  private_subnet2 = module.vpc.private_subnet2
  private_subnet3 = module.vpc.private_subnet3
  accounting_target_group_arn = module.load_balancer.accounting_target_group_arn
  accounting_repository_url = module.ecr.accounting_repository_url
  auth_target_group_arn = module.load_balancer.auth_target_group_arn
  gift_target_group_arn = module.load_balancer.gift_target_group_arn
  mobile_target_group_arn = module.load_balancer.mobile_target_group_arn
  notification_target_group_arn = module.load_balancer.notification_target_group_arn
  nginx_target_group_arn = module.load_balancer.nginx_target_group_arn
}

module "load_balancer" {
  source = "../../modules/load_balancer"
  lb = var.lb 
  environment = var.environment
  region = var.region
  vpc_id = module.vpc.vpc_id
  public_subnet1 = module.vpc.public_subnet1
  public_subnet2 = module.vpc.public_subnet2
  public_subnet3 = module.vpc.public_subnet3
  certificate_arn = module.acm.certificate_arn
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

module "secrets" {
  source = "../../modules/secrets"
  secret = var.secret
  environment = var.environment
  project_name = var.project_name
  
}

module "pipeline" {
  source = "../../modules/pipeline"
  pipeline = var.pipeline
  account_id = var.account_id 
  environment = var.environment
  region = var.region
  provider_type = var.provider_type
  project_name = var.project_name
  accounting_secret_arn = module.secrets.accounting_secret_arn
  service_role_path = var.service_role_path
}