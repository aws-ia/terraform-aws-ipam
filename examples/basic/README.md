## Pool Design

The example code shows you how to deploy IPAM with pools in 2 regions. The company primarily uses `us-west-2`. It has a sandbox pool that is shared to a sandbox OU where any developer can get their own account. It also has a dev pool that further sub-divides into business units. The prod pool also sub-divides into business units.

`us-east-1` is only used as a replicated prod and sub-divides into the same business unit pools as `us-west-2` prod.

![Basic pool structure](../../images/examples\_basic.png "Region Separated Pools")

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.72.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.74.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_basic"></a> [basic](#module\_basic) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_organizations_organization.org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [aws_organizations_organizational_units.ou](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_units) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pool_configurations"></a> [pool\_configurations](#input\_pool\_configurations) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
