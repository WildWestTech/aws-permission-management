resource "aws_iam_role" "EMR_EC2_Admin_Role" {
  name = "EMR_EC2_Admin_Role"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/PowerUserAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role"
    ]
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


resource "aws_iam_instance_profile" "EMR_EC2_Admin_Role" {
  name = aws_iam_role.EMR_EC2_Admin_Role.name
  role = aws_iam_role.EMR_EC2_Admin_Role.name
}