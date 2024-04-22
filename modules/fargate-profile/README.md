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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment (e.g., 'development', 'production'). | `string` | `""` | no |
| <a name="input_fargate_profile_name"></a> [fargate\_profile\_name](#input\_fargate\_profile\_name) | The name of the Fargate profile. | `string` | `""` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of the EKS cluster where fargate will be deployed. | `string` | `""` | no |
| <a name="input_iam_role_path"></a> [iam\_role\_path](#input\_iam\_role\_path) | The path where IAM roles will be created. | `string` | `"/"` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | The ARN of the permissions boundary to attach to IAM roles. | `string` | `null` | no |
| <a name="input_fargate_subnet_ids"></a> [fargate\_subnet\_ids](#input\_fargate\_subnet\_ids) | A list of subnet IDs for the EKS Fargate profile. | `list(string)` | `[]` | no |
| <a name="input_fargate_namespace"></a> [fargate\_namespace](#input\_fargate\_namespace) | The Kubernetes namespace for the Fargate profile | `string` | `""` | no |
| <a name="input_k8s_labels"></a> [k8s\_labels](#input\_k8s\_labels) | A map of Kubernetes labels to apply to the Fargate profile. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fargate_profile_ids"></a> [fargate\_profile\_ids](#output\_fargate\_profile\_ids) | EKS Cluster name and EKS Fargate Profile names separated by a colon (:). |
| <a name="output_fargate_profile_arns"></a> [fargate\_profile\_arns](#output\_fargate\_profile\_arns) | Amazon Resource Name (ARN) of the EKS Fargate Profile. |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | IAM role name for EKS Fargate pods |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | IAM role ARN for EKS Fargate pods |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
