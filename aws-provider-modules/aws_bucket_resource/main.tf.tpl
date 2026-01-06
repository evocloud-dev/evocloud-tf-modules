################################################################################
# AWS_S3_BUCKET Resource
################################################################################
resource "aws_s3_bucket" "this" {
  bucket              = var.values.bucket_name
  object_lock_enabled = true   # Enables Object Lock on the bucket | This argument is not supported in all regions or partitions.
}

#--------------------------------------------
# Enable Ownership Controls to AWS_S3_BUCKET
#--------------------------------------------
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#--------------------------------------------
# Associate ACLs to AWS_S3_BUCKET
#--------------------------------------------
# the following parameters sets up a private bucket
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#--------------------------------------------
# Policy to enable Public Access
#--------------------------------------------
{{- if $.Values.enable_public_access }}
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  
  policy = jsondecode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "PublicReadGetObject"
        Effect = "Allow"
        Principal = "*"
        Action  = "s3:GetObject"
        Resource  = "${aws_s3_bucket.this.arn}/*"
      }
    ]
  })
}
{{- end }}