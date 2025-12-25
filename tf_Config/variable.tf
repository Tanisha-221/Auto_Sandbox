variable "prefix" {
  default     = "T_Sandbox"
  description = "The prefix value of the resources"
}

variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 1 #You can change to the number of vm you want to create 
}
variable "computerName" {
  type    = string
  default = "Sandbox1"
}

variable "adminUsername" {
  type = string
}

variable "adminpassword" {
  type      = string
  sensitive = true
}

variable "Storage_name" {
  type    = string
  default = "sandboxstorage12"
}

variable "service_url" {
    type = string
    default = "https://hooks.slack.com/services/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"
}