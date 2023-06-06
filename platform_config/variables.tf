variable "boundary_username" {
  type = string
}

variable "boundary_password" {
  type      = string
  sensitive = true
}