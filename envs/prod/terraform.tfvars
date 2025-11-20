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
    




}