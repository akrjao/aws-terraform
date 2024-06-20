resource "aws_s3_bucket_replication_configuration" "aws_s3_bucket_replication_configuration" {
  for_each = var.aws_region.default ? {default : true} : {}
  role   = aws_iam_role.aws_iam_role[each.key].arn
  bucket = aws_s3_bucket.aws_s3_bucket.id
  depends_on = [aws_s3_bucket_versioning.aws_s3_bucket_versioning]
  
  dynamic "rule" {
    for_each = local.aws_s3_bucket_arn_file_filtered != [] ? tolist(local.aws_s3_bucket_arn_file_filtered) : tolist([""])
    content {
        id = trimspace(rule.value)
        status = "Enabled"
        priority = rule.key

        filter {}
        
        destination {
          bucket        = rule.value
        }

        delete_marker_replication {
          status = "Enabled"
        }
        
        source_selection_criteria {
          replica_modifications {
            status = "Enabled"
          }
        }
    }
  }
}