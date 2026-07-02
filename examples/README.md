# Amazon Managed Prometheus Examples

This directory contains Terraform examples for creating and managing Amazon Managed Service for Prometheus workspaces.

The examples show a generic module usage pattern for provisioning an AMP workspace with labels, tags, rule group namespaces, and optional workspace features such as logging, retention, alert manager configuration, and resource policies.

## Key Concepts

* **Workspace**: Amazon Managed Service for Prometheus workspace used to ingest and query metrics.
* **Rule group namespace**: Prometheus recording or alerting rules applied to the workspace.
* **Alert manager definition**: Optional Alertmanager configuration for routing alerts.
* **Resource policy**: Optional workspace policy for controlling access to the AMP workspace.
* **Logging configuration**: Optional CloudWatch Logs integration for workspace logs.

## Generic Usage

```hcl
provider "aws" {
  region = var.region
}

module "prometheus" {
  source = "../.."

  workspace_alias = "example-workspace"
  name            = "example-amp"
  environment     = "dev"

  logging_configuration = {
    create_log_group = true
  }

  retention_period_in_days = 60
  create_alert_manager     = true
  create_resource_policy   = true

  tags = {
    Environment = "dev"
    Terraform   = "true"
    Project     = "example"
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

## Available Example Directories

| Directory | Purpose |
|-----------|---------|
| [`basic`](./basic) | Minimal module configuration |
| [`complete`](./complete) | Configuration with additional optional settings |

## Usage

Choose an example directory and run Terraform from inside it:

```bash
cd examples/basic
terraform init
terraform plan
terraform apply
```

To use a different example, change into that directory before running the same commands.

## What Happens After Apply

Terraform will:

1. Create an Amazon Managed Service for Prometheus workspace.
2. Apply common labels and tags.
3. Configure Prometheus rule group namespaces when provided.
4. Configure optional workspace settings such as logging, retention, alert manager, and resource policy when enabled.
5. Return useful workspace outputs such as the workspace ID and ARN.

## Cleanup

Run the following command from the example directory when the resources are no longer needed:

```bash
terraform destroy
```
