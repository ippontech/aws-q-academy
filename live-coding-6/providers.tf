provider "aws" {
  region  = var.region
  profile = var.aws_profile != "" ? var.aws_profile : null

  default_tags {
    tags = {
      Project       = var.project
      Environment   = var.env
      Owner         = var.owner
      CostCenter    = var.cost_center
      ManagedBy     = "terraform"
      RootModuleURL = var.root_module_url
    }
  }
}
