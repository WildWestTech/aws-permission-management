#=================================================================
# Required for EMR Studio
# This role is created by default, but was missing for me
# https://docs.aws.amazon.com/emr/latest/ManagementGuide/using-service-linked-roles.html
#=================================================================
resource "aws_iam_service_linked_role" "AWSServiceRoleForEMRCleanup" {
  aws_service_name = "elasticmapreduce.amazonaws.com"
}
#=================================================================
# Creates the following trust relationship
#=================================================================
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Principal": {
#                 "Service": "elasticmapreduce.amazonaws.com"
#             },
#             "Action": "sts:AssumeRole"
#         }
#     ]
# }
#=================================================================
# Attaches this managed policy
# arn:aws:iam::aws:policy/aws-service-role/AmazonEMRCleanupPolicy
#=================================================================