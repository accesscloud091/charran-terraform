resource "aws_security_group" "codebuild_database_access_service_sg" {
  name        = "codebuild-database-access"
  description = "Allow code build to run migration scripts"
  vpc_id      = var.vpc_id
  tags = {}
 
egress           {
    cidr_blocks      = [
      "0.0.0.0/0",
                ]
    from_port        = 443
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 443
          
}      
egress   {
    cidr_blocks      = [
       "192.168.0.0/16",
                ]
    from_port        = 3306
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 3306
                
            }
}

resource "aws_security_group" "restaurant_service_sg" {
  name        = "${var.project_name}-${var.environment}-restaurant-sg-rds"
  description = "opalink-prod-restaurant-sg-rds"
  vpc_id      = var.vpc_id
  tags = {}

ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups  = [ var.openvpn_sg,
                         var.restaurant_ecs_sg,
                         aws_security_group.codebuild_database_access_service_sg.id ]
    self = false
  }


egress   {
    cidr_blocks      = [
       "0.0.0.0/0" ]
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = -1
    security_groups  = []
    self             = false
    to_port          = 0
                
            }

  


}