data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ecr_read_write" {
  statement {
    sid    = "AllowPushPull"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DeleteRepositoryPolicy"
    ]

    resources = [
      "arn:aws:ecr:${var.policy_config.region}:${data.aws_caller_identity.current.account_id}:repository/${var.policy_config.repository_name}"
    ]
  }
}

output "json" {
  description = "IAM policy document JSON"
  value       = data.aws_iam_policy_document.ecr_read_write.json
}

