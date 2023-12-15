
###cloud vars

variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

### Storage vars

variable "bucket_name" {
  type        = string
  default     = "fedors-bucket"
  description = "Name of bucket to use"
}

variable "web_bucket_name" {
  type        = string
  default     = "www.metsge.ru"
  description = "Name of web bucket to use"
}

variable "object_name" {
  type        = string
  default     = "index.html"
  description = "Name of index page"
}

variable "object_source" {
  type        = string
  default     = "index.html"
  description = "File name for index page"
}