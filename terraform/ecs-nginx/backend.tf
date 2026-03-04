terraform {
  backend "s3" {
    bucket  = "aws-q-academy-terraform-states"
    key     = "ecs-nginx/terraform.tfstate"
    region  = "eu-west-3"
    profile = "ippon-data-lab"

    use_lockfile = true
  }
}
