data "aws_iam_policy_document" "example" {
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["*"]
  }
}

resource "aws_organizations_policy" "example" {
  name    = var.policy_name
  content = data.aws_iam_policy_document.example.json
}