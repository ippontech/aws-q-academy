# aws-q-academy

## Live coding 1

Prompt simple :

```
Create a VPC with 3 private and 3 public subnets with Terraform.
```

## Live coding 2

Prompt enrichi avec quelques bonnes pratiques :

```
Create a VPC with 3 private and 3 public subnets with Terraform. Generate outputs for main resources. Add project, env and region variables. Document as much as possible.
```

## Live coding 3

```shell
git checkout -b live-coding-3
```

Prompt enrichi via les Q rules :

```
Create a VPC with 3 private and 3 public subnets with Terraform.
```

## Live coding 4

```shell
git checkout -b live-coding-4
```

Prompt enrichi via les Q rules et le serveur MCP Terraform :

```
Create a VPC with 3 private and 3 public subnets with Terraform.
```

## Live coding 5

```shell
git checkout -b live-coding-5
```

Prompt enrichi via les Q rules, le serveur MCP Terraform et code généré à partir d'un schéma Excalidraw ajouté dans le contexte du prompt suivant :

```
Create the Terraform code from the schema. 
```

## Live coding 6

```shell
git checkout -b live-coding-6
```

Les prompts sont enrichis via des Q rules "prod-ready" et de multiples serveurs MCP pour déployer jusqu'en production.

Prompt pour configurer un OIDC provider :

```
Could you configure an IAM provider with OIDC in my AWS account with profile ippon-data-lab so that I can use it from GitHub please? You can store the Terraform state in aws-q-academy-terraform-states S3 bucket and use the same profile to store the state on S3.
```

Prompt pour déployer un VPC :

```
Create a VPC with 3 private and 3 public subnets with Terraform in folder vpc-demo and deploy it thanks to GitHub Actions.
```
