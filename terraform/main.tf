data "template_file" "userdata" {
  template = file("${path.module}/appserveruserdata.tpl")
  vars = {
    rds_endpoint          = module.database.rds_dns,
    rds_username          = module.parameters.rds-master-username,
    rds_password          = module.parameters.rds-master-password,
    rds_dbname            = "imagetopdf",
    rds_connection_string = module.database.rds_connection_string
  }
}

module "networking" {
  source                = "./networking"
  vpc_cidr              = var.vpc_cidr
  enable_dns_hostnames  = true
  enable_dns_support    = true
  web_subnet_count      = 4
  app_subnet_count      = 4
  db_subnet_count       = 4
  reserved_subnet_count = 4
  web_cidr_blocks       = [for i in range(0, 4, 1) : cidrsubnet(var.vpc_cidr, 4, i)]
  app_cidr_blocks       = [for i in range(4, 8, 1) : cidrsubnet(var.vpc_cidr, 4, i)]
  db_cidr_blocks        = [for i in range(8, 12, 1) : cidrsubnet(var.vpc_cidr, 4, i)]
  reserved_cidr_blocks  = [for i in range(12, 16, 1) : cidrsubnet(var.vpc_cidr, 4, i)]
  max_subnetcount       = 20
  vpc_endpoints         = local.vpc_endpoints
  security_group_ids = [
    module.compute.app_security_group_id
  ]
  availability_zone = module.loadbalancing.availability-zone
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
}

module "compute" {
  source                  = "./compute"
  instance_type           = "t2.micro"
  vpc_id                  = module.networking.vpc_id
  security_groups         = local.security_groups
  app_user_data           = base64encode(data.template_file.userdata.rendered)
  sg_egress_cidr          = "0.0.0.0/0"
  sg_egress_from_port     = 0
  sg_egress_to_port       = 0
  sg_egress_Protocol      = "-1"
  app_sg_name             = "appSG"
  app_sg_description      = "Security group for the app servers"
  app_sg_from_port        = 0
  app_sg_to_port          = 0
  app_sg_protocol         = "-1"
  db_sg_name              = "dbSG"
  db_sg_description       = "Security group for the database"
  db_sg_from_port         = 3306
  db_sg_to_port           = 3306
  db_sg_protocol          = "TCP"
  iam_managed_policy_s3   = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  iam_managed_policy_ssm  = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ami_filter_name         = "amzn2-ami-hvm*"
  ami_filter_architecture = "x86_64"
  ami_owner               = "amazon"
  appserver_ami_id        = "ami-0b897cce8330e3647"
  rds_endpoint            = module.database.rds_dns
  rds_username            = module.parameters.rds-master-username
  rds_password            = module.parameters.rds-master-password
  iam_role_trust_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

module "loadbalancing" {
  source                             = "./loadbalancing"
  web_asg_max_size                   = 1
  web_asg_min_size                   = 1
  web_asg_desired_capacity           = 1
  availability_zones                 = module.networking.app-subnet-availability_zone_names
  web_security_group_ids             = module.compute.web_security-group-ids
  web_subnets                        = module.networking.web_subnet_ids
  web_listener_port                  = 443
  web_port                           = 8080
  web_protocol                       = "HTTPS"
  vpc_id                             = module.networking.vpc_id
  app_asg_max_size                   = 1
  app_asg_min_size                   = 1
  app_asg_desired_capacity           = 1
  app_launch_template_id             = module.compute.app-launch_template_id
  app_security_group_ids             = module.compute.app_security-group-ids
  app_subnets                        = module.networking.app-subnet.*.id
  app_port                           = 8080
  app_listener_port                  = 80
  app_protocol                       = "HTTP"
  gateway_endpoint_rt_association_id = module.networking.gateway_endpoint_rt_association_id
  rds_dns                            = module.database.rds_dns
  acm_cert_domain                    = "api.sameerkhanna.net"
}

module "dns" {
  source              = "./dns"
  web_alb_dns_zone_id = module.loadbalancing.web-alb-zone-id
  web_alb_dns_name    = module.loadbalancing.web-alb-dns
  hosted_zone         = "sameerkhanna.net."
  vpc_id              = module.networking.vpc_id
  cf-zone-id          = module.cdn.cf-zone-id
  cf-dns              = module.cdn.cf-dns
}

module "database" {
  source                 = "./database"
  subnet_ids             = module.networking.db_subnet_ids
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0.23"
  instance_class         = "db.t2.micro"
  name                   = "imagetopdf"
  identifier             = "imagetopdf"
  username               = module.parameters.rds-master-username
  password               = module.parameters.rds-master-password
  skip_final_snapshot    = true
  vpc_security_group_ids = [module.compute.db_security_group_id]
}

module "parameters" {
  source                 = "./parameters"
  db_username            = "admin"
  connection_string      = module.database.rds_connection_string
  asg_name               = module.loadbalancing.asg-name
  instance_warmup        = 60
  min_healthy_percentage = 90
  asg_refresh_strategy   = "Rolling"
}

module "cdn" {
  source                 = "./cdn"
  acm_cert_domain        = "web.sameerkhanna.net"
  s3_bucket_name         = "project.sameerkhanna.net"
  origin_id              = "s3_bucket"
  root_object            = "index.html"
  cf_alias               = ["web.sameerkhanna.net"]
  viewer_protocol_policy = "redirect-to-https"
  allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  cached_methods         = ["GET", "HEAD"]
  restriction_type       = "none"
  oai_comment            = "OAI for the project.sameerkhana.net S3 bucket"
  ssl_support_method     = "sni-only"
}

module "lambda" {
  source                                  = "./lambda"
  artifact_s3_bucket                      = "app-deployables-us"
  iam_managed_policy_cwlogs               = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  iam_managed_policy_ssm_readonly         = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  lambda_resource_policy_statement_id     = "AllowExecutionFromS3Bucket"
  lambda_resource_policy_action           = "lambda:InvokeFunction"
  lambda_resource_policy_principal        = "s3.amazonaws.com"
  instance_refresh_iam_policy_name_prefix = "Lambda-EC2InstanceRefresh"
  instance_refresh_iam_policy_statement = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "autoscaling:StartInstanceRefresh",
          "autoscaling:CancelInstanceRefresh"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  instance_refresh_iam_role_name_prefix = "Lambda-EC2InstanceRefresh"
  instance_refresh_iam_role_trust_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
  lambda_function_code_filename = "${path.root}/lambda_function.zip"
  lambda_function_handler       = "lambda_function.lambda_handler"
  lambda_function_runtime       = "python3.9"
  publish                       = true
}

module "storage" {
  source               = "./storage"
  lambda_arn           = module.lambda.lambda_arn
  lambda_permission_id = module.lambda.lambda_permission_id
}