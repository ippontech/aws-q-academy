variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}

variable "project" {
  description = "Project name used in resource names and tags"
  type        = string
  default     = "live-coding-6"
}

variable "env" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.env)
    error_message = "env must be one of: dev, staging, prod."
  }
}

variable "owner" {
  description = "Team or person responsible for this infrastructure"
  type        = string
  default     = "ippon"
}

variable "cost_center" {
  description = "Cost center for billing attribution"
  type        = string
  default     = "ippon-data-lab"
}

variable "root_module_url" {
  description = "URL of the Git repository from which terraform apply is launched"
  type        = string
  default     = "https://github.com/ippontech/aws-q-academy"
}

variable "aws_profile" {
  description = "AWS profile to use for authentication. Leave empty when running in CI (GitHub Actions)."
  type        = string
  default     = ""
}
