output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.alb.dns_name
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs_cluster.name
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = module.ecs_service.name
}
