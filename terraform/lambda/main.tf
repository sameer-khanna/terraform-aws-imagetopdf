data "aws_s3_bucket" "artifact_bucket" {
  bucket = var.artifact_s3_bucket
}

data "aws_iam_policy" "cloudwatch_logs" {
  arn = var.iam_managed_policy_cwlogs
}

data "aws_iam_policy" "ssm_read_only" {
  arn = var.iam_managed_policy_ssm_readonly
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = var.lambda_resource_policy_statement_id
  action        = var.lambda_resource_policy_action
  function_name = aws_lambda_function.ec2_instance_refresh_lambda.arn
  principal     = var.lambda_resource_policy_principal
  source_arn    = data.aws_s3_bucket.artifact_bucket.arn
}

resource "aws_iam_policy" "ec2_instance_refresh" {
  name_prefix = var.instance_refresh_iam_policy_name_prefix
  policy      = var.instance_refresh_iam_policy_statement
}

resource "aws_iam_role" "lambda_ec2_instance_refresh" {
  name_prefix         = var.instance_refresh_iam_role_name_prefix
  managed_policy_arns = [data.aws_iam_policy.cloudwatch_logs.arn, data.aws_iam_policy.ssm_read_only.arn, aws_iam_policy.ec2_instance_refresh.arn]
  assume_role_policy  = var.instance_refresh_iam_role_trust_policy
}

resource "aws_lambda_function" "ec2_instance_refresh_lambda" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_ec2_instance_refresh.arn
  filename      = var.lambda_function_code_filename
  handler       = var.lambda_function_handler
  runtime       = var.lambda_function_runtime
  publish       = var.publish
}