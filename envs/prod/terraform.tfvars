environment = "prod"
region = "us-east-1"
account_id = "263427518575"
project_name = "opalink"


provider_type = "GitHub"


vpc = {
    cidr_block = "192.168.0.0/16"

    availability_zone = "us-east-1"
    subnet_public_cidr = "192.168.10.0/24"
    subnet_public_cidr2 = "192.168.40.0/24"
    subnet_public_cidr3 = "192.168.70.0/24"
    subnet_pvt_cidr1 = "192.168.100.0/24"
    subnet_pvt_cidr4 = "192.168.190.0/24"
    subnet_pvt_cidr5 = "192.168.220.0/24"
    subnet_pvt_cidr2 = "192.168.130.0/24"
    subnet_pvt_cidr6 = "192.168.250.0/24"
    subnet_pvt_cidr3 = "192.168.160.0/24"
    
    subnet_availability_zone = "us-east-1a"
    subnet_availability_zone2 = "us-east-1b"
    subnet_availability_zone3 = "us-east-1c"

    destination_cidr_block = "0.0.0.0/0"
    nat_destination_cidr_block = "0.0.0.0/0"
    
}

ecr = {
    ecr_name = "accounting-prod"
    image_tag_mutability = "MUTABLE"
    scan_on_push = false

    auth_name = "auth-prod"
    customer_support_name = "customer-support-prod"
    gift_name = "gift-prod"
    mobile_name = "mobile-prod"
    notification_name = "notification-prod"
    nginx_auth_name = "opalink/prod/nginx/auth"
    restaurant_name = "resturant-prod"
    super_admin_name ="super-admin-prod"
    user_name = "user-prod"


}

ecs = {
    cluster_name = "ProdCluster"
    accounting_task_family = "accounting-prod-task-defination"
    cpu = 1024
    memory = 2048
    desired_count = 1
    deployment_strategy = "ROLLING"
    enable_ecs_managed_tags = true
    enable_execute_command = true
    create_cloudwatch_group = true
    enable_fault_injection = false
    network_mode = "awsvpc"

   
    logs_region   = "us-east-1"
    
    otel_collector_container_name  = "aws-otel-collector"
    otel_collector_image_arn = "public.ecr.aws/aws-observability/aws-otel-collector:v0.43.3"
    otel_collector_log_group_name = "/ecs/ecs-aws-otel-sidecar-collector"


    #### accounting service
    accounting_ecs_service_name = 	"accounting-prod-service-8ia6ni4r" 
    accounting_requires_capabilities = "FARGATE"
    accounting_log_group_name = "/ecs/accounting-prod-task-defination"
    accounting_container_name = "accounting"
    accounting_task_definition_revision = 93


    ################auth
    auth_container_name = "auth"
    auth_task_definition_revision = 84

    ################customer
    customer_container_name =  "customer-support"

    gift_container_name = "gift"
    gift_enable_execute_command = false


    ###################### kowlUI
    kowlUI_otel_collector_image_arn = "public.ecr.aws/aws-observability/aws-otel-collector:v0.43.2" 
    kowl_container_name = "kowl"


    #####################mobile
    mobile_container_name = "mobile"
    mobile_enable_execute_command = false

    ################### notification
    notification_container_name = "notification"
    notification_enable_execute_command = true


    ########################  nginx
    nginx_container_name = "nginx"

    ####################### restaurant
    restaurant_container_name = "restaurant"








}

task_definition_policy_name = "opalink-prod-secret-manager-policy"

# ecs_task_definition_role_name = "opalink-prod-ecs-task-defination-role"

lb = {
    name = "opalink-prod-load-balancer"
    type  = "application"
    ip_address_type  = "ipv4"
    sg_description = "ecs-load-balancer-sg"
    sg_name = "ecs-load-balancer-sg"
    target_name = "opalink"
    super_admin_port = 6003
    auth_service_port = 3001
    customer_support_port = 3002
    accounting_service_port = 3000
    restaurant_web_port = 6002
    restaurant_service_port = 3004
    mobile_service_port = 6001
    nginx_service_port = 80
    notification_port = 3003
    user_service_port = 3005
    gift_service_port = 3006
   

    healthy_threshold = 5
    unhealthy_threshold = 2
    proxy_protocol_v2 = null
    lambda_multi_value_headers_enabled = null
    enable_deletion_protection = true
    idle_timeout = 120

}

route53 = {
    hosted_zone_name = "opalinkapp.com"
    record_type = "A"

}

acm = {
    domain_name = "api.opalinkapp.com"
}


secret = {
    app_secrets_name = "opalink/prod/app-secreats"
}

accounting_cloudwatch_log_name = "/ecs/accounting-prod-task-defination"
accounting_otel_sidecar_collector = "/ecs/ecs-aws-otel-sidecar-collector"
accounting_otel_image_url = "public.ecr.aws/aws-observability/aws-otel-collector:v0.43.3"

service_role_path = "/service-role/"


pipeline = {
    codepipeline_type = "V2"
    build_timeout = 60
    execution_mode = "QUEUED"
    pipeline_action_mode  = "REPLACE_ON_FAILURE"



}