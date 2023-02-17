#This will be referened by all permission sets we create in this account
data "aws_ssoadmin_instances" "this" {}

#Identify the Group, which we will Assign these Permissions To
data "aws_identitystore_group" "analysts" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  filter {
    attribute_path  = "DisplayName"
    attribute_value = "analysts"
  }
}