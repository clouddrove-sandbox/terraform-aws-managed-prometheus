#Module      : AMAZON MANAGED PROMETHEUS
#Description : Terraform module to create an Amazon Managed Service for Prometheus workspace.
output "workspace_arn" {
  description = "Amazon Resource Name (ARN) of the workspace"
  value       = try(aws_prometheus_workspace.this[0].arn, null)
}

output "workspace_id" {
  description = "Identifier of the workspace"
  value       = try(aws_prometheus_workspace.this[0].id, null)
}

output "workspace_prometheus_endpoint" {
  description = "Prometheus endpoint available for this workspace"
  value       = try(aws_prometheus_workspace.this[0].prometheus_endpoint, null)
}

output "tags" {
  description = "A mapping of tags to assign to the resource."
  value       = module.labels.tags
}
