resource "aws_iam_role" "windows-server-role" {
  name = "windows-server-role"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/PowerUserAccess"
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


resource "aws_iam_instance_profile" "windows-server-role" {
  name = aws_iam_role.windows-server-role.name
  role = aws_iam_role.windows-server-role.name
}