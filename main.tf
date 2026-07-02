##-----------------------------------------------------------------------------
## Labels module called that will be used for naming and tags.
##-----------------------------------------------------------------------------
module "labels" {
  source  = "clouddrove/labels/aws"
  version = "1.3.1"

  name        = var.name
  environment = var.environment
  repository  = var.repository
  managedby   = var.managedby
  label_order = var.label_order
  enabled     = var.enabled
  extra_tags  = var.tags
}

locals {
  partition  = try(data.aws_partition.current[0].partition, "aws")
  account_id = try(data.aws_caller_identity.current[0].account_id, "")
  region     = try(data.aws_region.current[0].region, "")

  workspace_id = var.enabled && var.create_workspace ? aws_prometheus_workspace.this[0].id : var.workspace_id

  # Since we are accepting externally created workspaces, we need to re-construct the ARN for the policy
  workspace_arn = var.enabled && var.create_workspace ? aws_prometheus_workspace.this[0].arn : "arn:${local.partition}:aps:${local.region}:${local.account_id}:workspace/${var.workspace_id}"
  create_resource_policy = var.enabled && var.create_workspace && var.create_resource_policy
  log_group_name = coalesce(var.cloudwatch_log_group_name, "/aws/prometheus/${coalesce(var.workspace_alias, module.labels.id, "workspace")}")
}

##-----------------------------------------------------------------------------
## Creates an Amazon Managed Service for Prometheus workspace.
##-----------------------------------------------------------------------------
resource "aws_prometheus_workspace" "this" {
  count = var.enabled && var.create_workspace ? 1 : 0

  region = var.region

  alias       = var.workspace_alias
  kms_key_arn = var.kms_key_arn

  dynamic "logging_configuration" {
    for_each = var.logging_configuration != null ? [var.logging_configuration] : []

    content {
      log_group_arn = logging_configuration.value.create_log_group ? "${aws_cloudwatch_log_group.this[0].arn}:*" : logging_configuration.value.log_group_arn
    }
  }

  tags = module.labels.tags
}

##-----------------------------------------------------------------------------
## Configures retention and per-label-set limits for the workspace.
##-----------------------------------------------------------------------------
resource "aws_prometheus_workspace_configuration" "this" {
  count = var.enabled && var.create_workspace && var.limits_per_label_set != null ? 1 : 0

  region = var.region

  retention_period_in_days = var.retention_period_in_days
  workspace_id             = local.workspace_id

  dynamic "limits_per_label_set" {
    for_each = var.limits_per_label_set != null ? var.limits_per_label_set : []

    content {
      label_set = limits_per_label_set.value.label_set

      dynamic "limits" {
        for_each = [limits_per_label_set.value.limits]

        content {
          max_series = limits.value.max_series
        }
      }
    }
  }
}

resource "aws_prometheus_resource_policy" "this" {
  count = local.create_resource_policy ? 1 : 0

  region = var.region

  workspace_id    = local.workspace_id
  policy_document = data.aws_iam_policy_document.resource_policy[0].json
}

##-----------------------------------------------------------------------------
## Creates a CloudWatch log group for workspace logging.
##-----------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "this" {
  count = var.enabled && var.create_workspace && try(coalesce(var.logging_configuration.create_log_group), true) ? 1 : 0

  region = var.region

  name              = var.cloudwatch_log_group_use_name_prefix ? null : local.log_group_name
  name_prefix       = var.cloudwatch_log_group_use_name_prefix ? "${local.log_group_name}-" : null
  log_group_class   = var.cloudwatch_log_group_class
  retention_in_days = var.cloudwatch_log_group_retention_in_days
  kms_key_id        = var.cloudwatch_log_group_kms_key_id

  tags = module.labels.tags
}

##-----------------------------------------------------------------------------
## Creates the Alert Manager definition for the workspace.
##-----------------------------------------------------------------------------
resource "aws_prometheus_alert_manager_definition" "this" {
  count = var.enabled && var.create_alert_manager ? 1 : 0

  region = var.region

  workspace_id = local.workspace_id
  definition   = var.alert_manager_definition
}

##-----------------------------------------------------------------------------
## Creates one or more rule group namespaces in the workspace.
##-----------------------------------------------------------------------------
resource "aws_prometheus_rule_group_namespace" "this" {
  for_each = var.enabled && var.rule_group_namespaces != null ? var.rule_group_namespaces : {}

  region = var.region

  name         = each.value.name
  workspace_id = local.workspace_id
  data         = each.value.data
}
