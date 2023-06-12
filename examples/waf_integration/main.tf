module "website" {
  source              = "my-devops-way/s3-cloudfront-static-website/aws"
  domain              = "example.com"
  acm_certificate_arn = aws_acm_certificate.website_certificate.arn
  waf_acl_id          = aws_wafv2_web_acl.example.arn
}
