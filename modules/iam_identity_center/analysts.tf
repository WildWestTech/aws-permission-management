#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set_inline_policy
#https://cloudonaut.io/defining-iam-policies-with-terraform/

#Create a Permission Set
resource "aws_ssoadmin_permission_set" "Analysts" {
  name         = "Analysts"
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

#Create A Policy that we will Apply To a Permission Set
resource "aws_iam_policy" "inline-Analysts" {
  name        = "inline-Analysts"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

#Add the Custom Inline Policy to the Permission Set
#This reuquired us to create our unique permission requirements
resource "aws_ssoadmin_permission_set_inline_policy" "Analysts" {
  inline_policy      = aws_iam_policy.inline-Analysts.policy
  instance_arn       = aws_ssoadmin_permission_set.Analysts.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.Analysts.arn
}

#Add a Managed Policy to the Permission Set
#These policies already exists, so we don't create anything here.  We just attache it.
#You might want to attach multiple, ex. ViewOnlyAcces, plus DBA or whatever.
#Keep that in mind for the naming of this resource (you'll want to allow for future growth, which is I'm appending -ViewOnlyAccess)
resource "aws_ssoadmin_managed_policy_attachment" "Analysts-ViewOnlyAccess" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.Analysts.arn
}

#Assign Permission Set, Which Now Has a Managed Policy and Custom Inline Policy Attached
#To An Instance of You SSO
#And a Specific Group of Users
#using a for_each loop to assign this permission set to multiple accounts
resource "aws_ssoadmin_account_assignment" "analysts" {
  for_each              = toset(["${var.dev_account}","${var.prod_account}"])
  instance_arn          = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn    = aws_ssoadmin_permission_set.Analysts.arn
  principal_id          = data.aws_identitystore_group.analysts.group_id
  principal_type        = "GROUP"

  target_id             = each.value
  target_type           = "AWS_ACCOUNT"
}