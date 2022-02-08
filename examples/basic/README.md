<!-- BEGIN_TF_DOCS -->
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

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_basic"></a> [basic](#module\_basic) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dev_ou_arn"></a> [dev\_ou\_arn](#input\_dev\_ou\_arn) | arn of ou to share to dev accounts | `any` | n/a | yes |
| <a name="input_pool_configurations"></a> [pool\_configurations](#input\_pool\_configurations) | n/a | `any` | n/a | yes |
| <a name="input_prod_account"></a> [prod\_account](#input\_prod\_account) | Used for testing, prod account id | `any` | n/a | yes |
| <a name="input_prod_ou_arn"></a> [prod\_ou\_arn](#input\_prod\_ou\_arn) | arn of ou to share to prod accounts | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->