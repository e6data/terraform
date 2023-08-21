resource "aws_s3_bucket" "my_protected_bucket" {
  bucket = var.bucket_name
  force_destroy = true

  tags = {
      Name = var.bucket_name
    }
}

resource "aws_s3_bucket_versioning" "my_protected_bucket_versioning" {
  bucket = aws_s3_bucket.my_protected_bucket.id
  versioning_configuration {
    status = "Enabled"
  }

  depends_on = [ aws_s3_bucket.my_protected_bucket ]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "my_protected_bucket_server_side_encryption" {
  bucket = aws_s3_bucket.my_protected_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
    }
    bucket_key_enabled = true
  }

  depends_on = [ aws_s3_bucket.my_protected_bucket ]
}

resource "aws_s3_bucket_public_access_block" "my_protected_bucket_access" {
  bucket = aws_s3_bucket.my_protected_bucket.id

  # Block public access
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true

  depends_on = [ aws_s3_bucket.my_protected_bucket ]
}

resource "aws_s3_bucket_logging" "my_protected_bucket_logging" {
  bucket = aws_s3_bucket.my_protected_bucket.id

  target_bucket = aws_s3_bucket.my_protected_bucket.id
  target_prefix = "bucket-logs/"

  depends_on = [ aws_s3_bucket.my_protected_bucket ]
}

# Resource to avoid error "AccessControlListNotSupported: The bucket does not allow ACLs"
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.my_protected_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }

  depends_on = [ aws_s3_bucket.my_protected_bucket ]
}


resource "aws_s3_bucket_acl" "my_protected_bucket_acl" {
  bucket = aws_s3_bucket.my_protected_bucket.id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

