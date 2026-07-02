output "workspace_id" {
  description = "Created AMP workspace ID"
  value       = module.prometheus.workspace_id
}

output "workspace_arn" {
  description = "Created AMP workspace ARN"
  value       = module.prometheus.workspace_arn
}

output "workspace_endpoint" {
  description = "Prometheus endpoint for the created workspace"
  value       = module.prometheus.workspace_prometheus_endpoint
}