## IAM permissions

<!-- BEGINNING OF PRE-COMMIT-PIKE DOCS HOOK -->
The Policy required is:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeImages",
                "ec2:DescribeSubnets",
                "ec2:DeleteLaunchTemplate",
                "ec2:CreateLaunchTemplate",
                "ec2:DescribeInstanceTypes",
                "ec2:DescribeLaunchTemplates",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAvailabilityZones",
                "ec2:CreateLaunchTemplateVersion",
                "ec2:DescribeLaunchTemplateVersions"  

            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "eks:TagResource",
                "eks:UntagResource",
                "eks:CreateNodegroup",
                "eks:DeleteNodegroup",
                "eks:DescribeCluster",
                "eks:DescribeNodegroup",  
                "eks:UpdateNodegroupConfig"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": [
                "iam:TagRole"
                "iam:GetRole",
                "iam:GetPolicy",
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:ListPolicies",
                "iam:CreatePolicy",
                "iam:DeletePolicy",  
                "iam:AttachRolePolicy",
                "iam:ListRolePolicies",
                "iam:DetachRolePolicy",  
                "iam:GetPolicyVersion",
                "iam:ListPolicyVersions",
                "iam:CreateServiceLinkedRole",
                "iam:ListAttachedRolePolicies",
                "iam:ListInstanceProfilesForRole"
            ],
            "Resource": [
                "*"
            ]
        }  
    ]
}

```
<!-- END OF PRE-COMMIT-PIKE DOCS HOOK -->
