output "workspace_id" {
  description = "Created AMP workspace ID"
  value       = module.prometheus.workspace_id
}

output "workspace_arn" {
  description = "Created AMP workspace ARN"
  value       = module.prometheus.workspace_arn
}
