variable "billing_account" {
  description = ""
  type        = string

  validation {
    condition     = can(regex("^[[:alnum:]]{6}-[[:alnum:]]{6}-[[:alnum:]]{6}$", var.billing_account))
    error_message = "Invalid billing account, please provide a valid billing account in the following format \"XXXXX-XXXXX-XXXXX\"."
  }
}

variable "folder_name" {
  description = ""
  type        = string
  default     = null
}

variable "folder_parent" {
  description = ""
  type        = string

  validation {
    condition     = can(regex("^folders/\\d{12}$", var.folder_parent))
    error_message = "Invalid folder parent, please provide a valid folder parent in the following format \"folders/111111111111\"."
  }
}

variable "projects" {
  description = ""
  type        = any
  default     = null
}
