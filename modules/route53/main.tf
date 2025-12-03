resource "aws_route53_zone" "zone" {
    name = var.route53.hosted_zone_name
    force_destroy = null
    comment = ""


}

resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = "api.${aws_route53_zone.zone.name}"
  type    = var.route53.record_type
  alias {
    name                   = var.lb_name   
    zone_id                = var.lb_zone_id    
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "api_cert_validation" {
  zone_id = aws_route53_zone.zone.zone_id

  name =  var.record_name 
  type  =  var.record_type 
  records = [ var.record_value ]



  ttl = 300    
}



