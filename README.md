# EC2 Nginx Deployment with Terraform

## Project Overview

This project uses Terraform to provision an Ubuntu EC2 instance on AWS and automatically install and configure the Nginx web server.

The infrastructure is deployed in the default VPC.

## Technologies Used

* AWS EC2
* AWS VPC
* AWS Security Groups
* Ubuntu 22.04 LTS
* Nginx
* Terraform

## Project Structure

```text
terraform-nginx-ubuntu/
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md
```

## Infrastructure Details

* AWS Region: ap-south-1
* Operating System: Ubuntu 22.04 LTS
* Instance Type: t2.micro
* VPC: Default VPC
* HTTP Port: 80
* SSH Port: 22
* Web Server: Nginx

## Prerequisites

1. An AWS account.
2. Terraform installed.
3. AWS CLI installed.
4. AWS credentials configured.

Configure AWS credentials using:

```bash
aws configure
```

Verify your AWS identity:

```bash
aws sts get-caller-identity
```

## Deployment Steps

### Step 1: Initialize Terraform

```bash
terraform init
```

### Step 2: Format the configuration

```bash
terraform fmt
```

### Step 3: Validate the configuration

```bash
terraform validate
```

### Step 4: Preview the infrastructure

```bash
terraform plan
```

### Step 5: Create the infrastructure

```bash
terraform apply
```

Review the proposed changes and enter `yes` when prompted.

### Step 6: Get the public IP address

```bash
terraform output public_ip
```

Get the website URL:

```bash
terraform output website_url
```

Open the website URL in a browser to verify the deployment.

## Expected Website Output

Welcome to the Terraform-managed Nginx Server on Ubuntu

## Destroy the Infrastructure

After testing the deployment, remove the resources managed by Terraform:

```bash
terraform destroy
```

Enter `yes` when prompted.

The EC2 instance and security group created by Terraform will be removed. The existing default VPC and its subnets will remain.

## Notes

* The EC2 instance installs Nginx using its user data script.
* HTTP access is allowed from the internet.
* SSH access is controlled by the ssh_allowed_cidr variable.
* For better security, restrict SSH access to your own public IP address.
* AWS charges may apply depending on account eligibility and current pricing.
