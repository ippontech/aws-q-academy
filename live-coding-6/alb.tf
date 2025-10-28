locals {
  name = "${var.project}-${var.env}"
}

#trivy:ignore:AVD-AWS-0053
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "10.5.0"

  name    = "${local.name}-alb"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  # Security group managed by the module
  security_group_ingress_rules = {
    https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      description = "HTTPS from internet"
    }
    http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      description = "HTTP from internet (redirected to HTTPS)"
    }
  }

  # Listeners
  listeners = {
    https = {
      port            = 443
      protocol        = "HTTPS"
      ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"
      certificate_arn = aws_iam_server_certificate.self_signed.arn
      forward = {
        target_group_key = "nginx"
      }
    }
    http = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }

  target_groups = {
    nginx = {
      name        = "${local.name}-nginx"
      protocol    = "HTTP"
      port        = 80
      target_type = "ip"
      health_check = {
        path                = "/"
        healthy_threshold   = 2
        unhealthy_threshold = 3
      }
      create_attachment = false
    }
  }

  enable_deletion_protection = false
}
