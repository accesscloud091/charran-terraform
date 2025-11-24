environment = "prod"


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
    accounting_cpu = "1024"
    memory = "2048"
    ecs_network_mode = "awsvpc"   
    desired_count = "1"
    ecs.deployment_strategy = "ROLLING"
   
   ####accounting task def
    accounting_container_name = "accounting" 
    accounting_port_mapping_name  = "accounting-prod-port"
    logs_region   = "us-east-1"
    create_cloudwatch_group = true
    accounting_requires_capabilities = "FARGATE"
    accounting_log_group_name = "/ecs/accounting-prod-task-defination"
    accounting_otel_collector_container_name  = "aws-otel-collector"
    accounting_otel_image_arn = "public.ecr.aws/aws-observability/aws-otel-collector:v0.43.3"

    #### accounting service
    accounting_ecs_service_name = 	"accounting-prod-service-8ia6ni4r"



}

task_definition_policy_name = "opalink-prod-secret-manager-policy"

ecs_task_definition_role_name = "opalink-prod-ecs-task-defination-role"

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

}

route53 = {
    hosted_zone_name = "opalinkapp.com"
    record_type = "A"

}

acm = {
    domain_name = "api.opalinkapp.com"
}



