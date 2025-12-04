resource "aws_acm_certificate" "cert" {
  domain_name       = var.acm.domain_name
  validation_method = "DNS"

  tags = {
    environment = var.environment
  }
}



# Validate the certificate

resource "aws_acm_certificate_validation" "api_cert_validation_complete" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [ var.validation_record_fqdns ]
}



resource "aws_acm_certificate" "cert_kowl" {
  domain_name       = var.acm.kowl_domain_name
  validation_method = "DNS"

  tags = {
    environment = var.environment
  }
}



# Validate the certificate

resource "aws_acm_certificate_validation" "kowl_validation" {
  certificate_arn         = aws_acm_certificate.cert_kowl.arn
  validation_record_fqdns = [ var.validation_record_fqdns ]
}



