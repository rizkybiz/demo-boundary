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

resource "vault_namespace" "boundary_demo_namespace" {
  namespace = "admin"
  path      = "boundary-demo"
}

resource "vault_policy" "boundary_controller_policy" {
  namespace = vault_namespace.boundary_demo_namespace.path_fq
  name      = "boundary-controller-policy"
  policy    = file("${abspath(path.root)}/vault_config/boundary-controller-policy.hcl")
}

resource "vault_policy" "kv_policy" {
  namespace = vault_namespace.boundary_demo_namespace.path_fq
  name      = "kv-policy"
  policy    = file("${abspath(path.root)}/vault_config/kv-policy.hcl")
}

resource "vault_mount" "boundary_kvv2" {
  namespace = vault_namespace.boundary_demo_namespace.path_fq
  path      = "ssh-creds"
  type      = "kv"
  options = {
    version = "2"
  }
  description = "KV v2 secret engine mount for Boundary Demo"
}

resource "vault_kv_secret_v2" "ssh_credentials" {
  namespace = vault_namespace.boundary_demo_namespace.path_fq
  mount     = "/ssh-creds"
  name      = "openssh-server-creds"
  data_json = jsonencode({
    username    = "admin"
    private_key = file("${abspath(path.root)}/ssh_keys/openssh-key")
  })
}

resource "vault_kv_secret_v2" "app_credentials" {
  namespace = vault_namespace.boundary_demo_namespace.path_fq
  mount     = "/ssh-creds"
  name      = "app-credentials"
  data_json = jsonencode({
    username = "secret-app-username"
    password = "secret-app-password"
  })
}

resource "vault_token_auth_backend_role" "boundary_token_auth_role" {
  namespace        = vault_namespace.boundary_demo_namespace.path_fq
  role_name        = "boundary-token-auth-role"
  allowed_policies = ["boundary-controller-policy", "kv-policy"]
  orphan           = true
  renewable        = true
  token_period     = 1200
}

resource "vault_token" "boundary_controller_token" {
  namespace         = vault_namespace.boundary_demo_namespace.path_fq
  role_name         = vault_token_auth_backend_role.boundary_token_auth_role.role_name
  policies          = ["boundary-controller-policy", "kv-policy"]
  no_default_policy = true
  renewable         = true
  no_parent         = true
  period            = "20m"
}