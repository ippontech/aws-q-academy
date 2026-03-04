data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

# ─── VPC ─────────────────────────────────────────────────────────────────────

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  name = "aws-q-academy"
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = [for i, az in local.azs : cidrsubnet(var.vpc_cidr, 4, i)]
  public_subnets  = [for i, az in local.azs : cidrsubnet(var.vpc_cidr, 4, i + 3)]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}

# ─── Self-signed TLS certificate ─────────────────────────────────────────────

resource "tls_private_key" "self_signed" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "self_signed" {
  private_key_pem = tls_private_key.self_signed.private_key_pem

  subject {
    common_name  = "aws-q-academy.local"
    organization = "Ippon Technologies"
  }

  validity_period_hours = 8760 # 1 year

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "self_signed" {
  private_key      = tls_private_key.self_signed.private_key_pem
  certificate_body = tls_self_signed_cert.self_signed.cert_pem
}

# ─── ALB ─────────────────────────────────────────────────────────────────────

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "10.5.0"

  name    = "aws-q-academy"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  enable_deletion_protection = false

  security_group_ingress_rules = {
    https = {
      from_port   = "443"
      to_port     = "443"
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      description = "HTTPS from internet"
    }
  }

  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  listeners = {
    https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = aws_acm_certificate.self_signed.arn
      ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"

      forward = {
        target_group_key = "nginx"
      }
    }
  }

  target_groups = {
    nginx = {
      name        = "aws-q-academy-nginx"
      protocol    = "HTTP"
      port        = 80
      target_type = "ip"
      vpc_id      = module.vpc.vpc_id

      health_check = {
        enabled             = true
        path                = "/"
        healthy_threshold   = 2
        unhealthy_threshold = 3
        interval            = 30
      }

      create_attachment = false
    }
  }
}

# ─── ECS ─────────────────────────────────────────────────────────────────────

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "7.3.1"

  cluster_name = "aws-q-academy"

  cluster_capacity_providers = ["FARGATE"]

  services = {
    nginx = {
      name          = "nginx"
      desired_count = var.nginx_desired_count
      launch_type   = "FARGATE"

      cpu    = 256
      memory = 512

      subnet_ids         = module.vpc.private_subnets
      security_group_ids = [aws_security_group.ecs_nginx.id]

      create_security_group = false

      create_task_exec_iam_role = true

      container_definitions = {
        nginx = {
          image     = "nginx:1.27-alpine"
          essential = true

          portMappings = [
            {
              containerPort = 80
              protocol      = "tcp"
            }
          ]

          enable_cloudwatch_logging = true
        }
      }

      load_balancer = {
        nginx = {
          target_group_arn = module.alb.target_groups["nginx"].arn
          container_name   = "nginx"
          container_port   = 80
        }
      }
    }
  }
}

# ─── Security group for ECS tasks ────────────────────────────────────────────

resource "aws_security_group" "ecs_nginx" {
  name        = "aws-q-academy-ecs-nginx"
  description = "Allow traffic from ALB to nginx ECS tasks"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "ecs_nginx_from_alb" {
  security_group_id            = aws_security_group.ecs_nginx.id
  referenced_security_group_id = module.alb.security_group_id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  description                  = "Allow HTTP from ALB"
}

# trivy:ignore:AVD-AWS-0104 - ECS tasks need outbound internet access to pull images and reach AWS APIs
resource "aws_vpc_security_group_egress_rule" "ecs_nginx_egress" {
  security_group_id = aws_security_group.ecs_nginx.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound"
}
