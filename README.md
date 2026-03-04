# aws-q-academy

## Live coding 1

Prompt simple :

```
Create a VPC with 3 private and 3 public subnets with Terraform. In the private subnets, deploy an ECS Fargate cluster
with a simple nginx ECS service. In the public subnets, deploy an ALB targeting the ECS Fargate cluster.
```

## Live coding 2

```shell
git checkout -b live-coding-2
```

Prompt enrichi via les Q rules :

```
Create a VPC with 3 private and 3 public subnets with Terraform. In the private subnets, deploy an ECS Fargate cluster
with a simple nginx ECS service. In the public subnets, deploy an ALB with TLS enforced targeting the ECS Fargate cluster.
```

## Live coding 3

```shell
git checkout -b live-coding-3
```

Prompt enrichi via les Q rules et le serveur MCP Terraform :

```
Create a VPC with 3 private and 3 public subnets with Terraform. In the private subnets, deploy an ECS Fargate cluster
with a simple nginx ECS service. In the public subnets, deploy an ALB with TLS enforced targeting the ECS Fargate cluster.
```

## Live coding 4

```shell
git checkout -b live-coding-4
```

Prompt enrichi via les Q rules, le serveur MCP Terraform et code généré à partir d'un schéma Excalidraw ajouté dans le contexte du prompt suivant :

```
Create the Terraform code from the schema.
```

## Live coding 5

```shell
git checkout -b live-coding-5
```

Les prompts sont enrichis via des Q rules "prod-ready" et de multiples serveurs MCP pour déployer jusqu'en production.

Prompt :

```
# GitHub OIDC configuration

Could you configure an IAM provider with OIDC in my AWS account?

When creating the IAM role that will be assumed from GitHub workflows, do not forget to add an IAM policy to be able to apply/destroy from GHA.

Apply the Terraform code first from local environment. Use profile ippon-data-lab to do so.

# AWS ECS Nginx infrastructure

Create a VPC with 3 private and 3 public subnets with Terraform. In the private subnets, deploy an ECS Fargate cluster
with a simple nginx ECS service. In the public subnets, deploy an ALB with a self signed TLS certificate
targeting the ECS Fargate cluster.

Update the IAM role created in GitHub OIDC Terraform code to add an IAM policy to the role to be able to
apply/destroy this infrastructure from GHA.

# Deployment with GHA workflows

Deploy this infrastructure thanks to GitHub Actions:

- 1 workflow to execute pre-commit to check the quality of the code
- 1 workflow to plan/apply Terraform code of GitHub OIDC root module
- 1 workflow to plan/apply Terraform code of AWS ECS Nginx infrastructure root module

Both Terraform workflows should:

- use the IAM role ARN generated in GitHub OIDCS root module to configure AWS credentials
- Terraform plans should be used for PR workflows and Terraform apply should only be done on main branch
- add a comment in the MR to show the Terraform plans for the reviewers. If a comment already
exists, update it to avoid to much noise in the PR.
```
