output "web-fqdn" {
  value = aws_route53_record.web.fqdn
}

output "api-fqdn" {
  value = aws_route53_record.api.fqdn
}
