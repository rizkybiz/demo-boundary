locals {
  boundary_cluster_id = trimsuffix(trimprefix(local.boundary_addr, "https://"), ".boundary.hashicorp.cloud")
}

resource "local_file" "boundary_worker_config" {
  content = templatefile("${abspath(path.root)}/boundary_config/boundary_config.tftpl", {
    hcp_boundary_cluster_id     = "${local.boundary_cluster_id}"
    controller_activation_token = "${boundary_worker.demo_worker.controller_generated_activation_token}"
  })
  filename = "${abspath(path.root)}/boundary_config/config.hcl"
}

resource "docker_network" "boundary_docker_network" {
  name = "boundary-docker-network"
}

resource "docker_container" "ssh_target" {
  name     = "openssh-server"
  image    = "lscr.io/linuxserver/openssh-server:latest"
  hostname = "openssh-server"
  env = [
    "SUDO_ACCESS=false",
    "USER_NAME=admin",
    "PUBLIC_KEY_FILE=/keys/openssh-key.pub"
  ]
  restart = "unless-stopped"
  ports {
    internal = "2222"
    external = "2222"
  }
  volumes {
    container_path = "/keys/openssh-key.pub"
    host_path      = "${abspath(path.root)}/ssh_keys/openssh-key.pub"
  }
  networks_advanced {
    name = "boundary-docker-network"
  }
}

resource "docker_container" "boundary_worker" {
  depends_on = [local_file.boundary_worker_config]
  name       = "boundary-worker"
  image      = "hashicorp/boundary-worker-hcp:latest"
  hostname   = "boundary-worker"
  restart    = "unless-stopped"
  ports {
    internal = "9202"
    external = "9202"
  }
  volumes {
    container_path = "/boundary/config.hcl"
    host_path      = "${abspath(path.root)}/boundary_config/config.hcl"
  }
  networks_advanced {
    name = "boundary-docker-network"
  }
  command = ["boundary-worker", "server", "-config", "/boundary/config.hcl"]
}