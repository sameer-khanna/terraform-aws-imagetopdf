data "aws_acm_certificate" "ssl_cert" {
  domain = var.acm_cert_domain
}

data "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_cloudfront_distribution" "cf_distribution" {
  origin {
    domain_name = data.aws_s3_bucket.s3_bucket.bucket_domain_name
    origin_id   = var.origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cf_oai.cloudfront_access_identity_path
    }
  }
  enabled = true

  default_root_object = var.root_object

  aliases = var.cf_alias
  default_cache_behavior {
    viewer_protocol_policy = var.viewer_protocol_policy
    allowed_methods        = var.allowed_methods
    cached_methods         = var.cached_methods
    target_origin_id       = var.origin_id
    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.restriction_type
    }
  }

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.ssl_cert.arn
    ssl_support_method  = var.ssl_support_method
  }

  custom_error_response {
    error_code         = 400
    response_page_path = "/index.html"
    response_code      = 200
  }

  custom_error_response {
    error_code         = 403
    response_page_path = "/index.html"
    response_code      = 200
  }

}

resource "aws_cloudfront_origin_access_identity" "cf_oai" {
  comment = var.oai_comment
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${data.aws_s3_bucket.s3_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.cf_oai.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = data.aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

