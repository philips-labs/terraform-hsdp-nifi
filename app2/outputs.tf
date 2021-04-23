output "nifi_node" {
  description = "Container Host IP address of the nifi instance"
  value       = hsdp_container_host.nifi.private_ip
}

output "nifi_name_node" {
  description = "Container Host DNS names of nifi instance"
  value       = hsdp_container_host.nifi.name
}

output "nifi_port" {
  description = "Port where you can reach Nifi"
  value       = var.nifi_port
}
