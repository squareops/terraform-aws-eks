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
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_addon.vpc_cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_node_group.managed_ng](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_launch_template.eks_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [null_resource.update_vpc_cni_env_var](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_ami.launch_template_ami_amd64](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.launch_template_ami_arm64](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_eks_cluster.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [template_file.launch_template_userdata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of EKS cluster | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment for the nodes or node groups. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Specify the name of the EKS Nodegroup | `string` | `""` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | The instance types to be used for the EKS node group (e.g., t2.medium). | `list(any)` | <pre>[<br>  "t3a.medium"<br>]</pre> | no |
| <a name="input_capacity_type"></a> [capacity\_type](#input\_capacity\_type) | The capacity type for the EKS node group (ON\_DEMAND or SPOT). | `string` | `"ON_DEMAND"` | no |
| <a name="input_image_high_threshold_percent"></a> [image\_high\_threshold\_percent](#input\_image\_high\_threshold\_percent) | The percentage of disk usage at which garbage collection should be triggered. | `number` | `60` | no |
| <a name="input_image_low_threshold_percent"></a> [image\_low\_threshold\_percent](#input\_image\_low\_threshold\_percent) | The percentage of disk usage at which garbage collection took place. | `number` | `40` | no |
| <a name="input_eventRecordQPS"></a> [eventRecordQPS](#input\_eventRecordQPS) | The maximum number of events created per second. | `number` | `5` | no |
| <a name="input_eks_nodes_keypair_name"></a> [eks\_nodes\_keypair\_name](#input\_eks\_nodes\_keypair\_name) | The public key to be used for EKS cluster worker nodes. | `string` | `""` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The KMS key ID used for encrypting node groups. | `string` | `""` | no |
| <a name="input_kms_policy_arn"></a> [kms\_policy\_arn](#input\_kms\_policy\_arn) | The KMS policy ARN used for encrypting Kubernetes PVC. | `string` | `""` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Set to true to enable network interface for launch template. | `bool` | `false` | no |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | Specify whether to enable monitoring for nodes. | `bool` | `true` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | The minimum number of nodes for the node group. | `string` | `"1"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | The maximum number of nodes that can be added to the node group. | `string` | `"3"` | no |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | The desired number of nodes for the node group. | `string` | `"3"` | no |
| <a name="input_ebs_volume_size"></a> [ebs\_volume\_size](#input\_ebs\_volume\_size) | The type of EBS volume for nodes. | `string` | `"50"` | no |
| <a name="input_ebs_volume_type"></a> [ebs\_volume\_type](#input\_ebs\_volume\_type) | Specify the type of EBS volume for nodes. | `string` | `"gp3"` | no |
| <a name="input_ebs_encrypted"></a> [ebs\_encrypted](#input\_ebs\_encrypted) | Specify whether to encrypt the EBS volume for nodes. | `bool` | `true` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The IDs of the subnets in the VPC that can be used by EKS. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the node group. | `any` | `{}` | no |
| <a name="input_k8s_labels"></a> [k8s\_labels](#input\_k8s\_labels) | Labels to be applied to the Kubernetes node groups. | `map(any)` | `{}` | no |
| <a name="input_worker_iam_role_arn"></a> [worker\_iam\_role\_arn](#input\_worker\_iam\_role\_arn) | The ARN of the worker role for EKS. | `string` | `""` | no |
| <a name="input_worker_iam_role_name"></a> [worker\_iam\_role\_name](#input\_worker\_iam\_role\_name) | The name of the EKS Worker IAM role. | `string` | `""` | no |
| <a name="input_ipv6_enabled"></a> [ipv6\_enabled](#input\_ipv6\_enabled) | Whether IPv6 enabled or not | `bool` | `false` | no |
| <a name="input_default_addon_enabled"></a> [default\_addon\_enabled](#input\_default\_addon\_enabled) | Enable default addon(VPC-CNI, AWS-EBS-CSI-DRIVER) with Cluster creation | `bool` | `false` | no |
| <a name="input_managed_ng_pod_capacity"></a> [managed\_ng\_pod\_capacity](#input\_managed\_ng\_pod\_capacity) | Maximum number of pods you want to schedule on one node. This value should not exceed 110. | `number` | `70` | no |
| <a name="input_aws_managed_node_group_arch"></a> [aws\_managed\_node\_group\_arch](#input\_aws\_managed\_node\_group\_arch) | Enter your linux architecture. | `string` | `"arm64"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_node_group_arn"></a> [node\_group\_arn](#output\_node\_group\_arn) | n/a |
| <a name="output_min_node"></a> [min\_node](#output\_min\_node) | n/a |
| <a name="output_max_node"></a> [max\_node](#output\_max\_node) | n/a |
| <a name="output_desired_node"></a> [desired\_node](#output\_desired\_node) | n/a |
| <a name="output_capacity_type"></a> [capacity\_type](#output\_capacity\_type) | n/a |
| <a name="output_instance_types"></a> [instance\_types](#output\_instance\_types) | n/a |
| <a name="output_ebs_volume_size"></a> [ebs\_volume\_size](#output\_ebs\_volume\_size) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
