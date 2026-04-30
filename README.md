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


## Modernisation
To migrate to containers:
- Replace EC2 with ECS Fargate or EKS
- Push images to ECR
- Update pipeline to deploy containers

============================================================

## Final Section
## Potential improvements -- Suggested by developer (Adrian)

1- Make the codebase more template-driven to promote reuse and consistency across environments. Replace repetitive configurations with parameterized templates so changes can be applied centrally and safely.

2- Move hard-coded values into configurable variables. This improves flexibility, makes the code environment-agnostic, and reduces the risk of errors when deploying across dev, test, and production.

3- Clearly separate variables from secrets, and manage them through CI/CD tooling (e.g., pipeline variables and secret stores). This ensures sensitive data is not exposed in source code and is handled securely.

4- Segregate static (non-changing) variables from dynamic or environment-specific ones. Static variables can live in configuration files, while dynamic values should be injected at runtime. 

5- Store sensitive variables (e.g., passwords, API keys) securely as runtime secrets within the CI/CD pipeline. These should never be hard-coded or stored in plain text.

6- Define non-sensitive variables (e.g., environment names, regions) as parameters in the .yml pipeline configuration to allow easy customization per deployment.

7- Ensure all secrets are stored in secure secret management systems provided by the CI/CD platform (e.g., secret vaults), with strict access controls and auditing enabled.

8- Apply end-to-end security practices across the platform, including secure coding, least-privilege access, encrypted data handling, and secure pipeline execution.

9- Modernize the deployment workflow so that a single action (e.g., one-click deployment) triggers the full process: Terraform infrastructure provisioning, .NET application deployment, and environment bootstrapping.

10- Refactor the Terraform code into modular, reusable components. This improves maintainability, readability, and scalability, making it easier to manage infrastructure changes over time.

11- In an interview context, emphasize how these practices improve scalability, security, maintainability, and deployment efficiency, and provide examples of how they reduce operational risk and support continuous delivery.

