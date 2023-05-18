terraform {
  required_providers {
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
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.56.0"
    }
    boundary = {
      source  = "hashicorp/boundary"
      version = "1.1.7"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.15.2"
    }
  }
}

provider "vault" {
  address = hcp_vault_cluster.boundary_demo_vault.vault_public_endpoint_url
  token   = hcp_vault_cluster_admin_token.vault_admin_token.token
}

provider "hcp" {
  client_id     = var.hcp_client_id
  client_secret = var.hcp_client_secret
}