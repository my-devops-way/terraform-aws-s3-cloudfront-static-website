# VARIABLES
locals {
  domain      = "example.mydevopsway.com"
  hosted_zone = "mydevopsway.com"
}
# R53
data "aws_route53_zone" "this" {
  name = local.hosted_zone
}
# Cration and validation of ACM certificate (for https)
resource "aws_acm_certificate" "this" {
  domain_name       = local.domain
  validation_method = "DNS"
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = (aws_acm_certificate.this.domain_validation_options[*].resource_record_name)[0]
  type    = "CNAME"
  ttl     = 300
  records = aws_acm_certificate.this.domain_validation_options[*].resource_record_value
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [aws_route53_record.this.fqdn]
}

# MODULE
# cloufront and s3

module "website" {
  source              = "my-devops-way/s3-cloudfront-static-website/aws"
  domain              = "mydevopsway.com"
  acm_certificate_arn = aws_acm_certificate.this.arn
}

# R53
# DNS record for cloufront distribution

# for main domain "example.com"

# resource "aws_route53_record" "main_domain" {
#   zone_id = data.aws_route53_zone.this.zone_id
#   name    = local.domain
#   type    = "A"
# 
#   alias {
#     name                   = module.website.cloudfront_distribution_domain_name
#     zone_id                = module.website.cloudfront_distribution_hosted_zone_id
#     evaluate_target_health = false
#   }
# }

# for sub domain "subdomain.example.com"

resource "aws_route53_record" "sub_domain" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = local.domain
  type    = "CNAME"
  ttl     = "300"
  records = [module.website.cloudfront_distribution_domain_name]

}
