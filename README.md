# AWS S3-CloudFront Terraform Module (static website infra)
This module creates S3-Terraform configuration to deploy a basic static website in AWS.
![aws_s3_cloudfront](/../../../../my-devops-way/CICD/blob/main/svg/front/aws-s3-cloudfront.svg)

## Usage

### Basic configuration

```hcl

module "website" {
  source                     = "./modules/s3_with_cloudfront"
  project_name               = "example"
  domain                     = "example.com"
  acm_certificate_arn        = aws_acm_certificate.example.arn
}

```

### Setting custom index_document and error_document

```hcl

module "website" {
  source                     = "./modules/s3_with_cloudfront"
  project_name               = "example"
  domain                     = "example.com"
  error_document             = "index.html"
  index_document             = "error.html"
  acm_certificate_arn        = aws_acm_certificate.example.arn
}

```

### WAF integration
```hcl
module "website" {
  source                     = "./modules/s3_with_cloudfront"
  project_name               = "example"
  domain                     = "example.com"
  acm_certificate_arn        = aws_acm_certificate.website_certificate.arn
  waf_acl_id                 = aws_wafv2_web_acl.example.arn

}

```

### Custom error responses

```hcl

module "website" {
  source                     = "./modules/s3_with_cloudfront"
  project_name               = "example"
  domain                     = "example.com"
  acm_certificate_arn        = aws_acm_certificate.example.arn
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
### Cloudfront cache_policy and response_headers_policy Integrations

```hcl

module "website" {
  source                     = "./modules/s3_with_cloudfront"
  project_name               = "example"
  domain                     = "example.com"
  error_document             = "index.html"
  index_document             = "error.html"
  acm_certificate_arn        = aws_acm_certificate.example.arn
  cache_policy_id            = aws_cloudfront_cache_policy.example.id
  response_headers_policy_id = aws_cloudfront_response_headers_policy.example.id
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.14.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.14.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_website_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_cloudfront_cache_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_cache_policy) | data source |
| [aws_cloudfront_origin_request_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_origin_request_policy) | data source |
| [aws_cloudfront_response_headers_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_response_headers_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | (Required) - The arn of the acm\_certificate to be ised with the aws\_cloudfront\_distribution | `string` | n/a | yes |
| <a name="input_cache_policy_id"></a> [cache\_policy\_id](#input\_cache\_policy\_id) | (Optional) - aws\_cloudfront\_cache\_policy id | `string` | `""` | no |
| <a name="input_custom_error_responses"></a> [custom\_error\_responses](#input\_custom\_error\_responses) | (Optional) - List of custom\_error\_responses objects | <pre>list(object({<br>    error_caching_min_ttl = number<br>    error_code            = number<br>    response_code         = number<br>    response_page_path    = string<br><br>  }))</pre> | `[]` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | (Required) - The domain of the website (example.com), this value will be used to name the bucket and configure the cloudfront distribution | `string` | n/a | yes |
| <a name="input_error_document"></a> [error\_document](#input\_error\_document) | (Optional) - the index\_document. By default error\_document is setted to index.html | `string` | `"index.html"` | no |
| <a name="input_index_document"></a> [index\_document](#input\_index\_document) | (Optional) - the index\_document. By default index\_document is setted to index.html | `string` | `"index.html"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | (Required) - This value will be used in comments and tags | `string` | n/a | yes |
| <a name="input_response_headers_policy_id"></a> [response\_headers\_policy\_id](#input\_response\_headers\_policy\_id) | (Optional) - aws\_cloudfront\_response\_headers\_policy id | `string` | `""` | no |
| <a name="input_waf_acl_id"></a> [waf\_acl\_id](#input\_waf\_acl\_id) | (Oprional) - aws\_wafv2\_web\_acl arn or aws\_waf\_web\_acl id | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_distribution_arn"></a> [cloudfront\_distribution\_arn](#output\_cloudfront\_distribution\_arn) | The ARN (Amazon Resource Name) for the distribution. For example: arn:aws:cloudfront::123456789012:distribution/EDFDVBD632BHDS5, where 123456789012 is your AWS account ID. |
| <a name="output_cloudfront_distribution_domain_name"></a> [cloudfront\_distribution\_domain\_name](#output\_cloudfront\_distribution\_domain\_name) | The domain name corresponding to the distribution. For example: d604721fxaaqy9.cloudfront.net. |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | The identifier for the distribution. For example: EDFDVBD632BHDS5. |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | The ARN of the bucket. Will be of format arn:aws:s3:::bucketname. |
| <a name="output_s3_bucket_domain_name"></a> [s3\_bucket\_domain\_name](#output\_s3\_bucket\_domain\_name) | The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL. |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | The name of the bucket. |
| <a name="output_s3_bucket_website_domain"></a> [s3\_bucket\_website\_domain](#output\_s3\_bucket\_website\_domain) | The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records. |
| <a name="output_s3_bucket_website_endpoint"></a> [s3\_bucket\_website\_endpoint](#output\_s3\_bucket\_website\_endpoint) | The website endpoint, if the bucket is configured with a website. If not, this will be an empty string. |
<!-- END_TF_DOCS -->
