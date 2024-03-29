terraform {
  required_version = ">= 0.14.0"
  required_providers {
    hsdp = {
      source  = "philips-software/hsdp"
      version = ">= 0.20.5"
    }
    ssh = {
      source  = "loafoe/ssh"
      version = ">= 2.1.0"
    }
    random = {
      source  = "random"
      version = ">= 2.2.1"
    }
  }
}
