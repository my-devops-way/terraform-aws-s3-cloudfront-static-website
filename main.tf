# ############################### 
# Get Managed Cloudfront policies
# ###############################

data "aws_cloudfront_cache_policy" "this" {
  name = "Managed-CachingOptimized"
}
data "aws_cloudfront_origin_request_policy" "this" {
  name = "Managed-CORS-S3Origin"
}
data "aws_cloudfront_response_headers_policy" "this" {
  name = "Managed-SimpleCORS"
}

# ###################
# S3 bucket resources
# ###################

#tfsec:ignore:aws-s3-enable-bucket-logging
#tfsec:ignore:aws-s3-enable-bucket-encryption
#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket" "this" {
  bucket        = var.domain
  force_destroy = true
}
resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }

}
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": {
              "AWS": "${aws_cloudfront_origin_access_identity.this.iam_arn}"
            },
            "Action": [
                "s3:GetObject"
            ],
            "Resource": "arn:aws:s3:::${var.domain}/*"
            
        }
    ]
}
POLICY
}


# #################################
# Cloudfront Distribution Resources
# #################################

resource "aws_cloudfront_origin_access_identity" "this" {
  comment = var.domain
}
#tfsec:ignore:aws-cloudfront-enable-logging
resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id   = "s3-${aws_s3_bucket.this.bucket}"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }
  enabled         = true
  is_ipv6_enabled = false
  comment         = "${aws_s3_bucket.this.bucket} distribution"

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = "s3-${aws_s3_bucket.this.bucket}"

    compress                   = true
    cache_policy_id            = (var.cache_policy_id != "") ? var.cache_policy_id : data.aws_cloudfront_cache_policy.this.id
    origin_request_policy_id   = data.aws_cloudfront_origin_request_policy.this.id
    response_headers_policy_id = (var.response_headers_policy_id != "") ? var.response_headers_policy_id : data.aws_cloudfront_response_headers_policy.this.id

  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_root_object = var.index_document
  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
  aliases = [var.domain]
  dynamic "custom_error_response" {
    for_each = var.custom_error_responses
    content {
      error_caching_min_ttl = custom_error_response.value["error_caching_min_ttl"]
      error_code            = custom_error_response.value["error_code"]
      response_code         = custom_error_response.value["response_code"]
      response_page_path    = custom_error_response.value["response_page_path"]
    }
  }
  web_acl_id = (var.waf_acl_id == "") ? null : var.waf_acl_id
}
