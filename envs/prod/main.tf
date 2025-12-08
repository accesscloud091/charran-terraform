module "vpc" {
  source = "../../modules/vpc"
  vpc = var.vpc
  environment = var.environment
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
  restaurant_target_group_arn = module.load_balancer.restaurant_target_group_arn
  private_subnet4 = module.vpc.private_subnet4
  private_subnet5 = module.vpc.private_subnet5
  private_subnet6 = module.vpc.private_subnet6
  restaurant_web_target_group_arn = module.load_balancer.restaurant_web_target_group_arn
  super_admin_target_group_arn = module.load_balancer.super_admin_target_group_arn
  user_service_target_group_arn = module.load_balancer.user_service_target_group_arn
  kowl_target_group_arn = module.load_balancer.kowl_target_group_arn
  kowl_load_balancer_sg_id = module.load_balancer.kowl_load_balancer_sg_id

}

module "load_balancer" {
  source = "../../modules/load_balancer"
  lb = var.lb 
  environment = var.environment
  region = var.region
  project_name = var.project_name
  kowl_lb = var.kowl_lb
  vpc_id = module.vpc.vpc_id
  kowl_certificate_arn = module.acm.kowl_certificate_arn
  public_subnet1 = module.vpc.public_subnet1
  public_subnet2 = module.vpc.public_subnet2
  public_subnet3 = module.vpc.public_subnet3
  certificate_arn = module.acm.certificate_arn
  private_subnet1 = module.vpc.private_subnet1
  private_subnet2 = module.vpc.private_subnet2
  private_subnet6 = module.vpc.private_subnet6
  lb_s3_logs_bucket = module.s3.lb_s3_logs_bucket
}

module "route53" {
  source = "../../modules/route53"
  route53 = var.route53
  lb_name =  module.load_balancer.lb_name
  lb_zone_id = module.load_balancer.lb_zone_id
  record_name = module.acm.record_name
  record_type = module.acm.record_type
  record_value = module.acm.record_value
  kowl_lb_name = module.load_balancer.kowl_lb_name
  kowl_lb_zone_id = module.load_balancer.kowl_lb_zone_id
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
  vpc_id = module.vpc.vpc_id
  region = var.region
  provider_type = var.provider_type
  project_name = var.project_name
  accounting_secret_arn = module.secrets.accounting_secret_arn
  service_role_path = var.service_role_path
  restaurant_secret_arn = module.secrets.restaurant_secret_arn
  restaurant_ecs_sg = module.ecs.restaurant_ecs_sg
  openvpn_sg = module.vpc.openvpn_sg
  private_subnet1 = module.vpc.private_subnet1
  private_subnet2 = module.vpc.private_subnet2
  private_subnet3 = module.vpc.private_subnet3
  private_subnet4 = module.vpc.private_subnet4
  private_subnet5 = module.vpc.private_subnet5
  private_subnet6 = module.vpc.private_subnet6
  ecs_cluster_name = module.ecs.ecs_cluster_name
  accounting_service_name = module.ecs.accounting_service_name
  restaurant_service_name = module.ecs.restaurant_service_name
  auth_secret_arn = module.secrets.auth_secret_arn
  load_balancer_sg_id = module.load_balancer.load_balancer_sg_id
  auth_service_name = module.ecs.auth_service_name
  gift_service_name = module.ecs.gift_service_name


  

}

module "s3" {
  source = "../../modules/s3"
  project_name = var.project_name
  environment = var.environment
  account_id = var.account_id

  
}