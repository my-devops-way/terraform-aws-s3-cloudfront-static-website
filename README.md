<!-- BEGIN_TF_DOCS -->

# AWS S3-CloudFront Terraform Module (static website infra)
This module creates S3-Terraform configuration to deploy a basic static website in AWS.
![aws\_s3\_cloudfront](https://github.com/my-devops-way/CICD/blob/main/svg/front/aws-s3-cloudfront.svg?raw=true)
## Examples
<details>

**<summary> Basic configuration </summary>**

```hcl
module "website" {
  source              = "my-devops-way/s3-cloudfront-static-website/aws"
  domain              = "example.com"
  acm_certificate_arn = aws_acm_certificate.example.arn
}
```
</details>
<details>

**<summary> Setting custom index_document and error_document </summary>**

```hcl
module "website" {
  source              = "my-devops-way/s3-cloudfront-static-website/aws"
  domain              = "example.com"
  error_document      = "index.html"
  index_document      = "error.html"
  acm_certificate_arn = aws_acm_certificate.example.arn
}
```
</details>
<details>

**<summary> WAF integration </summary>**

```hcl
module "website" {
  source              = "my-devops-way/s3-cloudfront-static-website/aws"
  domain              = "example.com"
  acm_certificate_arn = aws_acm_certificate.website_certificate.arn
  waf_acl_id          = aws_wafv2_web_acl.example.arn
}
```
</details>
<details>

**<summary> Custom error responses </summary>**

```hcl
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
```
</details>
<details>

**<summary> Cloudfront cache_policy and response_headers_policy </summary>**

```hcl
module "website" {
  source                     = "my-devops-way/s3-cloudfront-static-website/aws"
  domain                     = "example.com"
  error_document             = "index.html"
  index_document             = "error.html"
  acm_certificate_arn        = aws_acm_certificate.example.arn
  cache_policy_id            = aws_cloudfront_cache_policy.example.id
  response_headers_policy_id = aws_cloudfront_response_headers_policy.example.id
}
```
</details>
<details>

**<summary> Full example with ACM certificate and R53 record </summary>**

```hcl
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
```
</details>

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.14.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.14.0 |
## Modules

No modules.
## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_website_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_cloudfront_cache_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_cache_policy) | data source |
| [aws_cloudfront_origin_request_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_origin_request_policy) | data source |
| [aws_cloudfront_response_headers_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_response_headers_policy) | data source |
## Inputs

| Name | Description | Type |
|------|-------------|------|
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | (Required) - The arn of the acm\_certificate to be ised with the aws\_cloudfront\_distribution | `string` |
| <a name="input_cache_policy_id"></a> [cache\_policy\_id](#input\_cache\_policy\_id) | (Optional) - aws\_cloudfront\_cache\_policy id | `string` |
| <a name="input_custom_error_responses"></a> [custom\_error\_responses](#input\_custom\_error\_responses) | (Optional) - List of custom\_error\_responses objects | <pre>list(object({<br>    error_caching_min_ttl = number<br>    error_code            = number<br>    response_code         = number<br>    response_page_path    = string<br><br>  }))</pre> |
| <a name="input_domain"></a> [domain](#input\_domain) | (Required) - The domain of the website (example.com), this value will be used to name the bucket and configure the cloudfront distribution | `string` |
| <a name="input_error_document"></a> [error\_document](#input\_error\_document) | (Optional) - the index\_document. By default error\_document is setted to index.html | `string` |
| <a name="input_index_document"></a> [index\_document](#input\_index\_document) | (Optional) - the index\_document. By default index\_document is setted to index.html | `string` |
| <a name="input_response_headers_policy_id"></a> [response\_headers\_policy\_id](#input\_response\_headers\_policy\_id) | (Optional) - aws\_cloudfront\_response\_headers\_policy id | `string` |
| <a name="input_waf_acl_id"></a> [waf\_acl\_id](#input\_waf\_acl\_id) | (Oprional) - aws\_wafv2\_web\_acl arn or aws\_waf\_web\_acl id | `string` |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_distribution_arn"></a> [cloudfront\_distribution\_arn](#output\_cloudfront\_distribution\_arn) | The ARN (Amazon Resource Name) for the distribution. For example: arn:aws:cloudfront::123456789012:distribution/EDFDVBD632BHDS5, where 123456789012 is your AWS account ID. |
| <a name="output_cloudfront_distribution_domain_name"></a> [cloudfront\_distribution\_domain\_name](#output\_cloudfront\_distribution\_domain\_name) | The domain name corresponding to the distribution. For example: d604721fxaaqy9.cloudfront.net. |
| <a name="output_cloudfront_distribution_hosted_zone_id"></a> [cloudfront\_distribution\_hosted\_zone\_id](#output\_cloudfront\_distribution\_hosted\_zone\_id) | The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. This attribute is simply an alias for the zone ID |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | The identifier for the distribution. For example: EDFDVBD632BHDS5. |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | The ARN of the bucket. Will be of format arn:aws:s3:::bucketname. |
| <a name="output_s3_bucket_domain_name"></a> [s3\_bucket\_domain\_name](#output\_s3\_bucket\_domain\_name) | The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL. |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | The name of the bucket. |
| <a name="output_s3_bucket_website_domain"></a> [s3\_bucket\_website\_domain](#output\_s3\_bucket\_website\_domain) | The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records. |
| <a name="output_s3_bucket_website_endpoint"></a> [s3\_bucket\_website\_endpoint](#output\_s3\_bucket\_website\_endpoint) | The website endpoint, if the bucket is configured with a website. If not, this will be an empty string. |

<!-- END_TF_DOCS -->
