# Senior Platform Engineer – Technical Assessment

## Overview
This repository contains a complete implementation of the assessment requirements:
- AWS infrastructure using Terraform
- Windows Server 2022 EC2 instance
- SQL Server 2019 RDS instance
- Secure secrets via SSM Parameter Store
- Zero‑touch bootstrap script
- Reusable CI/CD pipeline using GitHub Actions
- Observability and modernisation notes

## How to Deploy
### 1. Infrastructure
cd infra
terraform init
terraform apply -var="aws_region=ap-southeast-2" \
-var="db_username=admin" \
-var="db_password=YourPassword123!" \
-var="db_connection_param_name=/myapp/db/connectionstring"


### 2. Application
cd app
dotnet run --project ./src/HelloWorldApi/HelloWorldApi.csproj


### 3. CI/CD
Push to `main` to trigger deployment.

## Observability
- CloudWatch metrics for EC2/RDS
- CloudWatch Logs for IIS + app logs
- Optional: X-Ray or OpenTelemetry

## Modernisation
To migrate to containers:
- Replace EC2 with ECS Fargate or EKS
- Push images to ECR
- Update pipeline to deploy containers
