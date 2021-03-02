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

  connection {
    bastion_host = var.bastion_host
    host         = self.private_ip
    user         = var.user
    private_key  = var.private_key
    script_path  = "/home/${var.user}/bootstrap.bash"
  }
}

resource "null_resource" "nifi" {
  triggers = {
    instance_ids = hsdp_container_host.nifi.id
    bash         = file("${path.module}/scripts/bootstrap-nifi.sh")
  }

  connection {
    bastion_host = var.bastion_host
    host         = hsdp_container_host.nifi.private_ip
    user         = var.user
    private_key  = var.private_key
    script_path  = "/home/${var.user}/cluster.bash"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/bootstrap-nifi.sh"
    destination = "/home/${var.user}/bootstrap-nifi.sh"
  }
//
//  provisioner "file" {
//    source      =  var.kafka_trust_store.truststore
//    destination = "/home/${var.user}/kafka.truststore.jks"
//  }
//
//  provisioner "file" {
//    source      = var.kafka_key_store.keystore
//    destination = "/home/${var.user}/kafka.keystore.jks"
//  }
//
//    provisioner "file" {
//    source      =  var.zoo_trust_store.truststore
//    destination = "/home/${var.user}/zookeeper.truststore.jks"
//  }
//
//  provisioner "file" {
//    source      = var.zoo_key_store.keystore
//    destination = "/home/${var.user}/zookeeper.keystore.jks"
//  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /home/${var.user}/bootstrap-nifi.sh",
      "/home/${var.user}/bootstrap-nifi.sh -x ${hsdp_container_host.nifi.private_ip} --docker-image ${var.docker_image} --docker-username ${var.docker_username} --docker-password ${var.docker_password} --docker-registry ${var.docker_registry} --nifi-jvm-xms ${var.nifi_jvm_xms} --nifi-jvm-xmx ${var.nifi_jvm_xmx}"
//      -p ${var.kafka_key_store.password} -t ${var.zoo_trust_store.password} -k ${var.zoo_key_store.password}
    ]
  }
}
