terraform {
  required_providers {
    boundary = {
      source  = "hashicorp/boundary"
      version = "1.1.7"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.15.2"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../infra/terraform.tfstate"
  }
}

locals {
  boundary_addr = data.terraform_remote_state.vpc.outputs.boundary_addr
  vault_addr    = data.terraform_remote_state.vpc.outputs.vault_addr
  vault_token   = data.terraform_remote_state.vpc.outputs.vault_token
}

provider "boundary" {
  addr                            = local.boundary_addr
  password_auth_method_login_name = var.boundary_username
  password_auth_method_password   = var.boundary_password
}

provider "vault" {
  address = data.terraform_remote_state.vpc.outputs.vault_addr
  token   = local.vault_token
}