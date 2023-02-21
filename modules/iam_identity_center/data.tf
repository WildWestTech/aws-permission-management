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

#Identify the Group, which we will Assign these Permissions To
data "aws_identitystore_group" "admins" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  filter {
    attribute_path  = "DisplayName"
    attribute_value = "admins"
  }
}

data "aws_identitystore_user" "andrew" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  alternate_identifier {
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = "andrew"
    }
  }
}
