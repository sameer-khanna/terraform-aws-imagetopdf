data "aws_s3_bucket" "artifact_bucket" {
  bucket = "app-deployables-us"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = data.aws_s3_bucket.artifact_bucket.id

  lambda_function {
    lambda_function_arn = var.lambda_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [var.lambda_permission_id]
}