resource "aws_iam_role" "lambda-service-role" {
  name = "lambda-service-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "lambda"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda-policy" {
  name        = "lambda-policy"
  description = "lambda serivce role"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "LambdaPermissions",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:*",
                "cloudwatch:*",
                "logs:*",
                "s3:*",
                "sqs:*",
                "rds:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda-policy" {
  role       = aws_iam_role.lambda-service-role.name
  policy_arn = aws_iam_policy.lambda-policy.arn
}