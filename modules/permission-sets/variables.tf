variable "dev_account" {
  type = string
}

variable "prod_account" {
  type = string
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "EMRStudio-Service-Role" {
  type = string
  default = "EMRStudio-Service-Role"
}

variable "EMRStudio-User-Role" {
  type = string
  default = "EMRStudio-User-Role"
}