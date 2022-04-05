output "rest-api-url" {
  value = "http://${module.dns.web-fqdn}"
}