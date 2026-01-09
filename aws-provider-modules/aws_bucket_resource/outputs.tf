#--------------------------------------------------
# Expose AWS_S3_BUCKET Attributes
#--------------------------------------------------
output "bucket_id" {
  description = "ID of the created S3 bucket"
  value       = try(aws_s3_bucket.this.id, null)
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = try(aws_s3_bucket.this.arn, null)
}