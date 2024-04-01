# fargate-profile

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_fargate_profile.eks_fargate_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_fargate_profile) | resource |
| [aws_iam_role.eks_fargate_pod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.eks_fargate_pod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.eks_fargate_pod_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name | `string` | n/a | yes |
| <a name="input_fargate_profile_name"></a> [fargate\_profile\_name](#input\_fargate\_profile\_name) | The profile name | `string` | n/a | yes |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of the EKS cluster. | `string` | `""` | no |
| <a name="input_iam_path"></a> [iam\_path](#input\_iam\_path) | IAM roles will be created on this path. | `string` | `"/"` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | If provided, all IAM roles will be created with this permissions boundary attached. | `string` | `null` | no |
| <a name="input_fargate_subnet_ids"></a> [fargate\_subnet\_ids](#input\_fargate\_subnet\_ids) | A list of subnets for the EKS Fargate profile. | `list(string)` | `[]` | no |
| <a name="input_fargate_namespace"></a> [fargate\_namespace](#input\_fargate\_namespace) | The Kubernetes namespace for the Fargate profile | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | The Kubernetes labels for the Fargate profile | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fargate_profile_ids"></a> [fargate\_profile\_ids](#output\_fargate\_profile\_ids) | EKS Cluster name and EKS Fargate Profile names separated by a colon (:). |
| <a name="output_fargate_profile_arns"></a> [fargate\_profile\_arns](#output\_fargate\_profile\_arns) | Amazon Resource Name (ARN) of the EKS Fargate Profile. |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | IAM role name for EKS Fargate pods |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | IAM role ARN for EKS Fargate pods |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
