resource "aws_iam_policy" "aws_iam_policy" {
  for_each = var.aws_region.default ? {default : true} : {}
  name   = random_string.aws_iam_policy[each.key].result
  policy = data.aws_iam_policy_document.bucket_replication[each.key].json
}