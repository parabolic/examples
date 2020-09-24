variable "billing_account" {
  description = ""
  type        = string
}

variable "folder_name" {
  description = ""
  type        = string
  default     = null
}

variable "folder_parent" {
  description = ""
  type        = string
}

variable "projects" {
  description = ""
  type        = any
  default     = null
}
