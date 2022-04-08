output "frontend-url" {
  value = "https://${module.dns.web-fqdn}/home"
}

output "rest-api-url" {
  value = "https://${module.dns.api-fqdn}"
}