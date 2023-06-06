output "vault_addr" {
  value = hcp_vault_cluster.boundary_demo_vault.vault_public_endpoint_url
}

output "vault_token" {
  value = hcp_vault_cluster_admin_token.vault_admin_token.token
  sensitive = true
}

output "boundary_addr" {
  value = hcp_boundary_cluster.demo_cluster.cluster_url
}