variable "project_name" {
  type        = string
  description = "(Required) - This value will be used in comments and tags"
}
variable "domain" {
  type        = string
  description = "(Required) - The domain of the website (example.com), this value will be used to name the bucket and configure the cloudfront distribution"
}
variable "index_document" {
  type        = string
  description = "(Optional) - the index_document. By default index_document is setted to index.html"
  default     = "index.html"
}
variable "error_document" {
  type        = string
  description = "(Optional) - the index_document. By default error_document is setted to index.html"
  default     = "index.html"
}
variable "acm_certificate_arn" {
  type        = string
  description = "(Required) - The arn of the acm_certificate to be ised with the aws_cloudfront_distribution"
}
variable "cache_policy_id" {
  type        = string
  description = "(Optional) - aws_cloudfront_cache_policy id"
  default     = ""
}
variable "response_headers_policy_id" {
  type        = string
  description = "(Optional) - aws_cloudfront_response_headers_policy id"
  default     = ""
}
variable "custom_error_responses" {
  type = list(object({
    error_caching_min_ttl = number
    error_code            = number
    response_code         = number
    response_page_path    = string

  }))
  description = "(Optional) - List of custom_error_responses objects"
  default     = []
}
variable "waf_acl_id" {
  type        = string
  description = "(Oprional) - aws_wafv2_web_acl arn or aws_waf_web_acl id"
  default     = ""
}
