terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.56.0"
    }
  }
}

locals {
  boundary_cluster_name = "my-demo-cluster"
}

provider "hcp" {
  client_id     = var.hcp_client_id
  client_secret = var.hcp_client_secret
}

resource "hcp_hvn" "boundary_demo_hvn" {
  hvn_id         = "boundary-demo-hvn"
  cloud_provider = "aws"
  region         = "us-east-1"
  cidr_block     = "172.16.0.0/20"
}

resource "hcp_vault_cluster" "boundary_demo_vault" {
  cluster_id      = "boundary-demo-vault"
  hvn_id          = hcp_hvn.boundary_demo_hvn.hvn_id
  tier            = "dev"
  public_endpoint = true
}

resource "hcp_vault_cluster_admin_token" "vault_admin_token" {
  cluster_id = hcp_vault_cluster.boundary_demo_vault.cluster_id
}

resource "hcp_boundary_cluster" "demo_cluster" {
  cluster_id = local.boundary_cluster_name
  username   = var.boundary_username
  password   = var.boundary_password
}