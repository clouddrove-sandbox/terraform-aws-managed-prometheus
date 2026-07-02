provider "aws" {
  region = var.region
}

module "prometheus" {
  source = "../.."

  workspace_alias = "complete-example-workspace"
  name            = "complete-amp"
  environment     = "prod"

  logging_configuration = {
    create_log_group = true
  }

  retention_period_in_days = 60
  create_alert_manager     = true
  create_resource_policy   = true

  tags = {
    Environment = "prod"
    Terraform   = "true"
    Project     = "complete-example"
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
