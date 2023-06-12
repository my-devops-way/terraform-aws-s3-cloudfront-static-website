module "website" {
  source              = "my-devops-way/s3-cloudfront-static-website/aws"
  domain              = "example.com"
  error_document      = "index.html"
  index_document      = "error.html"
  acm_certificate_arn = aws_acm_certificate.example.arn
}
