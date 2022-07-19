output "lambda_arn" {
  value = aws_lambda_function.ec2_instance_refresh_lambda.arn
}

output "lambda_permission_id" {
  value = aws_lambda_permission.allow_bucket.id
}