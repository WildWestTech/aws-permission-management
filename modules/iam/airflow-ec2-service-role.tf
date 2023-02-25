#==============================================================
# Creating an EC2 Instance Profile / Serice Role for AirFlow
# The targe EC2 Instance will have AirFlow installed
# This is different from MWAA, which is a managed aws service
#==============================================================
resource "aws_iam_role" "airflow-ec2-service-role" {
  name = "airflow-ec2-service-role"
  managed_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess"]
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
    EOF
}


resource "aws_iam_instance_profile" "airflow-ec2-service-role" {
  name = aws_iam_role.airflow-ec2-service-role.name
  role = aws_iam_role.airflow-ec2-service-role.name
}