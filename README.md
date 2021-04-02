<img src="https://cdn.rawgit.com/hashicorp/terraform-website/master/content/source/assets/images/logo-hashicorp.svg" width="500px">

# HSDP NiFi module

Module to create an Apache NiFi deployed
on the HSDP Container Host infrastructure. This module serves as a 
blueprint for future HSDP Container Host modules. Example usage

```hcl
module "nifi" {
  source = "github.com/philips-labs/terraform-hsdp-nifi"

  bastion_host      = "bastion.host"
  user              = "ronswanson"
  private_key       = file("~/.ssh/dec.key")
  user_groups       = ["ronswanson", "poc"]
  docker_image      = "apache/nifi"
}
```
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.0 |
| hsdp | >= 0.13.5 |
| null | >= 2.1.1 |
| random | >= 2.2.1 |

## Providers

| Name | Version |
|------|---------|
| hsdp | >= 0.13.5 |
| null | >= 2.1.1 |
| random | >= 2.2.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bastion\_host | Bastion host to use for SSH connections | `string` | n/a | yes |
| docker_image | The docker image to use | `string` | n/a | yes |
| docker_username | The docker registry username | `string` | n/a | no |
| docker_password | The docker registry password | `string` | n/a | no |
| docker_registry | The docker registry host | `string` | n/a | no |
| instance\_type | The instance type to use | `string` | `"t3.xlarge"` | no |
| iops | IOPS to provision for EBS storage | `number` | `500` | no |
| private\_key | Private key for SSH access | `string` | n/a | yes |
| user | LDAP user to use for connections | `string` | n/a | yes |
| user\_groups | User groups to assign to instance | `list(string)` | `[]` | no |
| security\_groups| Cartel security groups to add the instance to | `list(string)` | `["analytics"]` | no |
| volume\_size | The volume size to use in GB | `number` | `50` | no |
| nifi\_jvm\_xms | Nifi JVM Heap Init | `string` | `8g` | no |
| nifi\_jvm\_xmx | Nifi JVM Heap Max | `string` | `16g` | no |
| host\_name | Nifi host middle name the host name will be `nifi-hostname.dev` | `string` | random number | no |
| nifi\_port | Nifi web application port | `string` | `8282` | no |

## Outputs

| Name | Description |
|------|-------------|
| nifi\_nodes | Container Host IP addresses of NiFi instances |
| nifi\_port | Port where you can reach Nifi |
| nifi\_name\_node | Name of NiFi instance |

# Contact / Getting help

Krishna Prasad Srinivasan <krishna.prasad.srinivasan@philips.com>

# License

License is MIT
