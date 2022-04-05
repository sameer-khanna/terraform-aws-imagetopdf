output "rds_connection_string" {
  value     = "jdbc:mysql://${aws_db_instance.rds.address}/${var.name}?useSSL=false&amp"
  sensitive = true
}

output "rds_dns" {
  value     = aws_db_instance.rds.address
  sensitive = true
}