# Boosting Permissions (adding poweruser) to see if we can install boostrap scrips (running sudo command)

resource "aws_iam_role" "EMR_EC2_DefaultRole" {
  name = "EMR_EC2_DefaultRole"
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


resource "aws_iam_instance_profile" "EMR_EC2_DefaultRole" {
  name = aws_iam_role.EMR_EC2_DefaultRole.name
  role = aws_iam_role.EMR_EC2_DefaultRole.name
}