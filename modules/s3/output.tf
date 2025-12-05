output "lb_s3_logs_bucket" {
    value = aws_s3_bucket.alb_logs.id
  
}