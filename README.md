
# Terraform Infrastructure Template

This repository contains a Terraform configuration for deploying a secure infrastructure setup on AWS. The configuration sets up an EC2 instance within a private subnet, an RDS MySQL database, API Gateway, VPC, and required security groups for proper access control. This setup is ideal for building a secure environment where an EC2 instance (e.g., an app server) is protected from the internet and accessed through API Gateway.

## Features

- **Amazon VPC** with private and public subnets.
- **Security Groups** to control access between services.
- **EC2 Instances**:
  - One for the Bastion Host (public subnet, SSH access).
  - One for the application server (private subnet, no public access).
- **API Gateway** for secure access to the private EC2 instance.
- **RDS MySQL Database** for storing application data.
- **IAM Role and Policies** for necessary permissions during deployment.

## Requirements

- Terraform v1.0 or later.
- AWS Account with necessary IAM permissions for creating and managing:
  - VPCs, subnets, security groups, EC2 instances, RDS databases, API Gateway, and IAM roles.

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/terraform-aws-infrastructure.git
cd terraform-aws-infrastructure
```

### 2. Configure AWS Credentials

Ensure that your AWS credentials are set up on your local machine. You can configure them using the AWS CLI:

```bash
aws configure
```

Alternatively, you can set your credentials via environment variables:

```bash
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
export AWS_DEFAULT_REGION="your-region"
```

### 3. Modify the Variables

Before applying the configuration, you may want to customize certain variables. These are located in the `terraform.tfvars` file, or you can pass them directly through the command line.

Sample variables:

```hcl
aws_region        = "us-west-2"
key_name          = "your-ssh-key-name"
db_username       = "your-db-username"
db_password       = "your-db-password"
instance_type     = "t2.micro"
private_subnet_id = "your-private-subnet-id"
public_subnet_id  = "your-public-subnet-id"
vpc_id            = "your-vpc-id"
```

### 4. Initialize Terraform

Run the following command to initialize Terraform and download the necessary provider plugins:

```bash
terraform init
```

### 5. Plan the Deployment

To ensure your configuration is correct and to preview the changes Terraform will make, run:

```bash
terraform plan
```

### 6. Apply the Configuration

Once you're ready to deploy, run:

```bash
terraform apply
```

Confirm the action when prompted by typing `yes`.

Terraform will now provision the infrastructure resources as defined in the configuration files.

### 7. Access the Application

After the Terraform apply completes, you'll be able to access your application via the API Gateway. The output of the Terraform deployment will provide the API URL.

### 8. Clean Up

To destroy all resources created by this Terraform configuration, you can run:

```bash
terraform destroy
```

### 9. Outputs

Upon successful deployment, Terraform will output the following information:

- `bastion_public_ip`: The public IP address of the Bastion Host.
- `api_gateway_url`: The URL endpoint for accessing the app through API Gateway.

### 10. Example Usage

This configuration is set up to allow a basic application server (EC2) to be accessible through API Gateway. When deployed, you can send HTTP requests to the API Gateway endpoint to interact with your application hosted on the private EC2 instance.

## Architecture Overview

- **VPC**: A Virtual Private Cloud with public and private subnets.
- **Public Subnet**: Hosts the Bastion Host for secure SSH access.
- **Private Subnet**: Hosts the application server (EC2 instance) and RDS MySQL database, both of which are not directly exposed to the internet.
- **API Gateway**: Routes HTTP requests to the private EC2 instance via an HTTP integration (VPC link or direct access).
- **Security Groups**: Strict rules allow only specific traffic (e.g., API Gateway to the app EC2, Bastion Host SSH from trusted sources).
- **RDS**: A MySQL database within the private subnet to securely store application data.

## Security Considerations

- The EC2 application server is not directly accessible from the internet and can only be accessed through the API Gateway.
- Bastion Host is placed in the public subnet and can be accessed via SSH (port 22) for administrative purposes.
- Ensure that you follow best practices when managing secrets, such as using AWS Secrets Manager for database credentials and other sensitive data.

## Troubleshooting

### 1. **Security Group Not Found Error**  
If you receive an error about security groups not being found, ensure that the security groups are created in the same VPC and that their IDs are correctly referenced in the Terraform configuration.

### 2. **API Gateway Configuration Error**  
If you encounter issues with API Gateway integration (e.g., VPC link or URI), check that the correct EC2 instance private IP is being used, and ensure that your VPC setup is valid.

