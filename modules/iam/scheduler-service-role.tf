resource "aws_iam_role" "scheduler-service-role" {
  name = "scheduler-service-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "scheduler.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "scheduler"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "scheduler-policy" {
  name        = "scheduler-policy"
  description = "scheduler serivce role"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "SchedulerPermissions",
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "scheduler-policy" {
  role       = aws_iam_role.scheduler-service-role.name
  policy_arn = aws_iam_policy.scheduler-policy.arn
}