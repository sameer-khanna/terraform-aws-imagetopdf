data "aws_s3_bucket" "artifact_bucket" {
  bucket = "app-deployables-us"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = data.aws_s3_bucket.artifact_bucket.id

  lambda_function {
    lambda_function_arn = var.lambda_arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "image2pdfconverter-0.0.1-SNAPSHOT"
    filter_suffix       = ".jar"
  }
  lambda_function {
    lambda_function_arn = var.lambda_arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "application"
    filter_suffix       = ".properties"
  }

  depends_on = [var.lambda_permission_id]
}