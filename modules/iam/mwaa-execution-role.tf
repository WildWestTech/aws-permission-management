
#https://docs.aws.amazon.com/mwaa/latest/userguide/mwaa-create-role.html
#will restrict access later
resource "aws_iam_role" "mwaa-execution-role" {
  name = "mwaa-execution-role"
  managed_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess"]
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
            "Service": ["airflow.amazonaws.com","airflow-env.amazonaws.com"]
        },
        "Action": "sts:AssumeRole"
      }
   ]
}
    EOF
}