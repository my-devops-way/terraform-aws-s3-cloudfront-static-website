module "website" {
  source              = "my-devops-way/s3-cloudfront-static-website/aws"
  domain              = "example.com"
  acm_certificate_arn = aws_acm_certificate.example.arn
  custom_error_responses = [
    {
      error_caching_min_ttl = 1
      error_code            = 404
      response_code         = 200
      response_page_path    = "/"
    },
    {
      error_caching_min_ttl = 1
      error_code            = 403
      response_code         = 200
      response_page_path    = "/"

    }
  ]
}
