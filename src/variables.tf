
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
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "education"
  description = "VPC network&subnet name"
}

###common vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "your_ssh_ed25519_key"
  description = "ssh-keygen -t ed25519"
}

### Name for public VM
variable "vm_public_name" {
  type        = string
  default     = "public-vm"
  description = "Name for public VM"
}

### Name for private VM
variable "vm_private_name" {
  type        = string
  default     = "private-vm"
  description = "Name for private VM"
}



