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
        bucket          = "wildwesttech-terraform-backend-state-management"
        key             = "terraform-permission-management/terraform.tfstate"
        region          = "us-east-1"
        dynamodb_table  = "terraform-state-locking"
        encrypt         = true
        profile         = "643000937293_AdministratorAccess"
    }
}

provider "aws" {
    profile = "643000937293_AdministratorAccess"
    region  = "us-east-1"
}

module "permission-sets" {
    source = "../../modules/iam_identity_center"
    dev_account     = "251863357540"
    prod_account    = "264940530023"
}