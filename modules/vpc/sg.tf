
resource "aws_security_group" "openvpn_sg" {
  name        = "OpenVPN Access Server / Self-Hosted VPN (BYOL)-2.13.1-AutogenByAWSMP--1"

  description = "OpenVPN Access Server / Self-Hosted VPN (BYOL)-2.13.1-AutogenByAWSMP--1 created 2025-05-05T07:49:22.856Z"
  vpc_id      = aws_vpc.vpc.id
 
  ingress {
    from_port   = 945
    to_port     = 945
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }

  ingress {
    from_port   = 943
    to_port     = 943
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self = false 
  }
  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

 

  revoke_rules_on_delete = null
}
