
variable data {
  type    = list(map(string))
  default = [{
    name: "education_subnet",
    zone: "ru-central1-a",
    cidr: "10.0.1.0/24"
  }]
  description = "Subnet parameters"
}

variable "route_table" {
  type        = string
  default     = null
  description = "Route table ID"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}
