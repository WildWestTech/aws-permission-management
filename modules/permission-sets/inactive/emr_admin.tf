#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set_inline_policy
#https://cloudonaut.io/defining-iam-policies-with-terraform/
#https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-studio-admin-permissions.html

#Create a Permission Set
resource "aws_ssoadmin_permission_set" "EMR_Admin" {
  name         = "EMR_Admin"
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

#Create A Policy that we will Apply To a Permission Set
resource "aws_iam_policy" "inline-EMR-Admin" {
  name        = "inline-EMR-Admin"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": [
              "arn:aws:elasticmapreduce:${var.region}:${var.dev_account}:studio/*",
              "arn:aws:elasticmapreduce:${var.region}:${var.prod_account}:studio/*"
            ],
            "Action": [
                "elasticmapreduce:CreateStudio",
                "elasticmapreduce:DescribeStudio",
                "elasticmapreduce:DeleteStudio",
                "elasticmapreduce:CreateStudioSessionMapping",
                "elasticmapreduce:GetStudioSessionMapping",
                "elasticmapreduce:UpdateStudioSessionMapping",
                "elasticmapreduce:DeleteStudioSessionMapping"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": "*",
            "Action": [
                "elasticmapreduce:ListStudios",
                "elasticmapreduce:ListStudioSessionMappings"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:iam::${var.dev_account}:role/${var.EMRStudio-Service-Role}",
                "arn:aws:iam::${var.prod_account}:role/${var.EMRStudio-Service-Role}",
                "arn:aws:iam::${var.dev_account}:role/${var.EMRStudio-User-Role}",
                "arn:aws:iam::${var.prod_account}:role/${var.EMRStudio-User-Role}"
            ],
            "Action": "iam:PassRole"
        },
        {
            "Effect": "Allow",
            "Resource": "*",
            "Action": [
                "sso:CreateManagedApplicationInstance",
                "sso:GetManagedApplicationInstance",
                "sso:DeleteManagedApplicationInstance",
                "sso:AssociateProfile",
                "sso:DisassociateProfile",
                "sso:GetProfile",
                "sso:ListDirectoryAssociations",
                "sso:ListProfiles",
                "sso-directory:SearchUsers",
                "sso-directory:SearchGroups",
                "sso-directory:DescribeUser",
                "sso-directory:DescribeGroup"
            ]
        }
    ]
}
EOF
}

#Add the Custom Inline Policy to the Permission Set
#This reuquired us to create our unique permission requirements
resource "aws_ssoadmin_permission_set_inline_policy" "EMR_Admin" {
  inline_policy      = aws_iam_policy.inline-EMR-Admin.policy
  instance_arn       = aws_ssoadmin_permission_set.EMR_Admin.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.EMR_Admin.arn
}

#Assign Permission Set, Which Now Has a Managed Policy and Custom Inline Policy Attached
#To An Instance of You SSO
#And a Specific Group of Users
#using a for_each loop to assign this permission set to multiple accounts
resource "aws_ssoadmin_account_assignment" "EMR_Admins" {
  for_each              = toset(["${var.dev_account}","${var.prod_account}"])
  instance_arn          = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn    = aws_ssoadmin_permission_set.EMR_Admin.arn
  principal_id          = data.aws_identitystore_group.admins.group_id
  principal_type        = "GROUP"

  target_id             = each.value
  target_type           = "AWS_ACCOUNT"
}