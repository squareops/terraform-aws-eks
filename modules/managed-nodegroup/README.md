## NodeGroup

This directory contains a Terraform module that provisions a managed node group for an existing Amazon Elastic Kubernetes Service (EKS) cluster in AWS. The module simplifies the process of creating and managing worker nodes in the EKS cluster, providing a scalable and reliable infrastructure for running containerized applications.
Features

The managed-nodegroup module offers the following features:

  1. Automatic provisioning and scaling of EC2 instances for the node group.
  2. Integration with AWS Auto Scaling to maintain desired capacity and manage node group size.
  3. Support for different instance types and sizes to meet your application requirements.
  4. Configuration of node group parameters such as instance tags, labels, and IAM roles.
  5. Flexible customization options for EBS volumes, encryption, and network settings.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_node_group.managed_ng](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_launch_template.eks_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_ami.launch_template_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_eks_cluster.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [template_file.launch_template_userdata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.launch_template_userdata_bottlerocket](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of EKS cluster | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment for the nodes or node groups. | `string` | `null` | no |
| <a name="input_managed_ng_name"></a> [managed\_ng\_name](#input\_managed\_ng\_name) | Specify the name of the EKS managed Nodegroup | `string` | `""` | no |
| <a name="input_managed_ng_instance_types"></a> [managed\_ng\_instance\_types](#input\_managed\_ng\_instance\_types) | The instance types to be used for the EKS node group (e.g., t2.medium). | `list(any)` | <pre>[<br>  "t3a.medium"<br>]</pre> | no |
| <a name="input_managed_ng_capacity_type"></a> [managed\_ng\_capacity\_type](#input\_managed\_ng\_capacity\_type) | The capacity type for the EKS node group (ON\_DEMAND or SPOT). | `string` | `"ON_DEMAND"` | no |
| <a name="input_image_high_threshold_percent"></a> [image\_high\_threshold\_percent](#input\_image\_high\_threshold\_percent) | The percentage of disk usage at which garbage collection should be triggered. | `number` | `60` | no |
| <a name="input_image_low_threshold_percent"></a> [image\_low\_threshold\_percent](#input\_image\_low\_threshold\_percent) | The percentage of disk usage at which garbage collection took place. | `number` | `40` | no |
| <a name="input_eventRecordQPS"></a> [eventRecordQPS](#input\_eventRecordQPS) | The maximum number of events created per second. | `number` | `5` | no |
| <a name="input_eks_nodes_keypair_name"></a> [eks\_nodes\_keypair\_name](#input\_eks\_nodes\_keypair\_name) | The public key to be used for EKS cluster worker nodes. | `string` | `""` | no |
| <a name="input_managed_ng_kms_key_arn"></a> [managed\_ng\_kms\_key\_arn](#input\_managed\_ng\_kms\_key\_arn) | The KMS key ID used for encrypting node groups. | `string` | `""` | no |
| <a name="input_managed_ng_kms_policy_arn"></a> [managed\_ng\_kms\_policy\_arn](#input\_managed\_ng\_kms\_policy\_arn) | The KMS policy ARN used for encrypting Kubernetes PVC. | `string` | `""` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Set to true to enable network interface for launch template. | `bool` | `false` | no |
| <a name="input_managed_ng_monitoring_enabled"></a> [managed\_ng\_monitoring\_enabled](#input\_managed\_ng\_monitoring\_enabled) | Specify whether to enable monitoring for nodes. | `bool` | `true` | no |
| <a name="input_managed_ng_min_size"></a> [managed\_ng\_min\_size](#input\_managed\_ng\_min\_size) | The minimum number of nodes for the node group. | `string` | `"1"` | no |
| <a name="input_managed_ng_max_size"></a> [managed\_ng\_max\_size](#input\_managed\_ng\_max\_size) | The maximum number of nodes that can be added to the node group. | `string` | `"3"` | no |
| <a name="input_managed_ng_desired_size"></a> [managed\_ng\_desired\_size](#input\_managed\_ng\_desired\_size) | The desired number of nodes for the node group. | `string` | `"3"` | no |
| <a name="input_managed_ng_ebs_volume_size"></a> [managed\_ng\_ebs\_volume\_size](#input\_managed\_ng\_ebs\_volume\_size) | The type of EBS volume for nodes. | `string` | `"50"` | no |
| <a name="input_managed_ng_ebs_volume_type"></a> [managed\_ng\_ebs\_volume\_type](#input\_managed\_ng\_ebs\_volume\_type) | Specify the type of EBS volume for nodes. | `string` | `"gp3"` | no |
| <a name="input_managed_ng_ebs_encrypted"></a> [managed\_ng\_ebs\_encrypted](#input\_managed\_ng\_ebs\_encrypted) | Specify whether to encrypt the EBS volume for nodes. | `bool` | `true` | no |
| <a name="input_vpc_subnet_ids"></a> [vpc\_subnet\_ids](#input\_vpc\_subnet\_ids) | The IDs of the subnets in the VPC that can be used by EKS. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the node group. | `any` | `{}` | no |
| <a name="input_k8s_labels"></a> [k8s\_labels](#input\_k8s\_labels) | Labels to be applied to the Kubernetes node groups. | `map(any)` | `{}` | no |
| <a name="input_worker_iam_role_arn"></a> [worker\_iam\_role\_arn](#input\_worker\_iam\_role\_arn) | The ARN of the worker role for EKS. | `string` | `""` | no |
| <a name="input_worker_iam_role_name"></a> [worker\_iam\_role\_name](#input\_worker\_iam\_role\_name) | The name of the EKS Worker IAM role. | `string` | `""` | no |
| <a name="input_ipv6_enabled"></a> [ipv6\_enabled](#input\_ipv6\_enabled) | Whether IPv6 enabled or not | `bool` | `false` | no |
| <a name="input_managed_ng_network_interfaces_delete_on_termination"></a> [managed\_ng\_network\_interfaces\_delete\_on\_termination](#input\_managed\_ng\_network\_interfaces\_delete\_on\_termination) | Set to true if delete the network interfaces when eks cluster is terminated. | `bool` | `true` | no |
| <a name="input_managed_ng_volume_delete_on_termination"></a> [managed\_ng\_volume\_delete\_on\_termination](#input\_managed\_ng\_volume\_delete\_on\_termination) | Set to true if delete the volumes when eks cluster is terminated. | `bool` | `true` | no |
| <a name="input_managed_ng_pod_capacity"></a> [managed\_ng\_pod\_capacity](#input\_managed\_ng\_pod\_capacity) | Maximum number of pods you want to schedule on one node. This value should not exceed 110. | `number` | `70` | no |
| <a name="input_aws_managed_node_group_arch"></a> [aws\_managed\_node\_group\_arch](#input\_aws\_managed\_node\_group\_arch) | Enter your linux architecture. | `string` | `"amd64"` | no |
| <a name="input_launch_template_name"></a> [launch\_template\_name](#input\_launch\_template\_name) | The name of the launch template. | `string` | `""` | no |
| <a name="input_enable_bottlerocket_ami"></a> [enable\_bottlerocket\_ami](#input\_enable\_bottlerocket\_ami) | Set to true to enable the use of Bottlerocket AMIs for instances. | `bool` | `false` | no |
| <a name="input_bottlerocket_node_config"></a> [bottlerocket\_node\_config](#input\_bottlerocket\_node\_config) | Bottlerocket Node configurations for EKS. | `map(any)` | <pre>{<br>  "bottlerocket_eks_enable_control_container": true,<br>  "bottlerocket_eks_node_admin_container_enabled": true<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_node_group_arn"></a> [node\_group\_arn](#output\_node\_group\_arn) | The Amazon Resource Name (ARN) of the managed node group. |
| <a name="output_managed_ng_min_node"></a> [managed\_ng\_min\_node](#output\_managed\_ng\_min\_node) | The minimum number of nodes allowed in the managed node group. |
| <a name="output_managed_ng_max_node"></a> [managed\_ng\_max\_node](#output\_managed\_ng\_max\_node) | The maximum number of nodes allowed in the managed node group. |
| <a name="output_managed_ng_desired_node"></a> [managed\_ng\_desired\_node](#output\_managed\_ng\_desired\_node) | The desired number of nodes in the managed node group. |
| <a name="output_managed_ng_capacity_type"></a> [managed\_ng\_capacity\_type](#output\_managed\_ng\_capacity\_type) | The capacity type for the managed node group (e.g., ON\_DEMAND, SPOT). |
| <a name="output_managed_ng_instance_types"></a> [managed\_ng\_instance\_types](#output\_managed\_ng\_instance\_types) | The instance types used by the managed node group. |
| <a name="output_managed_ng_ebs_volume_size"></a> [managed\_ng\_ebs\_volume\_size](#output\_managed\_ng\_ebs\_volume\_size) | The size of the EBS volume attached to each node in the managed node group. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
