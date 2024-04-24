# AWS EKS Terraform module
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://squareops.com/wp-content/uploads/2020/05/Squareops-png-white.png1-3.png">
  <source media="(prefers-color-scheme: light)" srcset="https://squareops.com/wp-content/uploads/2021/09/Squareops-png-1-1.png">
  <img src="https://squareops.com/wp-content/uploads/2021/09/Squareops-png-1-1.png">
</picture>

### [SquareOps Technologies](https://squareops.com/) Your DevOps Partner for Accelerating cloud journey.
<br>
This module simplifies the deployment of EKS clusters with dual stack mode for Cluster IP family like IPv6 and IPv4, allowing users to quickly create and manage a production-grade Kubernetes cluster on AWS. The module is highly configurable, allowing users to customize various aspects of the EKS cluster, such as the Kubernetes version, worker node instance type, number of worker nodes, and now with added support for EKS version 1.28.
<br>
we've introduced a new functionality that enhances the ease of cluster setup. Users can now choose to create a default nodegroup based on the  value of default_addon_enabled.the module now seamlessly integrates default addons, including CoreDNS, Kube-proxy, VPC CNI, and EBS CSI Driver. This ensures that your EKS clusters are equipped with essential components for optimal performance and functionality right from the start.
<br>
With this module, users can take advantage of the latest features and improvements offered by EKS 1.28 while maintaining the ease and convenience of automated deployment. The module provides a streamlined solution for setting up EKS clusters, reducing the manual effort required for setup and configuration.


## Usage Example

```hcl
module "eks" {
  source                                   = "squareops/eks/aws"
  name                                     = "skaf"
  vpc_id                                   = "vpc-xyz425342176"
  vpc_subnet_ids                           = [module.vpc.vpc_private_subnets[0]]
  eks_ng_min_size                          = 2
  eks_ng_max_size                          = 5
  eks_ng_desired_size                      = 2
  eks_ebs_volume_size                      = 50
  eks_ng_capacity_type                     = "ON_DEMAND"
  eks_ng_instance_types                    = ["t3a.large", "t2.large", "t2.xlarge", "t3.large", "m5.large"]
  environment                              = "prod"
  eks_kms_key_arn                          = "arn:aws:kms:us-east-2:222222222222:key/kms_key_arn"
  eks_cluster_version                      = "1.29"
  eks_cluster_log_types                    = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  vpc_private_subnet_ids                   = ["subnet-abc123" , "subnet-xyz12324"]
  eks_cluster_log_retention_in_days        = 30
  eks_cluster_endpoint_public_access       = true
  eks_cluster_endpoint_private_access      = false
  eks_cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  aws_auth_configmap_enabled               = true
  eks_default_addon_enabled                = true
  eks_nodes_keypair_name                   = module.key_pair_eks.key_pair_name
  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::222222222222:role/service-role"
      username = "username"
      groups   = ["system:masters"]
    }
  ]
  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::222222222222:user/aws-user"
      username = "aws-user"
      groups   = ["system:masters"]
    },
  ]
  eks_cluster_security_group_additional_rules = {
    ingress_port_mgmt_tcp = {
      description = "mgmt vpc cidr"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = ["10.10.0.0/16"]
    }
  }
}

module "managed_node_group_addons" {
  source                        = "squareops/eks/aws//modules/managed-nodegroup"
  depends_on                    = [module.eks]
  managed_ng_name               = "addons"
  managed_ng_min_size           = 2
  managed_ng_max_size           = 2
  managed_ng_desired_size       = 2
  vpc_subnet_ids                = ["subnet-abc123"]
  environment                   = "prod"
  managed_ng_kms_key_arn        = "arn:aws:kms:us-east-2:222222222222:key/kms_key_arn"
  managed_ng_capacity_type      = "ON_DEMAND"
  managed_ng_ebs_volume_size    = 50
  managed_ng_instance_types     = ["t3a.large", "t2.large", "t2.xlarge", "t3.large", "m5.large"]
  managed_ng_kms_policy_arn     = module.eks.kms_policy_arn
  eks_cluster_name       = module.eks.eks_cluster_name
  worker_iam_role_name   = module.eks.worker_iam_role_name
  worker_iam_role_arn    = module.eks.worker_iam_role_arn
  default_addon_enabled  = true
  managed_ng_pod_capacity= 90
  managed_ng_monitoring_enabled = true
  eks_nodes_keypair_name = "key-pair-name"
  k8s_labels = {
    "Addons-Services" = "true"
  }
  tags = {
    Name = "prod-cluster"
  }
}

module "fargate_profle" {
  source               = "squareops/eks/aws//modules/fargate-profile"
  depends_on           = [module.eks]
  fargate_profile_name = "app"
  fargate_subnet_ids   = ["subnet-abc123"]
  environment          = "prod"
  eks_cluster_name     = module.eks.eks_cluster_name
  fargate_namespace    = "default"
  labels = {
    "App-Services" = "fargate"
  }
}

```
Refer [examples](https://github.com/squareops/terraform-aws-eks/tree/main/examples/complete) for more details.

## IAM Permissions
The required IAM permissions to create resources from this module can be found [here](https://github.com/squareops/terraform-aws-eks/blob/main/IAM.md)


## EKS-Addons

The EKS module is designed to be used as a standalone Terraform module. We recommend using [EKS-Addons](https://registry.terraform.io/modules/squareops/eks-addons/aws/latest) module  in conjunction to enhance functionality.

## CIS COMPLIANCE [<img src="	https://prowler.pro/wp-content/themes/prowler-pro/assets/img/logo.svg" width="250" align="right" />](https://prowler.pro/)

Security scanning is graciously provided by Prowler. Prowler is the leading fully hosted, cloud-native solution providing continuous cluster security and compliance.

In this module, we have implemented the following CIS Compliance checks for EKS:

| Benchmark | Description | Status |
|--------|---------------|----------|
| Ensure EKS Control Plane Audit Logging is enabled for all log types | Control plane logging enabled and correctly configured for EKS cluster | &#x2714; |
| Ensure Kubernetes Secrets are encrypted using Customer Master Keys (CMKs) | Encryption for Kubernetes secrets is configured for EKS cluster | &#x2714; |
| Ensure EKS Clusters are created with Private Endpoint Enabled and Public Access Disabled | Cluster endpoint access is private for EKS cluster  | &#x2714; |
| Restrict Access to the EKS Control Plane Endpoint | Cluster control plane access is restricted for EKS cluster | &#x2714; |


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.10.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.20.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9.2 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks_addon"></a> [eks\_addon](#module\_eks\_addon) | terraform-aws-modules/eks/aws | 19.21.0 |
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 19.21.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eks_node_group.default_ng](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_policy.eks_cni_ipv6_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.kubernetes_pvc_kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.node_autoscaler_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.S3Access_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.SSMManagedInstanceCore_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_kms_cluster_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_kms_worker_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_worker_ecr_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_worker_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_autoscaler_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.eks_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [null_resource.update_cni_prifix](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_ami.launch_template_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy.S3Access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.SSMManagedInstanceCore](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [template_file.launch_template_userdata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_aws_tags"></a> [additional\_aws\_tags](#input\_additional\_aws\_tags) | Additional tags to be applied to AWS resources | `map(string)` | `{}` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Name of the AWS region where S3 bucket is to be created. | `string` | `"us-east-1"` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | Account ID of the AWS Account. | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment identifier for the EKS cluster, such as dev, qa, prod, etc. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Specify the name of the EKS cluster. | `string` | `""` | no |
| <a name="input_eks_cluster_version"></a> [eks\_cluster\_version](#input\_eks\_cluster\_version) | Specifies the Kubernetes version (major.minor) to use for the EKS cluster. | `string` | `""` | no |
| <a name="input_eks_cluster_endpoint_public_access"></a> [eks\_cluster\_endpoint\_public\_access](#input\_eks\_cluster\_endpoint\_public\_access) | Whether the Amazon EKS public API server endpoint is enabled or not. | `bool` | `true` | no |
| <a name="input_irsa_enabled"></a> [irsa\_enabled](#input\_irsa\_enabled) | Set to true to associate an AWS IAM role with a Kubernetes service account. | `bool` | `true` | no |
| <a name="input_eks_cluster_endpoint_private_access"></a> [eks\_cluster\_endpoint\_private\_access](#input\_eks\_cluster\_endpoint\_private\_access) | Whether the Amazon EKS private API server endpoint is enabled or not. | `bool` | `true` | no |
| <a name="input_eks_cluster_endpoint_public_access_cidrs"></a> [eks\_cluster\_endpoint\_public\_access\_cidrs](#input\_eks\_cluster\_endpoint\_public\_access\_cidrs) | CIDR blocks that can access the Amazon EKS public API server endpoint. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where the EKS cluster will be deployed. | `string` | `""` | no |
| <a name="input_eks_kms_key_arn"></a> [eks\_kms\_key\_arn](#input\_eks\_kms\_key\_arn) | ARN of the KMS key used to encrypt EKS resources. | `string` | `""` | no |
| <a name="input_eks_cluster_log_types"></a> [eks\_cluster\_log\_types](#input\_eks\_cluster\_log\_types) | A list of desired control plane logs to enable for the EKS cluster. Valid values include: api, audit, authenticator, controllerManager, scheduler. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_eks_cluster_log_retention_in_days"></a> [eks\_cluster\_log\_retention\_in\_days](#input\_eks\_cluster\_log\_retention\_in\_days) | Retention period for EKS cluster logs in days. Default is set to 90 days. | `number` | `90` | no |
| <a name="input_vpc_private_subnet_ids"></a> [vpc\_private\_subnet\_ids](#input\_vpc\_private\_subnet\_ids) | Private subnets of the VPC which can be used by EKS | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_kms_key_enabled"></a> [kms\_key\_enabled](#input\_kms\_key\_enabled) | Controls if a KMS key for cluster encryption should be created | `bool` | `false` | no |
| <a name="input_eks_cluster_security_group_additional_rules"></a> [eks\_cluster\_security\_group\_additional\_rules](#input\_eks\_cluster\_security\_group\_additional\_rules) | List of additional security group rules to add to the cluster security group created. | `any` | `{}` | no |
| <a name="input_aws_auth_configmap_enabled"></a> [aws\_auth\_configmap\_enabled](#input\_aws\_auth\_configmap\_enabled) | Determines whether to manage the aws-auth configmap | `bool` | `false` | no |
| <a name="input_aws_auth_users"></a> [aws\_auth\_users](#input\_aws\_auth\_users) | List of user maps to add to the aws-auth configmap | `any` | `[]` | no |
| <a name="input_aws_auth_roles"></a> [aws\_auth\_roles](#input\_aws\_auth\_roles) | List of role maps to add to the aws-auth configmap | `list(any)` | `[]` | no |
| <a name="input_ipv6_enabled"></a> [ipv6\_enabled](#input\_ipv6\_enabled) | Enable cluster IP family as Ipv6 | `bool` | `false` | no |
| <a name="input_eks_default_addon_enabled"></a> [eks\_default\_addon\_enabled](#input\_eks\_default\_addon\_enabled) | Enable deafult addons(vpc-cni, ebs-csi) at the time of cluster creation | `bool` | `false` | no |
| <a name="input_eks_nodes_keypair_name"></a> [eks\_nodes\_keypair\_name](#input\_eks\_nodes\_keypair\_name) | The public key to be used for EKS cluster worker nodes. | `string` | `""` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of EKS cluster | `string` | `""` | no |
| <a name="input_eks_ng_instance_types"></a> [eks\_ng\_instance\_types](#input\_eks\_ng\_instance\_types) | The instance types to be used for the EKS node group (e.g., t2.medium). | `list(any)` | <pre>[<br>  "t3a.medium"<br>]</pre> | no |
| <a name="input_eks_ng_capacity_type"></a> [eks\_ng\_capacity\_type](#input\_eks\_ng\_capacity\_type) | The capacity type for the EKS node group (ON\_DEMAND or SPOT). | `string` | `"ON_DEMAND"` | no |
| <a name="input_image_high_threshold_percent"></a> [image\_high\_threshold\_percent](#input\_image\_high\_threshold\_percent) | The percentage of disk usage at which garbage collection should be triggered. | `number` | `60` | no |
| <a name="input_image_low_threshold_percent"></a> [image\_low\_threshold\_percent](#input\_image\_low\_threshold\_percent) | The percentage of disk usage at which garbage collection took place. | `number` | `40` | no |
| <a name="input_eventRecordQPS"></a> [eventRecordQPS](#input\_eventRecordQPS) | The maximum number of events created per second. | `number` | `5` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Set to true to enable network interface for launch template. | `bool` | `false` | no |
| <a name="input_eks_ng_monitoring_enabled"></a> [eks\_ng\_monitoring\_enabled](#input\_eks\_ng\_monitoring\_enabled) | Specify whether to enable monitoring for nodes. | `bool` | `true` | no |
| <a name="input_eks_ng_min_size"></a> [eks\_ng\_min\_size](#input\_eks\_ng\_min\_size) | The minimum number of nodes for the node group. | `string` | `"1"` | no |
| <a name="input_eks_ng_max_size"></a> [eks\_ng\_max\_size](#input\_eks\_ng\_max\_size) | The maximum number of nodes that can be added to the node group. | `string` | `"3"` | no |
| <a name="input_eks_ng_desired_size"></a> [eks\_ng\_desired\_size](#input\_eks\_ng\_desired\_size) | The desired number of nodes for the node group. | `string` | `"1"` | no |
| <a name="input_eks_ebs_volume_size"></a> [eks\_ebs\_volume\_size](#input\_eks\_ebs\_volume\_size) | The type of EBS volume for nodes. | `string` | `"50"` | no |
| <a name="input_eks_ebs_volume_type"></a> [eks\_ebs\_volume\_type](#input\_eks\_ebs\_volume\_type) | Specify the type of EBS volume for nodes. | `string` | `"gp3"` | no |
| <a name="input_eks_ebs_encrypted"></a> [eks\_ebs\_encrypted](#input\_eks\_ebs\_encrypted) | Specify whether to encrypt the EBS volume for nodes. | `bool` | `true` | no |
| <a name="input_vpc_subnet_ids"></a> [vpc\_subnet\_ids](#input\_vpc\_subnet\_ids) | The IDs of the subnets in the VPC that can be used by EKS. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the node group. | `any` | `{}` | no |
| <a name="input_k8s_labels"></a> [k8s\_labels](#input\_k8s\_labels) | Labels to be applied to the Kubernetes node groups. | `map(any)` | `{}` | no |
| <a name="input_worker_iam_role_arn"></a> [worker\_iam\_role\_arn](#input\_worker\_iam\_role\_arn) | The ARN of the worker role for EKS. | `string` | `""` | no |
| <a name="input_worker_iam_role_name"></a> [worker\_iam\_role\_name](#input\_worker\_iam\_role\_name) | The name of the EKS Worker IAM role. | `string` | `""` | no |
| <a name="input_managed_ng_pod_capacity"></a> [managed\_ng\_pod\_capacity](#input\_managed\_ng\_pod\_capacity) | Maximum number of pods you want to schedule on one node. This value should not exceed 110. | `number` | `70` | no |
| <a name="input_eks_cluster_iam_role_dns_suffix"></a> [eks\_cluster\_iam\_role\_dns\_suffix](#input\_eks\_cluster\_iam\_role\_dns\_suffix) | Base DNS domain name for the current partition (e.g., amazonaws.com in AWS Commercial, amazonaws.com.cn in AWS China) | `string` | `"amazonaws.com"` | no |
| <a name="input_eks_volume_delete_on_termination"></a> [eks\_volume\_delete\_on\_termination](#input\_eks\_volume\_delete\_on\_termination) | Set to true if delete the volumes when eks cluster is terminated. | `bool` | `true` | no |
| <a name="input_eks_network_interfaces_delete_on_termination"></a> [eks\_network\_interfaces\_delete\_on\_termination](#input\_eks\_network\_interfaces\_delete\_on\_termination) | Set to true if delete the network interfaces when eks cluster is terminated. | `bool` | `true` | no |
| <a name="input_vpc_s3_endpoint_enabled"></a> [vpc\_s3\_endpoint\_enabled](#input\_vpc\_s3\_endpoint\_enabled) | Set to true if you want to enable vpc S3 endpoints | `bool` | `false` | no |
| <a name="input_vpc_ecr_endpoint_enabled"></a> [vpc\_ecr\_endpoint\_enabled](#input\_vpc\_ecr\_endpoint\_enabled) | Set to true if you want to enable vpc ecr endpoints | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_name"></a> [eks\_cluster\_name](#output\_eks\_cluster\_name) | Name of the Kubernetes cluster. |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint URL for the EKS control plane. |
| <a name="output_eks_cluster_security_group_id"></a> [eks\_cluster\_security\_group\_id](#output\_eks\_cluster\_security\_group\_id) | Security group IDs that are attached to the control plane of the EKS cluster. |
| <a name="output_eks_cluster_arn"></a> [eks\_cluster\_arn](#output\_eks\_cluster\_arn) | ARN of the EKS Cluster. |
| <a name="output_eks_cluster_oidc_issuer_url"></a> [eks\_cluster\_oidc\_issuer\_url](#output\_eks\_cluster\_oidc\_issuer\_url) | URL of the OpenID Connect identity provider on the EKS cluster. |
| <a name="output_worker_iam_role_arn"></a> [worker\_iam\_role\_arn](#output\_worker\_iam\_role\_arn) | ARN of the IAM role assigned to the EKS worker nodes. |
| <a name="output_worker_iam_role_name"></a> [worker\_iam\_role\_name](#output\_worker\_iam\_role\_name) | Name of the IAM role assigned to the EKS worker nodes. |
| <a name="output_kms_policy_arn"></a> [kms\_policy\_arn](#output\_kms\_policy\_arn) | ARN of the KMS policy that is used by the EKS cluster. |
| <a name="output_eks_cluster_certificate_authority_data"></a> [eks\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | Base64 encoded certificate data required to communicate with the cluster |
| <a name="output_default_ng_node_group_arn"></a> [default\_ng\_node\_group\_arn](#output\_default\_ng\_node\_group\_arn) | ARN for the nodegroup |
| <a name="output_default_ng_min_node"></a> [default\_ng\_min\_node](#output\_default\_ng\_min\_node) | n/a |
| <a name="output_default_ng_max_node"></a> [default\_ng\_max\_node](#output\_default\_ng\_max\_node) | n/a |
| <a name="output_default_ng_desired_node"></a> [default\_ng\_desired\_node](#output\_default\_ng\_desired\_node) | n/a |
| <a name="output_default_ng_capacity_type"></a> [default\_ng\_capacity\_type](#output\_default\_ng\_capacity\_type) | n/a |
| <a name="output_default_ng_instance_types"></a> [default\_ng\_instance\_types](#output\_default\_ng\_instance\_types) | n/a |
| <a name="output_default_ng_ebs_volume_size"></a> [default\_ng\_ebs\_volume\_size](#output\_default\_ng\_ebs\_volume\_size) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contribution & Issue Reporting

To report an issue with a project:

  1. Check the repository's [issue tracker](https://github.com/squareops/terraform-aws-eks/issues) on GitHub
  2. Search to see if the issue has already been reported
  3. If you can't find an answer to your question in the documentation or issue tracker, you can ask a question by creating a new issue. Be sure to provide enough context and details so others can understand your problem.

## License

Apache License, Version 2.0, January 2004 (http://www.apache.org/licenses/).

## Support Us

To support a GitHub project by liking it, you can follow these steps:

  1. Visit the repository: Navigate to the [GitHub repository](https://github.com/squareops/terraform-aws-eks).

  2. Click the "Star" button: On the repository page, you'll see a "Star" button in the upper right corner. Clicking on it will star the repository, indicating your support for the project.

  3. Optionally, you can also leave a comment on the repository or open an issue to give feedback or suggest changes.

Starring a repository on GitHub is a simple way to show your support and appreciation for the project. It also helps to increase the visibility of the project and make it more discoverable to others.

## Who we are

We believe that the key to success in the digital age is the ability to deliver value quickly and reliably. That’s why we offer a comprehensive range of DevOps & Cloud services designed to help your organization optimize its systems & Processes for speed and agility.

  1. We are an AWS Advanced consulting partner which reflects our deep expertise in AWS Cloud and helping 100+ clients over the last 4 years.
  2. Expertise in Kubernetes and overall container solution helps companies expedite their journey by 10X.
  3. Infrastructure Automation is a key component to the success of our Clients and our Expertise helps deliver the same in the shortest time.
  4. DevSecOps as a service to implement security within the overall DevOps process and helping companies deploy securely and at speed.
  5. Platform engineering which supports scalable,Cost efficient infrastructure that supports rapid development, testing, and deployment.
  6. 24*7 SRE service to help you Monitor the state of your infrastructure and eradicate any issue within the SLA.

We provide [support](https://squareops.com/contact-us/) on all of our projects, no matter how small or large they may be.

To find more information about our company, visit [squareops.com](https://squareops.com/), follow us on [Linkedin](https://www.linkedin.com/company/squareops-technologies-pvt-ltd/), or fill out a [job application](https://squareops.com/careers/). If you have any questions or would like assistance with your cloud strategy and implementation, please don't hesitate to [contact us](https://squareops.com/contact-us/).
