provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = {
      Environment   = var.environment
      Owner         = "ippontech"
      Project       = "aws-q-academy"
      CostCenter    = "aws-q-academy"
      ManagedBy     = "terraform"
      RootModuleURL = "https://github.com/ippontech/aws-q-academy/terraform/github-oidc"
    }
  }
}
