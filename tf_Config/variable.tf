variable "prefix" {
  description = "The prefix value of the resources"
}

variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
}
variable "computerName" {
  type    = string
  default = "Sandbox1"
}

variable "adminUsername" {
  type      = string
  sensitive = true
}

variable "adminpassword" {
  type      = string
  sensitive = true
}

variable "Storage_name" {
  type    = string
  default = "sandboxstorage12"
}

# variable "service_url" {
#     type = string
# }