## EKS Example

This directory contains a complete example that demonstrates the usage of the Terraform AWS EKS module to provision an EKS cluster and associated resources in AWS. The example showcases a fully configured EKS environment with multiple node groups, custom tags, and Kubernetes labels.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.47 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.47 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kms"></a> [kms](#module\_kms) | terraform-aws-modules/kms/aws | n/a |
| <a name="module_key_pair_vpn"></a> [key\_pair\_vpn](#module\_key\_pair\_vpn) | squareops/keypair/aws | n/a |
| <a name="module_key_pair_eks"></a> [key\_pair\_eks](#module\_key\_pair\_eks) | squareops/keypair/aws | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | git@github.com:rachit89/terraform-aws-vpc.git | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | ../../ | n/a |
| <a name="module_managed_node_group_addons"></a> [managed\_node\_group\_addons](#module\_managed\_node\_group\_addons) | ../..//modules/managed-nodegroup | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_region"></a> [aws\_region](#output\_aws\_region) | AWS region in which the EKS cluster is created. |
| <a name="output_eks_cluster_name"></a> [eks\_cluster\_name](#output\_eks\_cluster\_name) | Name of the Kubernetes cluster. |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint URL for the EKS control plane. |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | Security group IDs that are attached to the control plane of the EKS cluster. |
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | ARN of the EKS Cluster. |
| <a name="output_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#output\_cluster\_oidc\_issuer\_url) | URL of the OpenID Connect identity provider on the EKS cluster. |
| <a name="output_worker_iam_role_arn"></a> [worker\_iam\_role\_arn](#output\_worker\_iam\_role\_arn) | ARN of the IAM role assigned to the EKS worker nodes. |
| <a name="output_worker_iam_role_name"></a> [worker\_iam\_role\_name](#output\_worker\_iam\_role\_name) | Name of the IAM role assigned to the EKS worker nodes. |
| <a name="output_kms_policy_arn"></a> [kms\_policy\_arn](#output\_kms\_policy\_arn) | ARN of the KMS policy that is used by the EKS cluster. |
| <a name="output_managed_ng_node_group_arn"></a> [managed\_ng\_node\_group\_arn](#output\_managed\_ng\_node\_group\_arn) | ARN for the nodegroup |
| <a name="output_managed_ng_min_node"></a> [managed\_ng\_min\_node](#output\_managed\_ng\_min\_node) | Minimum node of managed node group |
| <a name="output_managed_ng_max_node"></a> [managed\_ng\_max\_node](#output\_managed\_ng\_max\_node) | Maximum node of managed node group |
| <a name="output_managed_ng_desired_node"></a> [managed\_ng\_desired\_node](#output\_managed\_ng\_desired\_node) | Desired node of managed node group |
| <a name="output_managed_ng_capacity_type"></a> [managed\_ng\_capacity\_type](#output\_managed\_ng\_capacity\_type) | Capacity type of managed node |
| <a name="output_managed_ng_instance_types"></a> [managed\_ng\_instance\_types](#output\_managed\_ng\_instance\_types) | Instance types of managed node |
| <a name="output_managed_ng_disk_size"></a> [managed\_ng\_disk\_size](#output\_managed\_ng\_disk\_size) | Disk size of node in managed node group |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
