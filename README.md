<!-- BEGIN_TF_DOCS -->
# Terraform Module for Amazon VPC IP Address Manager on AWS

Built to accommodate a wide range of use cases, this Terraform module can deploy both simple and complex Amazon Virtual Private Cloud (Amazon VPC) IP Address Manager (IPAM) configurations. It supports both symmetrically nested, multi-Region deployments (most common IPAM designs) as well as [asymmetically nested deployments](images/asymmetrical\_example.png).

Refer to the [examples/](./examples/) directory in this GitHub repository for examples.

The embedded example below describes a symmetrically nested pool structure, including its configuration, implementation details, requirements, and more.

## Architecture

![symmetrically nested pool deployment](images/ipam\_symmetrical.png)

## Configuration
This module strongly relies on the `var.pool_configuration` variable, which is a multi-level, nested map that describes how to nest your IPAM pools. It can accept most `aws_vpc_ipam_pool` and `aws_vpc_ipam_pool_cidr` attributes (detailed below) as well as RAM share pools (at any level) to valid AWS principals. Nested pools do not inherit attributes from their source pool(s), so all configuration options are available at each level. `locale` is implied in sub pools after declared in a parent.

In this module, pools can be nested up to four levels, including one root pool and up to three nested pools. The root pool defines the `address_family` variable. If you want to deploy an IPv4 and IPv6 pool structure, you must instantiate the module for each type.

The `pool_configurations` variable is the structure of the other three levels. The `sub_pool` submodule has a `var.pool_config` variable that defines the structure that each pool can accept. The variable has the following structure:

```
pool_configurations = {
  <pool name> = {
    description      = "my pool"
    cidr             = ["10.0.0.0/16"]
    locale           = "us-east-1"

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

The key of a `pool_config` variable is the name of the pool, followed by its attributes `ram_share_principals` and a `sub_pools` map, which is another nested `pool_config` variable.

```terraform
variable "pool_config" {
  type = object({
    cidr                 = list(string)
    ram_share_principals = optional(list(string))

    name                              = optional(string)
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

## RAM Sharing

This module allows you to share invidual pools to any valid RAM principal. All levels of `var.pool_configurations` accept an argument `ram_share_principals` which should be a list of valid RAM share principals (org-id, ou-id, or account id).

## Using Outputs

Since resources are dynamically generated based on user configuration, we roll them into grouped outputs. For example, to get attributes off your level 2 pools:

The output `pools_level_2` offers you a map of every pool where the name is the route of the tree keys [example `"corporate-us-west-2/dev"`](https://github.com/aws-ia/terraform-aws-ipam/blob/a7d508cb0be2f68d99952682c2392b6d7d541d96/examples/single_scope_ipv4/main.tf#L28).

To get a specific ID:
```
> module.basic.pools_level_2["corporate-us-west-2/dev"].id
"ipam-pool-0c816929a16f08747"
```

To get all IDs
```terraform
> [ for pool in module.basic.pools_level_2: pool["id"]]
[
  "ipam-pool-0c816929a16f08747",
  "ipam-pool-0192c70b370384661",
  "ipam-pool-037bb0524f8b3278e",
  "ipam-pool-09400d26a6d1df4a5",
  "ipam-pool-0ee5ebe8f8d2d7187",
]
```

## Implementation

### Implied pool names and descriptions

By default, pool `Name` tags and pool descriptions are implied from the name-hierarchy structure of the pool. For example, a pool with two parents `us-east-1` and `dev` has an implied name and description value of `us-east-1/dev`. You can override either or both name and description at any pool level by specifying a `name` or `description` value.

### Locales

IPAM pools do not inherit attributes from their parent pools. Locales cannot change from parent to child. For that reason, after a pool in the `var.pool_configurations` variable defines a `locale` value, all other child pools have an `implied_locale` value.

### Operating Regions

The IPAM `operating_region` variable must be set for the primary Region in your Terraform provider block and any Regions you want to set a `locale`. For that reason, the value of the `aws_vpc_ipam.operating_regions` variable is constructed by combining the  `pool_configurations` and `data.aws_region.current.name` attributes.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.73.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.17.1 |

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
| <a name="input_top_cidr"></a> [top\_cidr](#input\_top\_cidr) | Top-level CIDR blocks. | `list(string)` | n/a | yes |
| <a name="input_address_family"></a> [address\_family](#input\_address\_family) | IPv4/6 address family. | `string` | `"ipv4"` | no |
| <a name="input_create_ipam"></a> [create\_ipam](#input\_create\_ipam) | Determines whether to create an IPAM. If `false`, you must also provide a var.ipam\_scope\_id. | `bool` | `true` | no |
| <a name="input_ipam_scope_id"></a> [ipam\_scope\_id](#input\_ipam\_scope\_id) | (Optional) Required if `var.ipam_id` is set. Determines which scope to deploy pools into. | `string` | `null` | no |
| <a name="input_ipam_scope_type"></a> [ipam\_scope\_type](#input\_ipam\_scope\_type) | Which scope type to use. Valid inputs include `public` or `private`. You can alternatively provide your own scope ID. | `string` | `"private"` | no |
| <a name="input_pool_configurations"></a> [pool\_configurations](#input\_pool\_configurations) | A multi-level, nested map describing nested IPAM pools. Can nest up to three levels with the top level being outside the `pool_configurations`. This attribute is quite complex, see README.md for further explanation. | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to add to the aws\_vpc\_ipam resource. | `any` | `{}` | no |
| <a name="input_top_auto_import"></a> [top\_auto\_import](#input\_top\_auto\_import) | `auto_import` setting for top-level pool. | `bool` | `null` | no |
| <a name="input_top_cidr_authorization_context"></a> [top\_cidr\_authorization\_context](#input\_top\_cidr\_authorization\_context) | A signed document that proves that you are authorized to bring the specified IP address range to Amazon using BYOIP. Document is not stored in the state file. For more information, refer to https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool_cidr#cidr_authorization_context. | `any` | `null` | no |
| <a name="input_top_description"></a> [top\_description](#input\_top\_description) | Description of top-level pool. | `string` | `""` | no |
| <a name="input_top_name"></a> [top\_name](#input\_top\_name) | Name of top-level pool. | `string` | `null` | no |
| <a name="input_top_ram_share_principals"></a> [top\_ram\_share\_principals](#input\_top\_ram\_share\_principals) | Principals to create RAM shares for top-level pool. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ipam_info"></a> [ipam\_info](#output\_ipam\_info) | If created, ouput the IPAM object information. |
| <a name="output_operating_regions"></a> [operating\_regions](#output\_operating\_regions) | List of all IPAM operating regions. |
| <a name="output_pool_level_0"></a> [pool\_level\_0](#output\_pool\_level\_0) | Map of all pools at level 0. |
| <a name="output_pool_names"></a> [pool\_names](#output\_pool\_names) | List of all pool names. |
| <a name="output_pools_level_1"></a> [pools\_level\_1](#output\_pools\_level\_1) | Map of all pools at level 1. |
| <a name="output_pools_level_2"></a> [pools\_level\_2](#output\_pools\_level\_2) | Map of all pools at level 2. |
| <a name="output_pools_level_3"></a> [pools\_level\_3](#output\_pools\_level\_3) | Map of all pools at level 3. |
<!-- END_TF_DOCS -->