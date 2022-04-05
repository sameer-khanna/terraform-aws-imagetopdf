data "aws_route53_zone" "primary-hosted-zone" {
  name         = var.hosted_zone
  private_zone = false
}

resource "aws_route53_record" "sampleproject" {
  zone_id = data.aws_route53_zone.primary-hosted-zone.zone_id
  name    = "sampleproject-${substr(uuid(), 0, 4)}.${data.aws_route53_zone.primary-hosted-zone.name}"
  type    = "A"
  lifecycle {
    ignore_changes = [name]
  }
  alias {
    name                   = var.web_alb_dns_name
    zone_id                = var.web_alb_dns_zone_id
    evaluate_target_health = true
  }
}

