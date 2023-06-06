resource "boundary_worker" "demo_worker" {
  name     = "demo-worker-1"
  scope_id = "global"
}

resource "boundary_scope" "demo_org" {
  scope_id               = "global"
  name                   = "demo-org"
  description            = "Organization for demoing Boundary"
  auto_create_admin_role = true
}

resource "boundary_scope" "demo_project" {
  scope_id               = boundary_scope.demo_org.id
  name                   = "demo-project"
  description            = "Project for Demoing Boundary"
  auto_create_admin_role = true
}

resource "boundary_credential_store_vault" "demo_cred_store" {
  name        = "demo-credential-store"
  description = "Credential store for demoing Boundary"
  scope_id    = boundary_scope.demo_project.id
  address     = local.vault_addr
  namespace   = vault_namespace.boundary_demo_namespace.path_fq
  token       = vault_token.boundary_controller_token.client_token
}

resource "boundary_credential_library_vault" "demo_cred_library_ssh" {
  name                = "demo-cred-library-ssh"
  credential_store_id = boundary_credential_store_vault.demo_cred_store.id
  credential_type     = "ssh_private_key"
  path                = vault_kv_secret_v2.ssh_credentials.path
  http_method         = "GET"
}

resource "boundary_credential_library_vault" "demo_cred_library_app_creds" {
  name                = "demo-cred-library-app-creds"
  credential_store_id = boundary_credential_store_vault.demo_cred_store.id
  credential_type     = "username_password"
  path                = vault_kv_secret_v2.app_credentials.path
  http_method         = "GET"
}

resource "boundary_host_catalog_static" "ssh_host_catalog" {
  name        = "ssh-host-catalog"
  description = "Host catalog for static SSH targets"
  scope_id    = boundary_scope.demo_project.id
}

resource "boundary_host_set_static" "ssh_machines" {
  name            = "ssh-machines"
  description     = "Static Host Set for SSH Machines"
  host_catalog_id = boundary_host_catalog_static.ssh_host_catalog.id
  host_ids = [
    boundary_host_static.ssh_host.id
  ]
}

resource "boundary_host_static" "ssh_host" {
  name            = "ssh-host"
  description     = "Containerized SSH Host for Boundary Demo"
  address         = "openssh-server"
  host_catalog_id = boundary_host_catalog_static.ssh_host_catalog.id
}

resource "boundary_target" "openssh_target" {
  name         = "openssh-target"
  description  = "Demo SSH Target"
  type         = "ssh"
  default_port = "2222"
  scope_id     = boundary_scope.demo_project.id
  host_source_ids = [
    boundary_host_set_static.ssh_machines.id
  ]
  brokered_credential_source_ids = [
    boundary_credential_library_vault.demo_cred_library_app_creds.id
  ]
  injected_application_credential_source_ids = [
    boundary_credential_library_vault.demo_cred_library_ssh.id
  ]
  egress_worker_filter = "\"dev\" in \"/tags/type\""
}