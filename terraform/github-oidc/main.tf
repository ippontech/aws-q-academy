module "oidc_github" {
  source  = "unfunco/oidc-github/aws"
  version = "1.8.1"

  github_repositories = ["${var.github_org}/${var.github_repo}"]

  iam_role_name           = "github-actions-${var.github_repo}"
  attach_read_only_policy = false
  attach_admin_policy     = false

  iam_role_inline_policies = {
    github-oidc-ecs-nginx = data.aws_iam_policy_document.github_actions.json
  }

  tags = {
    Environment   = var.environment
    Owner         = "ippontech"
    Project       = "aws-q-academy"
    CostCenter    = "aws-q-academy"
    ManagedBy     = "terraform"
    RootModuleURL = "https://github.com/ippontech/aws-q-academy/terraform/github-oidc"
  }
}

data "aws_iam_policy_document" "github_actions" {
  # Permissions to manage GitHub OIDC root module state
  statement {
    sid    = "TerraformStateGithubOidc"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
    ]
    resources = [
      "arn:aws:s3:::aws-q-academy-terraform-states",
      "arn:aws:s3:::aws-q-academy-terraform-states/github-oidc/*",
      "arn:aws:s3:::aws-q-academy-terraform-states/ecs-nginx/*",
    ]
  }

  # Permissions to manage ECS nginx infrastructure
  statement {
    sid    = "ECSNginxInfra"
    effect = "Allow"
    actions = [
      "ec2:*",
      "ecs:*",
      "elasticloadbalancing:*",
      "iam:*",
      "logs:*",
      "acm:*",
    ]
    resources = ["*"]
  }

  # Permissions to read OIDC provider (for plan)
  statement {
    sid    = "IAMOIDCRead"
    effect = "Allow"
    actions = [
      "iam:GetOpenIDConnectProvider",
      "iam:ListOpenIDConnectProviders",
      "iam:GetRole",
      "iam:ListRolePolicies",
      "iam:GetRolePolicy",
      "iam:ListAttachedRolePolicies",
    ]
    resources = ["*"]
  }
}
