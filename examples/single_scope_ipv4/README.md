<!-- BEGIN_TF_DOCS -->
## Pool Design

The example code shows you how to deploy IPAM with pools in 2 regions. The company primarily uses `us-west-2` which has a sandbox pool that is shared to a sandbox OU where any developer can get their own account. It also has a dev pool that further sub-divides into business units. The prod pool also sub-divides into business units.

`us-east-1` is only used as a replicated prod and sub-divides into the same business unit pools as `us-west-2` prod.

![Basic pool structure](../../images/asymmetrical\_example.png "Region Separated Pools")

## Requirements

No requirements.

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
| <a name="input_prod_account"></a> [prod\_account](#input\_prod\_account) | Used for testing, prod account id | `list(string)` | n/a | yes |
| <a name="input_prod_ou_arn"></a> [prod\_ou\_arn](#input\_prod\_ou\_arn) | arn of ou to share to prod accounts | `list(string)` | n/a | yes |
| <a name="input_sandbox_ou_arn"></a> [sandbox\_ou\_arn](#input\_sandbox\_ou\_arn) | arn of ou to share to sandbox accounts | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ipam_info"></a> [ipam\_info](#output\_ipam\_info) | Basic IPAM info. |
<!-- END_TF_DOCS -->