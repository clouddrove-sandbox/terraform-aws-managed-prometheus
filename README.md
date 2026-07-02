# Terraform AWS Managed Prometheus

This module creates an Amazon Managed Service for Prometheus workspace and optional rule group namespaces in a simple, ready-to-use form.

## Usage

```hcl
module "prometheus" {
  source = "./terraform-aws-managed-prometheus"

  name            = "example-amp"
  environment     = "dev"
  workspace_alias = "example-workspace"

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }

  rule_group_namespaces = {
    example = {
      name = "example-rulegroup"
      data = <<-EOT
groups:
  - name: example
    rules:
      - record: job:http_inprogress_requests:sum
        expr: sum by (job) (http_inprogress_requests)
      EOT
    }
  }
}
```

## Examples

- [Basic example](examples/basic)
- [Complete example](examples/complete)

## Inputs

- `enabled`: Flag to control whether resources are created.
- `name` / `environment` / `label_order` / `managedby` / `repository`: Inputs for the `clouddrove/labels/aws` module used for naming and tags.
- `workspace_id`: Existing workspace ID when not creating a new one.
- `workspace_alias`: Workspace alias.
- `tags`: Tags to apply (merged into the labels module tags).
- `logging_configuration`: Optional logging configuration.
- `rule_group_namespaces`: Map of rule group namespaces.
- `region`: Optional AWS region hint for local usage.

## Outputs

- `workspace_id`
- `workspace_arn`
- `workspace_prometheus_endpoint`
- `tags`

## Notes

These examples assume you have AWS credentials configured and the appropriate permissions to create Amazon Managed Service for Prometheus resources.
