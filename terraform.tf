terraform {
  required_version = ">= 0.14.0"
  required_providers {
    hsdp = {
      source  = "philips-software/hsdp"
      version = ">= 0.13.3"
    }
    random = {
      source  = "random"
      version = ">= 2.2.1"
    }
  }
}
