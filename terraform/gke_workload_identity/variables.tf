variable "folder_id" {
  type    = string
  default = ""
}

variable "billing_account" {
  type = string
}

variable "k8s_namespace" {
  type    = string
  default = "cloudlad"
}

variable "k8s_service_account" {
  type    = string
  default = "cloudlad"
}

variable "k8s_script_path" {
  type    = string
  default = null
}
