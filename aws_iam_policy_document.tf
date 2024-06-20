data "aws_iam_policy_document" "assume_role" {
  for_each = var.aws_region.default ? {default : true} : {}
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "bucket_access" {
  for_each = var.aws_region.default ? {default : true} : {}
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.aws_s3_bucket.arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "bucket_replication" {
  for_each = var.aws_region.default ? {default : true} : {}
  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:GetReplicationConfiguration",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectRetention",
      "s3:GetObjectLegalHold"
    ]

    resources = [aws_s3_bucket.aws_s3_bucket.arn,
				"${aws_s3_bucket.aws_s3_bucket.arn}/*"]
  }

  dynamic "statement" {
    for_each = tolist(local.aws_s3_bucket_arn_file_filtered)
    content {
      effect = "Allow"

      actions = [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags",
        "s3:ObjectOwnerOverrideToBucketOwner"
      ]

      resources = ["${statement.value}/*"]
    }
  }
}