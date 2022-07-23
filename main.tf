resource "random_id" "id" {
  byte_length = 8
}

resource "hsdp_container_host" "nifi" {
  name          = "nifi-${random_id.id.hex}.dev"
  iops          = var.iops
  volumes       = 1
  volume_size   = var.volume_size
  instance_type = var.instance_type

  user_groups     = var.user_groups
  security_groups = ["analytics"]

  lifecycle {
    ignore_changes = [
      volumes,
      volume_size,
      instance_type,
      iops
    ]
  }
}

resource "ssh_resource" "instance" {

  triggers = {
    instance_ids = hsdp_container_host.nifi.id
    bash         = file("${path.module}/scripts/bootstrap-nifi.sh.tmpl")
  }

  bastion_host = var.bastion_host
  host         = hsdp_container_host.nifi.private_ip
  user         = var.user
  private_key  = var.private_key

  file {
    content = templatefile("${path.module}/scripts/bootstrap-nifi.sh.tmpl", {
      docker_username = var.docker_username
      docker_password = var.docker_password
      docker_image    = var.docker_image
      docker_registry = var.docker_registry
      nifi_jvm_xms    = var.nifi_jvm_xms
      nifi_jvm_xmx    = var.nifi_jvm_xmx
      private_ip      = hsdp_container_host.nifi.private_ip
    })
    destination = "/home/${var.user}/bootstrap-nifi.sh"
    permissions = "0700"
  }


  # Bootstrap script called with private_ip of each node in the cluster
  commands = [
    "/home/${var.user}/bootstrap-nifi.sh"
  ]
}
