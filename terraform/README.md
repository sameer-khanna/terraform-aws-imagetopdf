# The Terraform code has the following modules - 
* **Networking** - For VPC and all the related networking. We are using the 10.16.0.0/16 CIDR for the VPC and 16 /20 subnets (4 each for web, app, db and reserved). The subnets are spread across 4 AZs for high availability. This also creates a Gateway endpoint for S3 and multiple Interface endpoints in the App subnets for Sessions Manager.
* **Compute** - For the launch templates, EC2 instances, instance profiles and security groups. The compute module first builds launch templates complete with user data and other settings and uses that to launch app instances in their ASG. The Spring boot API code resides in an S3 bucket that is pulled by the EC2 instances during bootstrapping.
* **Load Balancing** -  For setting up the ASG, ALB, target group, target group attachments and listeners for the web tier. 
* **DNS** - This is for creating an alias record to the web ALB (internet facing) in an existing public hosted zone. 
* **Database** - This is for creating a subnet group and an RDS instance.
* **Parameters** - This is for creating RDS related parameters in the Systems Manager Parameter Store. 
* **Root** - This is the root module for orchestration between the other modules. The dynamic values are passed in from here to the modules. This makes the modules re-usable. 
