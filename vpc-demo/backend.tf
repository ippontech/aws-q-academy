terraform {
  backend "s3" {
    bucket       = "aws-q-academy-terraform-states"
    key          = "vpc-demo/terraform.tfstate"
    region       = "eu-west-3"
    use_lockfile = true
  }
}
