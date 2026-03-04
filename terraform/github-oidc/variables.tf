variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-3"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "aws_profile" {
  description = "AWS profile to use for local authentication. Leave empty in CI/CD environments."
  type        = string
  default     = "ippon-data-lab"
}

variable "github_org" {
  description = "GitHub organization name"
  type        = string
  default     = "ippontech"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "aws-q-academy"
}
