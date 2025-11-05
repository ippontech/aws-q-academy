# GitHub OIDC Provider for AWS

This Terraform configuration creates an IAM OIDC provider for GitHub Actions and an IAM role that can be assumed by your GitHub workflows.

## Prerequisites

- AWS CLI configured with profile `ippon-data-lab`
- Terraform 1.10.5

## Usage

1. Copy the example variables file:
```bash
cp terraform.tfvars.example terraform.tfvars
```

2. Edit `terraform.tfvars` with your GitHub organization and repository:
```hcl
github_org  = "your-org"
github_repo = "aws-q-academy"
```

3. Initialize Terraform:
```bash
terraform init
```

4. Apply the configuration:
```bash
terraform apply
```

## GitHub Actions Workflow

Use the role in your GitHub Actions workflow:

```yaml
permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::721665305066:role/github-actions-role
          aws-region: eu-west-3

      - name: Run AWS commands
        run: aws sts get-caller-identity
```

## Resources Created

- IAM OIDC Provider for GitHub Actions
- IAM Role with AdministratorAccess (adjust permissions as needed)
