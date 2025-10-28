# Terraform AWS Best Practices

When generating or modifying Terraform code for AWS, follow these best practices:

## Structure and Organization

- Use a modular structure with reusable modules
- Prefer to use existing OSS Terraform modules on the internet
    - As a priority, use official Terraform registry: https://registry.terraform.io/namespaces/terraform-aws-modules
    - Else, use CloudPosse registry: https://registry.terraform.io/namespaces/cloudposse
- Separate environments (dev, staging, prod) with separate workspaces or directories
- Use variables for all configurable parameters
- Prefer relative paths for local modules
- In Terraform root modules, put the Terraform providers' configuration in a file called providers.tf
- Terraform version constraints' and providers' constraints must stay in file called versions.tf
- Try to regroup resources by the Cloud Provider's services to avoid having all the code in one main.tf file

## Security

- Never use hard-coded credentials in code
- Use IAM roles with the principle of least privilege
- Enable default encryption for all services that support it (S3, RDS, etc.)
- Use restrictive security groups for network resources
- Prefer private VPCs with VPC endpoints over public access

## State Management

- Use a remote backend to store Terraform state
- Enable versioning on the S3 state bucket
- Use state locking with S3 file lock (not DynamoDB)
- Do not include sensitive data in outputs

## Naming and Tagging

- Use a consistent naming scheme for all resources
- Do not add resource type as a suffix or prefix to resource names (for instance, use "my-app" instead of "my-app-vpc")
- Systematically apply tags for:
    - Environment (dev, staging, prod)
    - Owner
    - Project
    - Cost Center
    - Managed By: “terraform”
    - Root Module URL: <URL of the current Git repository from which the terraform apply that manages this resource will be launched>

## Performance and Costs

- Use on-demand instances for development and reserved instances for production
- Configure lifecycle policies for S3 buckets
- Use Auto Scaling Groups to scale resources on demand
- Configure CloudWatch alarms to monitor costs

## Code Best Practices

- Always use fixed versions for providers and modules to avoid regressions between two `terraform plan` commands (do not use Terraform version constraint ~>)
- Document code as much as possible with README.md, variable descriptions, output descriptions, and comments (do not over-comment either when datasource/resource are self explaining)
- Use validations for input variables
- Prefer conditional resources over count for optional resources
- Use for_each over count for multiple resources

## Networking

- Use private subnets for resources that do not require direct Internet access
- Configure NAT Gateways only in environments that require them
- Use Transit Gateways for multi-account/multi-VPC architectures

## Deployment

- Always use terraform plan before applying changes
- Integrate Terraform into CI/CD pipelines for production environments
- Use blue/green approaches for critical updates

## Non-regression

- To avoid regressions, it is best to fix dependency versions.
- For Terraform OSS modules, use a fixed version (preferably the latest available on the Terraform registry) in the module version field

## Testing

- Each validator for Terraform input variables must be tested, but only failed cases.
- For each module generated, an example must be provided.
- For each example, there must be a test that runs it.

## Use of MCP

- Check each generated code to ensure that everything is correct (syntax, Terraform arguments) using the MCP server `terraform-mcp-server`. Before generating any code, ensure that interaction with this MCP server is working properly.
