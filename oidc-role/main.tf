#
###################################
##                                #
## OIDC for Github Actions        #
##                                #
###################################

#thumbprint obtained from https://github.blog/changelog/2022-01-13-github-actions-update-on-oidc-based-deployments-to-aws/
locals {
  thumbprint = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = local.thumbprint
}

resource "aws_iam_role" "oidc_assume_role" {
  name = "github_actions_assume_role"
  assume_role_policy = data.aws_iam_policy_document.oidc_authenticate_policy.json
}

data "aws_iam_policy_document" "oidc_authenticate_policy" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      identifiers = [aws_iam_openid_connect_provider.oidc_provider.arn]
      type        = "Federated"
    }
    condition {
      test     = "StringEquals"
      values   = ["sts.amazonaws.com"]
      variable = "token.actions.githubusercontent.com:aud"
    }
    condition {
      test     = "StringLike"
      values   = var.repository_list
      variable = "token.actions.githubusercontent.com:sub"
    }
  }
}

resource "aws_iam_policy" "s3_write" {
  name_prefix = "${var.name_prefix}-oidc-role-s3-write"
  description = "Policy that grants write access to a list of S3 buckets."
  policy      = data.aws_iam_policy_document.s3_write_for_oidc_role.json
}

resource "aws_iam_policy" "s3_read" {
  name_prefix = "${var.name_prefix}-oidc-role-s3-read"
  description = "Policy that grants read access to a list of S3 buckets."
  policy      = data.aws_iam_policy_document.s3_read_for_oidc_role.json
}


resource "aws_iam_policy" "ecr" {
  name_prefix = "${var.name_prefix}-oidc-role-ecr"
  description = "Policy that grants read and write access to a list of ECR repositories."
  policy      = data.aws_iam_policy_document.ecr_for_oidc_role.json
}

resource "aws_iam_role_policy_attachment" "s3_write_to_oidc_role" {
  role = aws_iam_role.oidc_assume_role.id
  policy_arn = aws_iam_policy.s3_write.arn
  depends_on = [aws_iam_policy.s3_write]
}

resource "aws_iam_role_policy_attachment" "s3_read_to_oidc_role" {
  role = aws_iam_role.oidc_assume_role.id
  policy_arn = aws_iam_policy.s3_read.arn
  depends_on = [aws_iam_policy.s3_read]
}

resource "aws_iam_role_policy_attachment" "ecr_to_role" {
  role = aws_iam_role.oidc_assume_role.id
  policy_arn = aws_iam_policy.ecr.arn
  depends_on = [aws_iam_policy.ecr]
}
