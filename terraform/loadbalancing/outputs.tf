output "web-alb-dns" {
  value = aws_lb.web_alb.dns_name
}

output "web-alb-zone-id" {
  value = aws_lb.web_alb.zone_id
}

output "availability-zone" {
  value = data.aws_autoscaling_group.app_asg.availability_zones
}

output "asg-name" {
  value = aws_autoscaling_group.app_asg.name
}