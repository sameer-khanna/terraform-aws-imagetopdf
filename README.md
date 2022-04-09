# Image to PDF generator

This application takes in an image from the user and generates a PDF (containing that image) that can be downloaded. The application is built using Angular for the front-end and Spring boot for the REST API. The entire stack is deployed to AWS. The AWS Infrastructure is built using Terraform. 
* The REST API is deployed to EC2 instances (in an ASG) in private subnets behind an application load balancer (ALB) with it's nodes in the public subnets. It connects to a MySQL RDS instance in private DB subnets for saving and retrieving image metadata.
* The Angular code is deployed as a static website on a public S3 bucket. It connects to the REST API for uploading images and generating PDFs. The website is served to the users over SSL via Cloudfront with a custom domain name. Direct public access to the S3 bucket is not allowed. 
* The uploaded images and generated PDFs are stored in a private S3 bucket and the users are provided with a presigned S3 URL for downloading the generated PDFs.

#### Work in progress:
* Adding authentication to the application using Cognito web Identity federation.
* Dashboard for the users to view their image upload and generated PDF history.

#### Note:
There could be many things that can be improved in the Angular and Spring boot code but the basic idea was to create a simple CRUD application with primary focus on the AWS architecture and Terraform (IaC).

#### Terraform Modules: 
* **Networking** - For VPC and all the related networking. We are using the 10.16.0.0/16 CIDR for the VPC and 16 /20 subnets (4 each for web, app, db and reserved). The subnets are spread across 4 AZs for high availability. This also creates a Gateway endpoint for S3 and multiple Interface endpoints in the App subnets for connectivity using Sessions Manager.
* **Compute** - For the launch templates, EC2 instances, instance profiles and security groups. The compute module first builds launch templates complete with user data and other settings and uses that to launch app instances in their ASG. The EC2 instances are provisioned based on a custom AMI with JDK, MySQL client, Telnet and AWS CLI already baked in. If you like, you could provision a NAT Gateway and install all of these dependencies using EC2 user data instead. NAT Gateways are super expensive so I chose the AMI route; plus its quicker that way. The EC2 instances are provisioned in private subnets with no public IP addressing. The Spring boot API jar resides in an S3 bucket that is pulled by the EC2 instances (using the S3 gateway endpoint) during bootstrapping.
* **Load Balancing** -  For setting up the ASG, ALB, target group, target group attachments and listeners for the web tier. The ALB is public facing and accordingly it's nodes are in the public subnets. Using correct Security group rules, the ALB nodes in the public subnets are able to connect to the EC2 instances in the private subnets. The ALB serves traffic over SSL. 
* **CDN** -  For creating a Cloudfront distribution with the S3 bucket (that hosts the frontend Angular code) as the origin. It uses a custom domain name and serves traffic over SSL. It uses an Origin access identity (OAI) for authenticated access to the S3 bucket, thus the S3 bucket policy didn't have to allow public access. The S3 bucket is created manually and not managed using Terraform.
* **DNS** - For creating alias records to the web ALB (internet facing) and the Cloudfront distribution in an existing public hosted zone. 
* **Database** - For creating a subnet group (in the private DB subnets) and an RDS instance. The SQL scripts for creating the DB tables are executed using EC2 user data. This is a sample project and this made it easier. In Prod environments, your DBA could connect to an EC2 in one of the App subnets using Session Manager and execute scripts using the MySQL client already installed as part of the AMI.
* **Parameters** - For creating RDS related parameters in the Systems Manager Parameter Store. 
* **Root** - This is the root module for orchestrating the flow with the other modules. The values required by the modules are passed in dynamically from here, thus making them re-usable. 

#### AWS Architecture Diagram:
The diagram below shows 3 AZs for ease of viewing but in reality the VPC spans across 4 AZs. That setting is, of course, configurable though.  

![AWS Architecture](https://github.com/sameer-khanna/terraform-aws-imagetopdf/blob/main/AWS%20Architecture%20Diagram.png)
