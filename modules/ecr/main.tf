resource "aws_ecr_repository" "accounting_prod" {
  name                 = var.ecr.ecr_name
  image_tag_mutability = var.ecr.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.ecr.scan_on_push
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}

################ auth ###############
resource "aws_ecr_repository" "auth" {
  name                 = var.ecr.auth_name
  image_tag_mutability = var.ecr.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.ecr.scan_on_push
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}

#################### customer-support ###################

resource "aws_ecr_repository" "customer_support" {
  name                 = var.ecr.customer_support_name
  image_tag_mutability = var.ecr.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.ecr.scan_on_push
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}

################ gift-prod ##################

resource "aws_ecr_repository" "gift" {
  name                 = var.ecr.gift_name
  image_tag_mutability = var.ecr.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.ecr.scan_on_push
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}

################## mobile #################

resource "aws_ecr_repository" "mobile" {
  name                 = var.ecr.mobile_name
  image_tag_mutability = var.ecr.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.ecr.scan_on_push
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}

############## notification ##############

resource "aws_ecr_repository" "notification" {
  name                 = var.ecr.notification_name
  image_tag_mutability = var.ecr.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.ecr.scan_on_push
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}

################ opalink/prod/nginx/auth ###############

resource "aws_ecr_repository" "nginx_auth" {
  name                 = var.ecr.nginx_auth_name
  image_tag_mutability = var.ecr.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.ecr.scan_on_push
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}


############## restaurant ##################

resource "aws_ecr_repository" "restaurant" {
  name                 = var.ecr.restaurant_name
  image_tag_mutability = var.ecr.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.ecr.scan_on_push
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}


####################  super-admin  ##################
resource "aws_ecr_repository" "super_admin" {
  name                 = var.ecr.super_admin_name
  image_tag_mutability = var.ecr.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.ecr.scan_on_push
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}

####################  user  ##################
resource "aws_ecr_repository" "user" {
  name                 = var.ecr.user_name
  image_tag_mutability = var.ecr.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.ecr.scan_on_push
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}


