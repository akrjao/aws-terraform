resource "aws_iam_role_policy_attachment" "aws_iam_role_policy_attachment" {
  for_each = var.aws_region.default ? {default : true} : {}
  role       = aws_iam_role.aws_iam_role[each.key].name
  policy_arn = aws_iam_policy.aws_iam_policy[each.key].arn
}