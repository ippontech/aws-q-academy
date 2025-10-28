# GitHub Actions OIDC provider
# Allows GitHub Actions workflows to authenticate to AWS without long-lived credentials.
# See: https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  # Audience expected in the JWT token issued by GitHub
  client_id_list = ["sts.amazonaws.com"]

  # GitHub's OIDC thumbprint (SHA-1 of the root CA certificate)
  # See: https://github.blog/changelog/2023-06-27-github-actions-update-on-oidc-integration-with-aws/
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]
}

# Permissions needed by the role to manage its own resources (OIDC provider + itself) and the Terraform S3 state
resource "aws_iam_role_policy" "github_actions" {
  name = "github-oidc-terraform"
  role = aws_iam_role.github_actions.id

  policy = data.aws_iam_policy_document.github_actions_permissions.json
}


# trivy:ignore:AVD-AWS-0345 - Permissions are scoped to specific resources
data "aws_iam_policy_document" "github_actions_permissions" {
  statement {
    sid     = "IAMOidcAndRole"
    effect  = "Allow"
    actions = ["iam:*"]
    resources = [
      "arn:aws:iam::${local.account_id}:oidc-provider/token.actions.githubusercontent.com",
      "arn:aws:iam::${local.account_id}:role/aws-q-academy-*",
      "arn:aws:iam::${local.account_id}:role/live-coding-6-*",
      "arn:aws:iam::${local.account_id}:server-certificate/live-coding-6-*",
    ]
  }

  statement {
    sid     = "S3TerraformState"
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::aws-q-academy-terraform-states",
      "arn:aws:s3:::aws-q-academy-terraform-states/github-oidc/*",
      "arn:aws:s3:::aws-q-academy-terraform-states/live-coding-6/*",
    ]
  }

  statement {
    sid       = "VPC"
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }

  statement {
    sid       = "VPCMutate"
    effect    = "Allow"
    actions   = ["ec2:*"]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"
      values   = [data.aws_region.current.name]
    }
  }

  statement {
    sid     = "ELB"
    effect  = "Allow"
    actions = ["elasticloadbalancing:*"]
    resources = [
      "arn:aws:elasticloadbalancing:${local.region}:${local.account_id}:loadbalancer/app/live-coding-6-*",
      "arn:aws:elasticloadbalancing:${local.region}:${local.account_id}:listener/app/live-coding-6-*",
      "arn:aws:elasticloadbalancing:${local.region}:${local.account_id}:listener-rule/app/live-coding-6-*",
      "arn:aws:elasticloadbalancing:${local.region}:${local.account_id}:targetgroup/live-coding-6-*",
    ]
  }

  statement {
    sid     = "ECS"
    effect  = "Allow"
    actions = ["ecs:*"]
    resources = [
      "arn:aws:ecs:${local.region}:${local.account_id}:cluster/live-coding-6-*",
      "arn:aws:ecs:${local.region}:${local.account_id}:service/live-coding-6-*",
      "arn:aws:ecs:${local.region}:${local.account_id}:task-definition/live-coding-6-*",
    ]
  }

  statement {
    sid     = "CloudWatchLogs"
    effect  = "Allow"
    actions = ["logs:*"]
    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/ecs/live-coding-6-*",
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/ecs/live-coding-6-*:*",
    ]
  }
}

# IAM role assumed by GitHub Actions workflows
resource "aws_iam_role" "github_actions" {
  name        = "${var.project}-${var.env}-github-actions"
  description = "Role assumed by GitHub Actions via OIDC for ${var.github_org}/${var.github_repo}"

  assume_role_policy = data.aws_iam_policy_document.github_actions_trust.json
}

# Trust policy: only allow tokens from the specified org/repo combination
data "aws_iam_policy_document" "github_actions_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # Scope to a specific repo (or all repos in the org when github_repo = "*")
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_org}/${var.github_repo}:*"]
    }
  }
}
