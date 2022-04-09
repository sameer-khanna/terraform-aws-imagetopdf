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

#### AWS Architecture Diagram:

![AWS Architecture](https://github.com/sameer-khanna/terraform-aws-imagetopdf/blob/main/AWS%20Architecture%20Diagram.png)
