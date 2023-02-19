# https://github.com/dacort/demo-code/blob/main/emr/studio/cloudformation/full_studio_dependencies.cfn.yaml
# Note: Keep an eye on the passroles: EMR_DefaultRole & EMR_EC2_DefaultRole in case we change those

resource "aws_iam_role" "cluster-template-launch-role" {
  name = "cluster-template-launch-role"
  description = "launch constraint role for emr and more"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "servicecatalog.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "servicecatalog"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "cluster-template-launch-policy" {
  name        = "cluster-template-launch-policy"
  description = "launch constraint policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ServiceCatalogPermissions",
            "Effect": "Allow",
            "Action": [
                "cloudformation:*",
                "servicecatalog:*",
                "s3:GetObject",
                "elasticmapreduce:RunJobFlow",
                "elasticmapreduce:DescribeCluster",
                "elasticmapreduce:TerminateJobFlows"
            ],
            "Resource": "*"
        },
        {
            "Sid": "PassRole",
            "Effect": "Allow",
            "Action": "iam:passRole",
            "Resource": [
                "arn:aws:iam::${var.account}:role/EMR_DefaultRole",
                "arn:aws:iam::${var.account}:role/EMR_EC2_DefaultRole"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cluster-template-launch-policy" {
  role       = aws_iam_role.cluster-template-launch-role.name
  policy_arn = aws_iam_policy.cluster-template-launch-policy.arn
}

