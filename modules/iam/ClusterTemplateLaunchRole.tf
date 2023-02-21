#============================================================================================================
# Policy Attachment: Attach ClusterTemplateLaunchConstraintPolicy
#============================================================================================================
resource "aws_iam_role" "ClusterTemplateLaunchRole" {
  #This creates an IAM Role called 'Cluster_Template_Launch_Role'
  name = "ClusterTemplateLaunchRole"
  #Initiate this role by allowing the service catalog to assume the role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Sid = ""
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "servicecatalog.amazonaws.com"
            }
        }
    ]
  })
}

#============================================================================================================
# Policy Attachment: Attach ClusterTemplateLaunchConstraintPolicy
#============================================================================================================

resource "aws_iam_role_policy_attachment" "ClusterTemplateLaunchConstraintPolicy" {
  role       = aws_iam_role.ClusterTemplateLaunchRole.name
  policy_arn = aws_iam_policy.ClusterTemplateLaunchConstraintPolicy.arn
}

#============================================================================================================
# Policy: ClusterTemplateLaunchConstraintPolicy
#============================================================================================================
    

resource "aws_iam_policy" "ClusterTemplateLaunchConstraintPolicy" {
  name        = "ClusterTemplateLaunchConstraintPolicy"
  description = "ClusterTemplateLaunchConstraintPolicy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "cloudformation:CreateStack",
                "cloudformation:DeleteStack",
                "cloudformation:DescribeStackEvents",
                "cloudformation:DescribeStacks",
                "cloudformation:GetTemplateSummary",
                "cloudformation:SetStackPolicy",
                "cloudformation:ValidateTemplate",
                "cloudformation:UpdateStack",
                "elasticmapreduce:RunJobFlow",
                "elasticmapreduce:DescribeCluster",
                "elasticmapreduce:TerminateJobFlows",
                "servicecatalog:*",
                "s3:GetObject"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "iam:passRole"
            ],
            "Resource": [
                "arn:aws:iam::779149424254:role/EMR_DefaultRole",
                "arn:aws:iam::779149424254:role/EMR_EC2_DefaultRole"
            ],
            "Effect": "Allow"
        }
    ]
}

  EOF
}