#https://docs.aws.amazon.com/mwaa/latest/userguide/mwaa-slr.html
#This policy is linked to a service and used only with a service-linked role for that service. You cannot attach, detach, modify, or delete this policy.
resource "aws_iam_service_linked_role" "AmazonMWAAExecutionRolePolicy" {
  aws_service_name = "airflow.amazonaws.com"
}