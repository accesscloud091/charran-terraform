resource "aws_s3_bucket" "alb_logs" {
  bucket = "${var.project_name}-${var.environment}-alb-logs-20250609"
  
}

resource "aws_s3_bucket_policy" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id
  policy = jsonencode({
    Statement = [
      {
        Action = "s3:PutObject"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::127311923021:root"
        }
        Resource = "${aws_s3_bucket.alb_logs.arn}/AWSLogs/${var.account_id}/*"
      },
      {
        Action = "s3:PutObject"
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Resource = "${aws_s3_bucket.alb_logs.arn}/AWSLogs/${var.account_id}/*"
      },
      {
        Action = "s3:GetBucketAcl"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::127311923021:root"
        }
        Resource = "${aws_s3_bucket.alb_logs.arn}"
      },
    ]
    Version = "2012-10-17"
})
}