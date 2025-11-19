
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc.cidr_block

  tags = {
    Name = "opalink-prod"
  }

}


#####public subnet################
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


#######private subnet###################
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

resource "aws_subnet" "opalink_prod_pvt_subnet2" {
    vpc_id = aws_vpc.vpc.id
    availability_zone = var.vpc.subnet_availability_zone2
    cidr_block = var.vpc.subnet_pvt_cidr2
    tags = {
      Name = "opalink-prod-private-subnet2-useast-1b-app"
    }
}

resource "aws_subnet" "opalink_prod_pvt_subnet6" {
    vpc_id = aws_vpc.vpc.id
    availability_zone = var.vpc.subnet_availability_zone3
    cidr_block = var.vpc.subnet_pvt_cidr6
    tags = {
      Name = "opalink-prod-private-subnet6-useast-1c-db"
    }
}

resource "aws_subnet" "opalink_prod_pvt_subnet3" {
    vpc_id = aws_vpc.vpc.id
    availability_zone = var.vpc.subnet_availability_zone3
    cidr_block = var.vpc.subnet_pvt_cidr3
    tags = {
      Name = "opalink-prod-private-subnet3-useast-1c-app"
    }
}


##############route table #######################
resource "aws_route_table" "prod_public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "opalink-prod-public-route-table"
  }
}

    
#############  route  #######################
resource "aws_route" "prod_public_route" {
  route_table_id         = aws_route_table.prod_public_route_table.id
  destination_cidr_block = var.vpc.destination_cidr_block
  gateway_id = aws_internet_gateway.prod_internet_gateway.id
}


################## internet gateway ####################

resource "aws_internet_gateway" "prod_internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "opalink-production-internet-gateway"
  }
 
}

############# route table associate (public) ###################

resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.opalink_prod_public_subnet.id
  route_table_id = aws_route_table.prod_public_route_table.id
}

resource "aws_route_table_association" "public_rt_assoc2" {
  subnet_id      = aws_subnet.opalink_prod_public_subnet2.id
  route_table_id = aws_route_table.prod_public_route_table.id
}

resource "aws_route_table_association" "public_rt_assoc3" {
  subnet_id      = aws_subnet.opalink_prod_public_subnet3.id
  route_table_id = aws_route_table.prod_public_route_table.id
}


# ################ route table (private) ##################

resource "aws_route_table" "prod-private-route-table-app" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "opalink-prod-private-route-table-app"
  }
}

################### route route (private) ####################

resource "aws_route" "prod_private_route_table_app" {
  route_table_id         = aws_route_table.prod-private-route-table-app.id
  destination_cidr_block = var.vpc.nat_destination_cidr_block
  nat_gateway_id = aws_nat_gateway.nat_gateway.id
}


################ route table association (private) #################

resource "aws_route_table_association" "private_route_table_app_association1" {
  subnet_id      = aws_subnet.opalink_prod_pvt_subnet1.id
  route_table_id = aws_route_table.prod-private-route-table-app.id
}

resource "aws_route_table_association" "private_route_table_app_association2" {
  subnet_id      = aws_subnet.opalink_prod_pvt_subnet2.id
  route_table_id = aws_route_table.prod-private-route-table-app.id
}

resource "aws_route_table_association" "private_route_table_app_association3" {
  subnet_id      = aws_subnet.opalink_prod_pvt_subnet3.id
  route_table_id = aws_route_table.prod-private-route-table-app.id
}


###################### route table (db) ##################

resource "aws_route_table" "prod-private-route-table-db" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "opalink-prod-private-route-table-db"
  }
}

################ route (db) #################

resource "aws_route" "prod-private-route-table-db" {
  route_table_id         = aws_route_table.prod-private-route-table-db.id
  destination_cidr_block = var.vpc.nat_destination_cidr_block
  nat_gateway_id = aws_nat_gateway.nat_gateway.id
}

################ route table association (db) #################

resource "aws_route_table_association" "private_rt_assoc_db4" {
  subnet_id      = aws_subnet.opalink_prod_pvt_subnet4.id
  route_table_id = aws_route_table.prod-private-route-table-db.id
}

resource "aws_route_table_association" "private_rt_assoc_db5" {
  subnet_id      = aws_subnet.opalink_prod_pvt_subnet5.id
  route_table_id = aws_route_table.prod-private-route-table-db.id
}
resource "aws_route_table_association" "private_rt_assoc_db6" {
  subnet_id      = aws_subnet.opalink_prod_pvt_subnet6.id
  route_table_id = aws_route_table.prod-private-route-table-db.id
}


resource "aws_nat_gateway" "nat_gateway" {
  subnet_id = aws_subnet.opalink_prod_public_subnet.id
  allocation_id = aws_eip.nat_eip.id 

  tags = {
    Name = "opalink-prod-nat-gateway"
  }
  
}

resource "aws_eip" "nat_eip" {
  # vpc = true
}
