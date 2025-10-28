module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "7.3.1"

  name = "${local.name}-cluster"
}

module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "7.3.1"

  name        = "${local.name}-nginx"
  cluster_arn = module.ecs_cluster.arn

  cpu    = 256
  memory = 512

  container_definitions = {
    nginx = {
      image     = "nginx:latest"
      essential = true
      port_mappings = [{
        containerPort = 80
        protocol      = "tcp"
      }]
      enable_cloudwatch_logging              = true
      cloudwatch_log_group_retention_in_days = 7
    }
  }

  # Network
  subnet_ids = module.vpc.private_subnets
  security_group_ingress_rules = {
    alb_http = {
      from_port                    = 80
      to_port                      = 80
      ip_protocol                  = "tcp"
      description                  = "HTTP from ALB"
      referenced_security_group_id = module.alb.security_group_id
    }
  }

  # ALB target group attachment
  load_balancer = {
    nginx = {
      target_group_arn = module.alb.target_groups["nginx"].arn
      container_name   = "nginx"
      container_port   = 80
    }
  }

  desired_count             = 2
  create_task_exec_iam_role = true
}
