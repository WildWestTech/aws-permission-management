resource "aws_iam_role" "emr-studio-user-role" {
  name = "emr-studio-user-role"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticmapreduce.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "emr-basic-user-policy" {
  role       = aws_iam_role.emr-studio-user-role.name
  policy_arn = aws_iam_policy.emr-basic-user-policy.arn
}

resource "aws_iam_role_policy_attachment" "emr-intermediate-user-policy" {
  role       = aws_iam_role.emr-studio-user-role.name
  policy_arn = aws_iam_policy.emr-intermediate-user-policy.arn
}

resource "aws_iam_role_policy_attachment" "emr-advanced-user-policy" {
  role       = aws_iam_role.emr-studio-user-role.name
  policy_arn = aws_iam_policy.emr-advanced-user-policy.arn
}