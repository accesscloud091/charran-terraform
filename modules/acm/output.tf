output "record_name" {
  value = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  
}

output "record_type" {
  value =  tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
  
}

output "record_value" {
  value = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value
  
}
output "certificate_arn" {
  value = aws_acm_certificate.cert.arn
}

output "kowl_certificate_arn" {
  value = aws_acm_certificate.cert_kowl.arn  
}