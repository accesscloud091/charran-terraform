
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc.cidr_block

  tags = {
    Name = "opalink-prod"
  }

}


resource "aws_subnet" "opalink_prod_public_subnet" {
    vpc_id = aws_vpc.vpc.id
    availability_zone = var.vpc.subnet_availability_zone
    cidr_block = var.vpc.subnet_public_cidr


    tags = {
      Name = "opalink-prod-public-subnet1-useast-1a"
    }
}
resource "aws_subnet" "opalink_prod_public_subnet2" {
    vpc_id = aws_vpc.vpc.id
    availability_zone = var.vpc.subnet_availability_zone2
    cidr_block = var.vpc.subnet_public_cidr2


    tags = {
      Name = "opalink-prod-public-subnet2-useast-1b"
    }
}

resource "aws_subnet" "opalink_prod_public_subnet3" {
    vpc_id = aws_vpc.vpc.id
    availability_zone = var.vpc.subnet_availability_zone3
    cidr_block = var.vpc.subnet_public_cidr3


    tags = {
      Name = "opalink-prod-public-subnet3-useast-1c"
    }
}

resource "aws_subnet" "opalink_prod_pvt_subnet1" {
    vpc_id = aws_vpc.vpc.id
    availability_zone = var.vpc.subnet_availability_zone
    cidr_block = var.vpc.subnet_pvt_cidr1
    tags = {
      Name = "opalink-prod-private-subnet1-useast-1a-app"
    }
}

resource "aws_subnet" "opalink_prod_pvt_subnet4" {
    vpc_id = aws_vpc.vpc.id
    availability_zone = var.vpc.subnet_availability_zone
    cidr_block = var.vpc.subnet_pvt_cidr4
    tags = {
      Name = "opalink-prod-private-subnet4-useast-1a-db"
    }
}

resource "aws_subnet" "opalink_prod_pvt_subnet5" {
    vpc_id = aws_vpc.vpc.id
    availability_zone = var.vpc.subnet_availability_zone2
    cidr_block = var.vpc.subnet_pvt_cidr5
    tags = {
      Name = "opalink-prod-private-subnet5-useast-1b-db"
    }
}

