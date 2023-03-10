#===========================================================
# helpful commands
# terraform init
# terraform plan
# terraform apply
# terraform force-unlock <lock-id>
#===========================================================
# telling terraform where and how to work with the statefile
# we're storing it in an s3 bucket in aws
#===========================================================
terraform {
    backend "s3" {
        bucket          = "wildwesttech-terraform-backend-state-dev"
        key             = "aws-permission-management-dev/terraform.tfstate"
        region          = "us-east-1"
        dynamodb_table  = "terraform-state-locking"
        encrypt         = true
        profile         = "251863357540_AdministratorAccess"
    }

}
provider "aws" {
    profile = "251863357540_AdministratorAccess"
    region  = "us-east-1"
}

module "iam" {
    source  = "../../modules/iam"
    account = "251863357540"
    region  = "us-east-1"
    env     = "dev"
}