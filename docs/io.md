## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alert\_manager\_definition | The alert manager definition that you want to be applied. See more in the [AWS Docs](https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-alert-manager.html) | `string` | <pre>alertmanager_config: \|<br>  route:<br>    receiver: 'default'<br>  receivers:<br>    - name: 'default'</pre> | no |
| cloudwatch\_log\_group\_class | Specified the log class of the log group. Possible values are: `STANDARD` or `INFREQUENT_ACCESS` | `string` | `null` | no |
| cloudwatch\_log\_group\_kms\_key\_id | If a KMS Key ARN is set, this key will be used to encrypt the corresponding log group. Please be sure that the KMS Key has an appropriate key policy (https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html) | `string` | `null` | no |
| cloudwatch\_log\_group\_name | Custom name of CloudWatch log group for a service associated with the container definition | `string` | `null` | no |
| cloudwatch\_log\_group\_retention\_in\_days | Number of days to retain log events. Set to `0` to keep logs indefinitely | `number` | `30` | no |
| cloudwatch\_log\_group\_use\_name\_prefix | Determines whether the log group name should be used as a prefix | `bool` | `false` | no |
| create\_alert\_manager | Controls whether an Alert Manager definition is created along with the AMP workspace | `bool` | `true` | no |
| create\_resource\_policy | Controls whether a resource policy is created along with the AMP workspace | `bool` | `true` | no |
| create\_workspace | Determines whether a workspace will be created or to use an existing workspace | `bool` | `true` | no |
| enabled | Flag to control whether resources are created. | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| kms\_key\_arn | The ARN of the KMS Key to for encryption at rest | `string` | `null` | no |
| label\_order | Label order, e.g. `name`,`application`. | `list(any)` | `[]` | no |
| limits\_per\_label\_set | Configuration block for setting limits on metrics with specific label sets | <pre>list(object({<br>  label_set = map(string)<br>  limits = object({<br>    max_series = number<br>  })<br>}))</pre> | `null` | no |
| logging\_configuration | The logging configuration of the prometheus workspace. | <pre>object({<br>  create_log_group = optional(bool, true)<br>  log_group_arn    = optional(string)<br>})</pre> | `null` | no |
| managedby | ManagedBy, eg 'CloudDrove'. | `string` | `"hello@clouddrove.com"` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| region | Region where the resource(s) will be managed. Defaults to the Region set in the provider configuration | `string` | `null` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-managed-prometheus"` | no |
| resource\_policy\_statements | A map of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for custom permission usage | <pre>map(object({<br>  sid           = optional(string)<br>  actions       = optional(list(string))<br>  not_actions   = optional(list(string))<br>  effect        = optional(string, "Allow")<br>  resources     = optional(list(string))<br>  not_resources = optional(list(string))<br>  principals = optional(list(object({<br>    type        = string<br>    identifiers = list(string)<br>  })))<br>  not_principals = optional(list(object({<br>    type        = string<br>    identifiers = list(string)<br>  })))<br>  condition = optional(list(object({<br>    test     = string<br>    variable = string<br>    values   = list(string)<br>  })))<br>}))</pre> | `null` | no |
| retention\_period\_in\_days | Number of days to retain metric data in the workspace | `number` | `null` | no |
| rule\_group\_namespaces | A map of one or more rule group namespace definitions | <pre>map(object({<br>  name = string<br>  data = string<br>}))</pre> | `null` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |
| workspace\_alias | The alias of the prometheus workspace. See more in the [AWS Docs](https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-onboard-create-workspace.html) | `string` | `null` | no |
| workspace\_id | The ID of an existing workspace to use when `create_workspace` is `false` | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| tags | A mapping of tags to assign to the resource. |
| workspace\_arn | Amazon Resource Name (ARN) of the workspace |
| workspace\_id | Identifier of the workspace |
| workspace\_prometheus\_endpoint | Prometheus endpoint available for this workspace |
