disable_mlock = true

hcp_boundary_cluster_id = "1258bf8f-b1b2-4e24-a109-60616f9dbc37"

listener "tcp" {
  address = "127.0.0.1:9202"
  purpose = "proxy"
}

worker {
  auth_storage_path = "/boundary/auth"
  controller_generated_activation_token = "neslat_2Krjqk14fstyLJ9ZMLv6rQpq4nMEMGuYPxTBNzXAPLPqZr5ySYyr82TwKJ54VFRZGNPsX9oc7HszkJ9cw32tbAqsuU5bm"
  tags {
    type = ["worker", "dev"]
  }
}