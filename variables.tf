variable "boundary_username" {
  type = string
}

variable "boundary_password" {
  type      = string
  sensitive = true
}

variable "hcp_client_id" {
  type = string
}

variable "hcp_client_secret" {
  type = string
}