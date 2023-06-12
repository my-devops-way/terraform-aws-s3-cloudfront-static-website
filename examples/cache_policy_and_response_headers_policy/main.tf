module "website" {
  source                     = "my-devops-way/s3-cloudfront-static-website/aws"
  domain                     = "example.com"
  error_document             = "index.html"
  index_document             = "error.html"
  acm_certificate_arn        = aws_acm_certificate.example.arn
  cache_policy_id            = aws_cloudfront_cache_policy.example.id
  response_headers_policy_id = aws_cloudfront_response_headers_policy.example.id
}
