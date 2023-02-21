# IAM Identity Center Group: dataengineering
resource "aws_identitystore_group" "dataengineers" {
  display_name    = "dataengineers"
  description     = "dataengineering team"
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

# Add a user to the dataengineering group
resource "aws_identitystore_group_membership" "dataengineers" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  group_id          = aws_identitystore_group.dataengineers.group_id
  member_id         = data.aws_identitystore_user.andrew.user_id
}

#Create a Permission Set
resource "aws_ssoadmin_permission_set" "dataengineers" {
  name         = "DataEngineers"
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

#Assign The DataEngineers Group to the new DataEngineers Permission-Set
#We can do this with or without assigning the set to an account.

#If we want to map this to accounts, we would include the account ids like so:
#for_each = toset(["${var.dev_account}","${var.prod_account}"])
resource "aws_ssoadmin_account_assignment" "dataengineers" {
  for_each              = toset([])
  instance_arn          = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn    = aws_ssoadmin_permission_set.dataengineers.id
  principal_id          = aws_identitystore_group.dataengineers.group_id
  principal_type        = "GROUP"
  target_id             = each.value
  target_type           = "AWS_ACCOUNT"
}
