resource "random_id" "id" {
  byte_length = 8
}

resource "hsdp_container_host" "nifi" {
  name          = var.host_name == "" ? "nifi-${random_id.id.hex}.dev" : "nifi-${var.host_name}.dev"
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

resource "hsdp_container_host_exec" "instance" {

  triggers = {
    instance_ids   =  hsdp_container_host.nifi.id
    bash           = file("${path.module}/scripts/bootstrap-nifi.sh")
  }

  bastion_host = var.bastion_host
  host         = hsdp_container_host.nifi.private_ip
  user         = var.user
  private_key  = var.private_key

  file {
    source      = "${path.module}/scripts/bootstrap-nifi.sh"
    destination = "/home/${var.user}/bootstrap-nifi.sh"
  }


  # Bootstrap script called with private_ip of each node in the cluster
  commands = [
    "chmod +x /home/${var.user}/bootstrap-nifi.sh",
    "/home/${var.user}/bootstrap-nifi.sh -x ${hsdp_container_host.nifi.private_ip} --docker-image ${var.docker_image} --docker-username ${var.docker_username} --docker-password ${var.docker_password} --docker-registry ${var.docker_registry} --nifi-jvm-xms ${var.nifi_jvm_xms} --nifi-jvm-xmx ${var.nifi_jvm_xmx}"
  ]
}