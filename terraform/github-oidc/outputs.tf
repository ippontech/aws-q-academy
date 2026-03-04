output "iam_role_arn" {
  description = "ARN of the IAM role assumed by GitHub Actions"
  value       = module.oidc_github.iam_role_arn
}

output "oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  value       = module.oidc_github.oidc_provider_arn
}
