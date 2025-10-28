variable "project" {
  description = "Project name"
  type        = string
  default     = "aws-q-academy"
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}

variable "owner" {
  description = "Team or person owning this resource"
  type        = string
  default     = "ippon"
}

variable "cost_center" {
  description = "Cost center for billing"
  type        = string
  default     = "ippon"
}

variable "root_module_url" {
  description = "URL of the Git repository from which terraform apply is launched"
  type        = string
  default     = "https://github.com/ippon/aws-q-academy"
}

variable "github_org" {
  description = "GitHub organisation or user name (e.g. my-org)"
  type        = string

  validation {
    condition     = length(var.github_org) > 0
    error_message = "github_org must not be empty."
  }
}

variable "aws_profile" {
  description = "AWS profile to use for authentication. Leave empty when running in CI (GitHub Actions)."
  type        = string
  default     = ""
}

variable "github_repo" {
  description = "GitHub repository name (e.g. my-repo). Use '*' to allow all repos in the org."
  type        = string
  default     = "*"
}
