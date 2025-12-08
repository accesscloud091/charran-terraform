resource "aws_s3_bucket" "s3_bucket_codepipeline" {
  bucket =  "codepipeline-${var.region}-70012dd85603-407e-918b-b915aa801171"
}


resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket_codepipeline.id
  policy = jsonencode({
    Statement = [
      {
        
        
        Sid = "DenyUnEncryptedObjectUploads",
        Effect = "Deny",
        Action = "s3:PutObject",
        Principal = "*"
        Resource = "${aws_s3_bucket.s3_bucket_codepipeline.arn}/*",
        Condition = {
          StringNotEquals = {
            "s3:x-amz-server-side-encryption": "aws:kms"
          }
        }
      },
       {
          Sid = "DenyInsecureConnections",
          Effect = "Deny",
          Principal = "*",
          Action = "s3:*",
          Resource = "${aws_s3_bucket.s3_bucket_codepipeline.arn}/*",
          Condition = {
              Bool = {
                    "aws:SecureTransport": "false"
      },
            }
          Id        = "SSEAndSSLPolicy"
       }
       
     
    ]
    Version = "2012-10-17",
    Id        = "SSEAndSSLPolicy"
})
}