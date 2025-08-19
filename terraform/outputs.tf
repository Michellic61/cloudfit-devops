output "public_ip" {
  value       = aws_instance.web.public_ip
  description = "Public IP of the EC2 instance"
}

output "public_dns" {
  value       = aws_instance.web.public_dns
  description = "Public DNS of the EC2 instance"
}

output "security_group_id" {
  value       = aws_security_group.web_sg.id
  description = "ID of the security group"
}

output "bucket_name" {
  value       = try(aws_s3_bucket.optional[0].bucket, null)
  description = "Name of the optional S3 bucket (if created)"
}
