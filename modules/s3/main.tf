resource"aws_s3_bucket" "this" {

    bucket = var.bucket_name

    force_destroy = var.force_destroy

    tags = var.tags


}

resource "aws_s3_bucket_public_access_block" "this" {

    bucket = aws_s3_bucket.this.id

    block_public_acts = true
    block_public_policy = false
    ignore_public_acts = true
    restrict_public_buckets = false

}

resource "aws_s3_bucket_policy" "this" {

    bucket = aws_s3_bucket.this.id
    policy = var.aws_s3_bucket_policy
}