# data "aws_caller_identity" "current" {}

# data "aws_iam_policy_document" "ecr_read_write" {
#   statement {
#     sid    = "AllowPushPull"
#     effect = "Allow"

#     actions = [
#       "ecr:GetAuthorizationToken",
#       "ecr:BatchCheckLayerAvailability",
#       "ecr:GetDownloadUrlForLayer",
#       "ecr:BatchGetImage",
#       "ecr:PutImage",
#       "ecr:InitiateLayerUpload",
#       "ecr:UploadLayerPart",
#       "ecr:CompleteLayerUpload",
#       "ecr:DeleteRepositoryPolicy"
#     ]

#     resources = ["arn:aws:ecr:${var.general_config.region}:${data.aws_caller_identity.current.account_id}:repository/${var.ecr.repository_name}"]
#   }
# }
