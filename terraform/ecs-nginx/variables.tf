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

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "nginx_desired_count" {
  description = "Desired number of nginx ECS tasks"
  type        = number
  default     = 1

  validation {
    condition     = var.nginx_desired_count >= 1
    error_message = "nginx_desired_count must be at least 1."
  }
}
