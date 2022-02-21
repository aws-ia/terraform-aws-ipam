<!-- BEGIN_TF_DOCS -->
# AWS IP Address Manager Deployment Module

This module can deploy simple or complex AWS IP Address Manager (IPAM) configurations. It is designed to be flexible for many different use cases. The most common use cases (IPAM designs) are highlighted in the [examples/](./examples/) directory. Below is a representation of a symmetrically nested, multi-region deployment that is possible; Its also possible to do [asymmetically nested deployments](images/asymmetrical\_pool\_structure.png) as well which we have as an [example](./examples/basic).

## Possible Symmetically Nested Pool Structure

![symmetrically nested pool deployment](images/symmetrical\_region\_pool\_bizunit\_pool\_structure.png "Region Separated Pools")

## Configuration via the `var.pool_configurations` variable

This module leans heavily on the variable `var.pool_configurations` which is a multi-level nested map that describes exactly how you want your ipam pools to be nested. It can accept most `aws_vpc_ipam_pool` & `aws_vpc_ipam_pool_cidr` attributes (detailed below) as well as RAM share pools (at any level) to valid AWS principals. **Nested pools do not inherit attributes from their Source pool(s)** so all configuration options are available at each "level".

In this module pools can be nested up to 4 levels deep, 1 root pool + up to 3 nested pools. The root pool defines that `address_family`; If you want to deploy an IPv4 & IPv6 pool structure, you must instantiate the module for each type.

The `pool_configurations` variable is the structure of the other 3 levels. The sub-module sub\_pool has a variable [var.pool\_config](./modules/sub\_pool/variables.tf#L1) that defines the structure that each pool can accept.

The structure of the variable is:

```
pool_configurations = {
  <pool name> = {
    description      = "my pool"
    cidr             = ["10.0.0.0/16"]
    locale           = "us-east-1"
    cidr_allocations = ["10.0.64.0/20"]

    sub_pools = {

      sandbox = {
        cidr = ["10.0.48.0/20"]
        ram_share_principals = [local.dev_ou_arn]
        <any pool_config argument (below)>
      }
    }
  }
}
```

The key of a `pool_config` is the name of the pool, following by its attributes, `ram_share_principals`, and a `sub_pools` map, which is another nested `pool_config`.

```terraform
variable "pool_config" {
  type = object({
    cidr                 = list(string)
    ram_share_principals = optional(list(string))

    locale                            = optional(string)
    allocation_default_netmask_length = optional(string)
    allocation_max_netmask_length     = optional(string)
    allocation_min_netmask_length     = optional(string)
    auto_import                       = optional(string)
    aws_service                       = optional(string)
    description                       = optional(string)
    publicly_advertisable             = optional(bool)

    allocation_resource_tags   = optional(map(string))
    tags                       = optional(map(string))
    cidr_authorization_context = optional(map(string))

    sub_pools = optional(any)
  })
}
```

## Implementation Details

### Locales

IPAM pools **do not inherit attributes** from their parent pools. Locales cannot change from parent to child. For that reason, once a pool in `var.pool_configurations` defines a `locale` all other child pools have an `implied_locale`.

### Implied Descriptions

Descriptions of pools are implied from the name-hierarchy of the pool. For example a with 2 parents "us-east-1" -> "dev" will have an `implied_description` of `"us-east-1/dev"`. You can override the description at any pool level by specifying a description.

`implied_desription = var.pool_config.description == null ? var.implied_description : var.pool_config.description`

### Operating Regions

IPAM operating\_region must be set for the primary region in your terraform provider block and any regions you wish to set a `locale` at. For that reason we construct the `aws_vpc_ipam.operating_regions` from your `pool_configurations` + `data.aws_region.current.name`.

## Importing at Multiple Levels (examples)

**level 0 pool**: `terraform import module.basic.module.level_zero.aws_vpc_ipam_pool.sub ipam-pool-<>`

**level 1 pool**: `terraform import module.basic.module.level_one["<>"].aws_vpc_ipam_pool.sub ipam-pool-<>`

**level 2 pool**: `terraform import module.basic.module.level_two["<>/<>"].aws_vpc_ipam_pool.sub ipam-pool-<>`

**level 3 pool**: `terraform import module.basic.module.level_three["<>/<>/<>"].aws_vpc_ipam_pool.sub ipam-pool-<>`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.73.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_level_one"></a> [level\_one](#module\_level\_one) | ./modules/sub_pool | n/a |
| <a name="module_level_three"></a> [level\_three](#module\_level\_three) | ./modules/sub_pool | n/a |
| <a name="module_level_two"></a> [level\_two](#module\_level\_two) | ./modules/sub_pool | n/a |
| <a name="module_level_zero"></a> [level\_zero](#module\_level\_zero) | ./modules/sub_pool | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_vpc_ipam.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_top_cidr"></a> [top\_cidr](#input\_top\_cidr) | Top level cidr blocks. | `list(string)` | n/a | yes |
| <a name="input_address_family"></a> [address\_family](#input\_address\_family) | IPv4/6 address family. | `string` | `"ipv4"` | no |
| <a name="input_cidr_allocations"></a> [cidr\_allocations](#input\_cidr\_allocations) | List of cidrs to block IPAM from allocating. Uses the `aws_vpc_ipam_pool_cidr_allocation` resource. | `list(string)` | `[]` | no |
| <a name="input_create_ipam"></a> [create\_ipam](#input\_create\_ipam) | Determines whether or not to create an IPAM. If `false` you must also provide a var.ipam\_scope\_id | `bool` | `true` | no |
| <a name="input_ipam_scope_id"></a> [ipam\_scope\_id](#input\_ipam\_scope\_id) | (Optional) Required if `var.ipam_id` is set. Which scope to deploy pools into. | `string` | `null` | no |
| <a name="input_ipam_scope_type"></a> [ipam\_scope\_type](#input\_ipam\_scope\_type) | Which scope type to use. Valid inputs: `public`, `private`. You can alternatively provide your own scope id. | `string` | `"private"` | no |
| <a name="input_pool_configurations"></a> [pool\_configurations](#input\_pool\_configurations) | A multi-level-nested map describing nested IPAM pools. Can nest up to 3 levels with the top level being outside the `pool_configurations`. This attribute is quite complex, see README.md for further explanation. | `any` | `{}` | no |
| <a name="input_top_auto_import"></a> [top\_auto\_import](#input\_top\_auto\_import) | `auto_import` setting for top level pool. | `bool` | `null` | no |
| <a name="input_top_cidr_allocations"></a> [top\_cidr\_allocations](#input\_top\_cidr\_allocations) | cidr\_allocations for top level pool. | `list(string)` | `[]` | no |
| <a name="input_top_description"></a> [top\_description](#input\_top\_description) | Description of top level pool. | `string` | `""` | no |
| <a name="input_top_ram_share_principals"></a> [top\_ram\_share\_principals](#input\_top\_ram\_share\_principals) | Principals to create RAM shares for top level pool. | `list(string)` | `null` | no |
| <a name="input_top_tags"></a> [top\_tags](#input\_top\_tags) | Tags for top level pool. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_operating_regions"></a> [operating\_regions](#output\_operating\_regions) | List of all IPAM operating regions. |
<!-- END_TF_DOCS -->