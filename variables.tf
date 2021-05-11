variable "instance_type" {
  description = "The instance type to use"
  type        = string
  default     = "t3.xlarge"
}

variable "host_name" {
  type        = string
  default     = ""
  description = "The middlename for your host default is a random number"
}

variable "volume_size" {
  description = "The volume size to use in GB"
  type        = number
  default     = 50
}

variable "iops" {
  description = "IOPS to provision for EBS storage"
  type        = number
  default     = 500
}


variable "user_groups" {
  description = "User groups to assign to cluster"
  type        = list(string)
  default     = []
}

variable "user" {
  description = "LDAP user to use for connections"
  type        = string
}

variable "private_key" {
  description = "Private key for SSH access"
  type        = string
}

variable "bastion_host" {
  description = "Bastion host to use for SSH connections"
  type        = string
}

variable "nifi_jvm_xms" {
  description = "Nifi JVM Heap Init"
  type        = string
  default     = "8g"
}

variable "nifi_jvm_xmx" {
  description = "Nifi JVM Heap Max"
  type        = string
  default     = "16g"
}

variable "docker_image" {
  description = "The docker image to use"
  type        = string
}

variable "docker_username" {
  description = "Docker Registry username"
  type        = string
  default     = ""
}

variable "docker_password" {
  description = "Docker Registry password"
  type        = string
  default     = ""
}

variable "docker_registry" {
  description = "Docker Registry host"
  type        = string
  default     = "docker.na1.hsdp.io"
}

variable "security_groups" {
  description = "The security groups attached to the nifi instance."
  type        = list(string)
  default     = ["analytics"]
}

variable "nifi_port" {
  description = "The port to be used for nifi"
  type        = string
  default     = "8282"
}

variable "jmx_exporter_version" {
  description = "Deploy jmx exporters for Prometheus as javaagent"
  type        = string
  default     = "0.15.0"
}
