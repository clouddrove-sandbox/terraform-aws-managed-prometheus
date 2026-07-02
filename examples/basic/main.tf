provider "aws" {
  region = var.region
}

module "prometheus" {
  source = "../.."

  workspace_alias = "example-workspace"
  name            = "clouddrove-prometheus"
  environment     = "test"

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
