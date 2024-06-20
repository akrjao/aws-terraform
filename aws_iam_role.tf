resource "aws_iam_role" "aws_iam_role" {
  for_each = var.aws_region.default ? {default : true} : {}
  name               = random_string.aws_iam_role[each.key].result
  assume_role_policy = data.aws_iam_policy_document.assume_role[each.key].json
}