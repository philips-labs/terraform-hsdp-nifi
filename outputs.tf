output "nifi_node" {
  description = "Container Host IP addresses of Kafka instances"
  value       = hsdp_container_host.nifi.private_ip
}

output "nifi_name_node" {
  description = "Container Host DNS names of Kafka instances"
  value       = hsdp_container_host.nifi.name
}

output "nifi_port" {
  description = "Port where you can reach Kafka"
  value       = "8282"
}
