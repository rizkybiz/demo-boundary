resource "tls_private_key" "ecdsa_private_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

resource "local_file" "ssh_public_key" {
  content  = trimspace(tls_private_key.ecdsa_private_key.public_key_openssh)
  filename = "${abspath(path.root)}/ssh_keys/openssh-key.pub"
}

resource "local_file" "ssh_private_key" {
  content         = trimspace(tls_private_key.ecdsa_private_key.private_key_openssh)
  filename        = "${abspath(path.root)}/ssh_keys/openssh-key"
  file_permission = "0600"
}