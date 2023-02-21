#============================================================================================================
# EMRStudio_User_Role
#============================================================================================================
resource "aws_iam_role" "EMRStudio_User_Role" {
  name = "EMRStudio_User_Role"
  assume_role_policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Principal": {
            "Service": "elasticmapreduce.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
        }
    ]
    }
    EOF
}

#============================================================================================================
# Attach Policies Below
#============================================================================================================

resource "aws_iam_role_policy_attachment" "EMRStudio_Advanced_User_Policy" {
  role       = aws_iam_role.EMRStudio_User_Role.name
  policy_arn = aws_iam_policy.EMRStudio_Advanced_User_Policy.arn
}

resource "aws_iam_role_policy_attachment" "EMRStudio_Intermediate_User_Policy" {
  role       = aws_iam_role.EMRStudio_User_Role.name
  policy_arn = aws_iam_policy.EMRStudio_Intermediate_User_Policy.arn
}

resource "aws_iam_role_policy_attachment" "EMRStudio_Basic_User_Policy" {
  role       = aws_iam_role.EMRStudio_User_Role.name
  policy_arn = aws_iam_policy.EMRStudio_Basic_User_Policy.arn
}

#============================================================================================================
# Policy: EMRStudio_Advanced_User_Policy 
# Review PassRole and how this deprecation will change things 
# https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-managed-iam-policies.html
#============================================================================================================

resource "aws_iam_policy" "EMRStudio_Advanced_User_Policy" {
  name = "EMRStudio_Advanced_User_Policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "elasticmapreduce:CreateEditor",
                "elasticmapreduce:DescribeEditor",
                "elasticmapreduce:ListEditors",
                "elasticmapreduce:StartEditor",
                "elasticmapreduce:StopEditor",
                "elasticmapreduce:DeleteEditor",
                "elasticmapreduce:OpenEditorInConsole",
                "elasticmapreduce:AttachEditor",
                "elasticmapreduce:DetachEditor",
                "elasticmapreduce:CreateRepository",
                "elasticmapreduce:DescribeRepository",
                "elasticmapreduce:DeleteRepository",
                "elasticmapreduce:ListRepositories",
                "elasticmapreduce:LinkRepository",
                "elasticmapreduce:UnlinkRepository",
                "elasticmapreduce:DescribeCluster",
                "elasticmapreduce:ListInstanceGroups",
                "elasticmapreduce:ListBootstrapActions",
                "elasticmapreduce:ListClusters",
                "elasticmapreduce:ListSteps",
                "elasticmapreduce:CreatePersistentAppUI",
                "elasticmapreduce:DescribePersistentAppUI",
                "elasticmapreduce:GetPersistentAppUIPresignedURL",
                "elasticmapreduce:GetOnClusterAppUIPresignedURL"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "AllowEMRBasicActions"
        },
        {
            "Action": [
                "emr-containers:DescribeVirtualCluster",
                "emr-containers:ListVirtualClusters",
                "emr-containers:DescribeManagedEndpoint",
                "emr-containers:ListManagedEndpoints",
                "emr-containers:CreateAccessTokenForManagedEndpoint",
                "emr-containers:DescribeJobRun",
                "emr-containers:ListJobRuns"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "AllowEMRContainersBasicActions"
        },
        {
            "Action": "secretsmanager:ListSecrets",
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "AllowSecretManagerListSecrets"
        },
        {
            "Condition": {
                "StringEquals": {
                    "aws:RequestTag/for-use-with-amazon-emr-managed-policies": "true"
                }
            },
            "Action": [
                "secretsmanager:CreateSecret"
            ],
            "Resource": [
                "arn:aws:secretsmanager:*:*:secret:emr-studio-*"
            ],
            "Effect": "Allow",
            "Sid": "AllowSecretCreationWithEMRTagsAndEMRStudioPrefix"
        },
        {
            "Action": [
                "secretsmanager:TagResource"
            ],
            "Resource": [
                "arn:aws:secretsmanager:*:*:secret:emr-studio-*"
            ],
            "Effect": "Allow",
            "Sid": "AllowAddingTagsOnSecretsWithEMRStudioPrefix"
        },
        {
            "Action": "iam:PassRole",
            "Resource": [
                "arn:aws:iam::${var.account}:role/EMRStudio_Service_Role",
                "arn:aws:iam::${var.account}:role/EMR_DefaultRole",
                "arn:aws:iam::${var.account}:role/EMR_EC2_DefaultRole"
            ],
            "Effect": "Allow",
            "Sid": "AllowPassingServiceRoleForWorkspaceCreation"
        },
        {
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::*",
            "Effect": "Allow",
            "Sid": "AllowS3ListAndLocationPermissions"
        },
        {
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::aws-logs-${var.account}-${var.region}/elasticmapreduce/*"
            ],
            "Effect": "Allow",
            "Sid": "AllowS3ReadOnlyAccessToLogs"
        },
        {
            "Action": [
                "servicecatalog:DescribeProduct",
                "servicecatalog:DescribeProductView",
                "servicecatalog:ListLaunchPaths",
                "servicecatalog:DescribeProvisioningParameters",
                "servicecatalog:ProvisionProduct",
                "servicecatalog:SearchProducts",
                "servicecatalog:ListProvisioningArtifacts",
                "servicecatalog:DescribeRecord",
                "cloudformation:DescribeStackResources"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "AllowClusterTemplatesRelatedIntermediateActions"
        },
        {
            "Action": [
                "elasticmapreduce:RunJobFlow"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "AllowAdvancedActions"
        }
    ]
}
    EOF
}

#============================================================================================================
# Policy: EMRStudio_Intermediate_User_Policy 
# Review PassRole and how this deprecation will change things 
# https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-managed-iam-policies.html
#============================================================================================================

resource "aws_iam_policy" "EMRStudio_Intermediate_User_Policy" {
  name = "EMRStudio_Intermediate_User_Policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "elasticmapreduce:CreateEditor",
                "elasticmapreduce:DescribeEditor",
                "elasticmapreduce:ListEditors",
                "elasticmapreduce:StartEditor",
                "elasticmapreduce:StopEditor",
                "elasticmapreduce:DeleteEditor",
                "elasticmapreduce:OpenEditorInConsole",
                "elasticmapreduce:AttachEditor",
                "elasticmapreduce:DetachEditor",
                "elasticmapreduce:CreateRepository",
                "elasticmapreduce:DescribeRepository",
                "elasticmapreduce:DeleteRepository",
                "elasticmapreduce:ListRepositories",
                "elasticmapreduce:LinkRepository",
                "elasticmapreduce:UnlinkRepository",
                "elasticmapreduce:DescribeCluster",
                "elasticmapreduce:ListInstanceGroups",
                "elasticmapreduce:ListBootstrapActions",
                "elasticmapreduce:ListClusters",
                "elasticmapreduce:ListSteps",
                "elasticmapreduce:CreatePersistentAppUI",
                "elasticmapreduce:DescribePersistentAppUI",
                "elasticmapreduce:GetPersistentAppUIPresignedURL",
                "elasticmapreduce:GetOnClusterAppUIPresignedURL"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "AllowEMRBasicActions"
        },
        {
            "Action": [
                "emr-containers:DescribeVirtualCluster",
                "emr-containers:ListVirtualClusters",
                "emr-containers:DescribeManagedEndpoint",
                "emr-containers:ListManagedEndpoints",
                "emr-containers:CreateAccessTokenForManagedEndpoint",
                "emr-containers:DescribeJobRun",
                "emr-containers:ListJobRuns"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "AllowEMRContainersBasicActions"
        },
        {
            "Action": "secretsmanager:ListSecrets",
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "AllowSecretManagerListSecrets"
        },
        {
            "Condition": {
                "StringEquals": {
                    "aws:RequestTag/for-use-with-amazon-emr-managed-policies": "true"
                }
            },
            "Action": [
                "secretsmanager:CreateSecret"
            ],
            "Resource": [
                "arn:aws:secretsmanager:*:*:secret:emr-studio-*"
            ],
            "Effect": "Allow",
            "Sid": "AllowSecretCreationWithEMRTagsAndEMRStudioPrefix"
        },
        {
            "Action": [
                "secretsmanager:TagResource"
            ],
            "Resource": [
                "arn:aws:secretsmanager:*:*:secret:emr-studio-*"
            ],
            "Effect": "Allow",
            "Sid": "AllowAddingTagsOnSecretsWithEMRStudioPrefix"
        },
        {
            "Action": "iam:PassRole",
            "Resource": [
                "arn:aws:iam::${var.account}:role/EMRStudio_Service_Role"
            ],
            "Effect": "Allow",
            "Sid": "AllowPassingServiceRoleForWorkspaceCreation"
        },
        {
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::*",
            "Effect": "Allow",
            "Sid": "AllowS3ListAndLocationPermissions"
        },
        {
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::aws-logs-${var.account}-${var.region}/elasticmapreduce/*"
            ],
            "Effect": "Allow",
            "Sid": "AllowS3ReadOnlyAccessToLogs"
        },
        {
            "Action": [
                "servicecatalog:DescribeProduct",
                "servicecatalog:DescribeProductView",
                "servicecatalog:ListLaunchPaths",
                "servicecatalog:DescribeProvisioningParameters",
                "servicecatalog:ProvisionProduct",
                "servicecatalog:SearchProducts",
                "servicecatalog:ListProvisioningArtifacts",
                "servicecatalog:DescribeRecord",
                "cloudformation:DescribeStackResources"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "AllowClusterTemplatesRelatedIntermediateActions"
        }
    ]
}
    EOF
}

#============================================================================================================
# Policy: EMRStudio_Intermediate_User_Policy 
# Review PassRole and how this deprecation will change things 
# https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-managed-iam-policies.html
#============================================================================================================

resource "aws_iam_policy" "EMRStudio_Basic_User_Policy" {
  name = "EMRStudio_Basic_User_Policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "elasticmapreduce:CreateEditor",
                "elasticmapreduce:DescribeEditor",
                "elasticmapreduce:ListEditors",
                "elasticmapreduce:StartEditor",
                "elasticmapreduce:StopEditor",
                "elasticmapreduce:DeleteEditor",
                "elasticmapreduce:OpenEditorInConsole",
                "elasticmapreduce:AttachEditor",
                "elasticmapreduce:DetachEditor",
                "elasticmapreduce:CreateRepository",
                "elasticmapreduce:DescribeRepository",
                "elasticmapreduce:DeleteRepository",
                "elasticmapreduce:ListRepositories",
                "elasticmapreduce:LinkRepository",
                "elasticmapreduce:UnlinkRepository",
                "elasticmapreduce:DescribeCluster",
                "elasticmapreduce:ListInstanceGroups",
                "elasticmapreduce:ListBootstrapActions",
                "elasticmapreduce:ListClusters",
                "elasticmapreduce:ListSteps",
                "elasticmapreduce:CreatePersistentAppUI",
                "elasticmapreduce:DescribePersistentAppUI",
                "elasticmapreduce:GetPersistentAppUIPresignedURL",
                "elasticmapreduce:GetOnClusterAppUIPresignedURL"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "AllowEMRBasicActions"
        },
        {
            "Action": [
                "emr-containers:DescribeVirtualCluster",
                "emr-containers:ListVirtualClusters",
                "emr-containers:DescribeManagedEndpoint",
                "emr-containers:ListManagedEndpoints",
                "emr-containers:CreateAccessTokenForManagedEndpoint",
                "emr-containers:DescribeJobRun",
                "emr-containers:ListJobRuns"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "AllowEMRContainersBasicActions"
        },
        {
            "Action": "secretsmanager:ListSecrets",
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "AllowSecretManagerListSecrets"
        },
        {
            "Condition": {
                "StringEquals": {
                    "aws:RequestTag/for-use-with-amazon-emr-managed-policies": "true"
                }
            },
            "Action": [
                "secretsmanager:CreateSecret"
            ],
            "Resource": [
                "arn:aws:secretsmanager:*:*:secret:emr-studio-*"
            ],
            "Effect": "Allow",
            "Sid": "AllowSecretCreationWithEMRTagsAndEMRStudioPrefix"
        },
        {
            "Action": [
                "secretsmanager:TagResource"
            ],
            "Resource": [
                "arn:aws:secretsmanager:*:*:secret:emr-studio-*"
            ],
            "Effect": "Allow",
            "Sid": "AllowAddingTagsOnSecretsWithEMRStudioPrefix"
        },
        {
            "Action": "iam:PassRole",
            "Resource": [
                "arn:aws:iam::${var.account}:role/EMRStudio_Service_Role"
            ],
            "Effect": "Allow",
            "Sid": "AllowPassingServiceRoleForWorkspaceCreation"
        },
        {
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::*",
            "Effect": "Allow",
            "Sid": "AllowS3ListAndLocationPermissions"
        },
        {
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::aws-logs-${var.account}-${var.region}/elasticmapreduce/*"
            ],
            "Effect": "Allow",
            "Sid": "AllowS3ReadOnlyAccessToLogs"
        }
    ]
}
    EOF
}