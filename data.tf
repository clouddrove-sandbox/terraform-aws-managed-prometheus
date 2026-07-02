data "aws_caller_identity" "current" {
  count = local.create_resource_policy ? 1 : 0
}

data "aws_partition" "current" {
  count = local.create_resource_policy ? 1 : 0
}

data "aws_region" "current" {
  count = local.create_resource_policy ? 1 : 0

  region = var.region
}

##-----------------------------------------------------------------------------
## Creates a resource policy controlling access to the workspace.
##-----------------------------------------------------------------------------
data "aws_service_principal" "grafana" {
  count = local.create_resource_policy ? 1 : 0

  region       = var.region
  service_name = "grafana"
}

data "aws_iam_policy_document" "resource_policy" {
  count = local.create_resource_policy ? 1 : 0

  dynamic "statement" {
    # Default permissions if custom permissions are not provided
    for_each = var.resource_policy_statements == null ? [1] : []

    content {
      sid = "DefaultAccountReadWrite"
      principals {
        type        = "AWS"
        identifiers = [data.aws_caller_identity.current[0].account_id]
      }
      actions = [
        "aps:RemoteWrite",
        "aps:QueryMetrics",
        "aps:GetSeries",
        "aps:GetLabels",
        "aps:GetMetricMetadata",
      ]
      resources = [local.workspace_arn]
    }
  }

  dynamic "statement" {
    # Default permissions if custom permissions are not provided
    for_each = var.resource_policy_statements == null ? [1] : []

    content {
      sid = "DefaultGrafanaRead"
      principals {
        type        = "Service"
        identifiers = [data.aws_service_principal.grafana[0].name]
      }
      actions = [
        "aps:QueryMetrics",
        "aps:GetSeries",
        "aps:GetLabels",
        "aps:GetMetricMetadata",
      ]
      resources = [local.workspace_arn]
    }
  }

  dynamic "statement" {
    for_each = var.resource_policy_statements != null ? var.resource_policy_statements : {}

    content {
      sid           = try(coalesce(statement.value.sid, statement.key))
      actions       = statement.value.actions
      not_actions   = statement.value.not_actions
      effect        = statement.value.effect
      resources     = coalescelist(statement.value.resources, [local.workspace_arn])
      not_resources = statement.value.not_resources

      dynamic "principals" {
        for_each = statement.value.principals != null ? statement.value.principals : []

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = statement.value.not_principals != null ? statement.value.not_principals : []

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = statement.value.condition != null ? statement.value.condition : []

        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }
}