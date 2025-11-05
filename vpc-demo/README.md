# VPC Demo

This Terraform module creates an AWS VPC with 3 private and 3 public subnets across 3 availability zones.

## Architecture

- **VPC CIDR**: 10.0.0.0/16
- **Private Subnets**: 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24
- **Public Subnets**: 10.0.101.0/24, 10.0.102.0/24, 10.0.103.0/24
- **NAT Gateway**: Single NAT Gateway for cost optimization
- **Internet Gateway**: Enabled for public subnets

## Usage

### Local Deployment

```bash
terraform init
terraform plan
terraform apply
```

### GitHub Actions Deployment

Push to the repository to trigger automatic deployment via GitHub Actions.

## Variables

| Name | Description | Default |
|------|-------------|---------|
| region | AWS region | eu-west-3 |
| aws_profile | AWS profile to use | "" |
| project | Project name | vpc-demo |
| environment | Environment name | dev |
| vpc_cidr | CIDR block for VPC | 10.0.0.0/16 |
| availability_zones | List of availability zones | ["eu-west-3a", "eu-west-3b", "eu-west-3c"] |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
| private_subnets | List of IDs of private subnets |
| public_subnets | List of IDs of public subnets |
| nat_gateway_ids | List of NAT Gateway IDs |
| internet_gateway_id | The ID of the Internet Gateway |
