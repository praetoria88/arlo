output "ec2_instance_id" {
  value = aws_instance.api_server.id
}

output "rds_endpoint" {
  value = aws_db_instance.sql_server.address
}

output "bucket_name" {
  value = aws_s3_bucket.artifact_bucket.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.artifact_bucket.arn
}