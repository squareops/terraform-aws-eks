<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_node_group.managed_ng](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_policy.node_autoscaler_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.SSMManagedInstanceCore_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_kms_worker_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_worker_ecr_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_worker_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_autoscaler_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.eks_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_ami.launch_template_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_eks_cluster.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_iam_policy.SSMManagedInstanceCore](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_role.worker_iam_role_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [template_file.launch_template_userdata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Set true if you want to enable network interface for launch template | `bool` | `false` | no |
| <a name="input_capacity_type"></a> [capacity\_type](#input\_capacity\_type) | Capacity type ON\_DEMAND/SPOT | `string` | `"ON_DEMAND"` | no |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | Specify the desired no. for Nodegroups | `string` | `"3"` | no |
| <a name="input_ebs_encrypted"></a> [ebs\_encrypted](#input\_ebs\_encrypted) | Specify whether to encrypt EBS volume for nodes or not | `bool` | `true` | no |
| <a name="input_ebs_volume_size"></a> [ebs\_volume\_size](#input\_ebs\_volume\_size) | Specify the Size of the EBS volume for nodes. | `string` | `"50"` | no |
| <a name="input_ebs_volume_type"></a> [ebs\_volume\_type](#input\_ebs\_volume\_type) | Specify the type of EBS volume for nodes. | `string` | `"gp3"` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of EKS cluster | `string` | `""` | no |
| <a name="input_eks_nodes_keypair_name"></a> [eks\_nodes\_keypair\_name](#input\_eks\_nodes\_keypair\_name) | The public key for EKS cluster worker nodes | `string` | `""` | no |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | Specify to enable monitoring for nodes. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Enviornment for nodes/nodegroups. | `string` | `null` | no |
| <a name="input_eventRecordQPS"></a> [eventRecordQPS](#input\_eventRecordQPS) | Specify the maximum no. of events creation per second. | `number` | `5` | no |
| <a name="input_image_high_threshold_percent"></a> [image\_high\_threshold\_percent](#input\_image\_high\_threshold\_percent) | Defines the percent of disk usage on garbage collection should trigger. | `number` | `60` | no |
| <a name="input_image_low_threshold_percent"></a> [image\_low\_threshold\_percent](#input\_image\_low\_threshold\_percent) | Define the percentage of disk usage till the garbage collection took place. | `number` | `40` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Specify the instance type eg. t2.medium etc. | `list(any)` | <pre>[<br>  "t3a.medium"<br>]</pre> | no |
| <a name="input_k8s_labels"></a> [k8s\_labels](#input\_k8s\_labels) | K8s label for the nodegroups | `map(any)` | `{}` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | KMS key ID for Encrypting Node groups. | `string` | `""` | no |
| <a name="input_kms_policy_arn"></a> [kms\_policy\_arn](#input\_kms\_policy\_arn) | KMS policy ARN which is used for encrypting Kubernetes PVC | `string` | `""` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Specify maximum no. of nodes can be added in nodegroup. | `string` | `"3"` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Specify minimum no. of nodes for nodegroup | `string` | `"1"` | no |
| <a name="input_name"></a> [name](#input\_name) | Specify the name of the EKS Nodegroup | `string` | `""` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | subnets of the VPC which can be used by EKS | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | tags for the nodegroup | `any` | `{}` | no |
| <a name="input_worker_iam_role_arn"></a> [worker\_iam\_role\_arn](#input\_worker\_iam\_role\_arn) | ARN for worker role of EKS | `string` | `""` | no |
| <a name="input_worker_iam_role_name"></a> [worker\_iam\_role\_name](#input\_worker\_iam\_role\_name) | The name of the EKS Worker IAM role | `string` | `""` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
