output "s3_bucket_id" {
  value       = aws_s3_bucket.this.id
  description = "The name of the bucket."
}
output "s3_bucket_arn" {
  value       = aws_s3_bucket.this.arn
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
}
output "s3_bucket_domain_name" {
  value       = aws_s3_bucket.this.bucket_domain_name
  description = "The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL."
}
output "s3_bucket_website_endpoint" {
  value       = aws_s3_bucket_website_configuration.this.website_endpoint
  description = "The website endpoint, if the bucket is configured with a website. If not, this will be an empty string."
}
output "s3_bucket_website_domain" {
  value       = aws_s3_bucket_website_configuration.this.website_domain
  description = "The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records."
}
output "cloudfront_distribution_id" {
  value       = aws_cloudfront_distribution.this.id
  description = "The identifier for the distribution. For example: EDFDVBD632BHDS5."
}
output "cloudfront_distribution_arn" {
  value       = aws_cloudfront_distribution.this.arn
  description = "The ARN (Amazon Resource Name) for the distribution. For example: arn:aws:cloudfront::123456789012:distribution/EDFDVBD632BHDS5, where 123456789012 is your AWS account ID."
}
output "cloudfront_distribution_domain_name" {
  value       = aws_cloudfront_distribution.this.domain_name
  description = "The domain name corresponding to the distribution. For example: d604721fxaaqy9.cloudfront.net."
}
output "cloudfront_distribution_hosted_zone_id" {
  value       = aws_cloudfront_distribution.this.hosted_zone_id
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. This attribute is simply an alias for the zone ID"
}
