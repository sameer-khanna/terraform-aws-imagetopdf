output "cf-dns" {
  value = aws_cloudfront_distribution.cf_distribution.domain_name
}

output "cf-zone-id" {
  value = aws_cloudfront_distribution.cf_distribution.hosted_zone_id
}
