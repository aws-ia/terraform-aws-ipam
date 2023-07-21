# Upgrade from v1 to v2

**NOTE: If you are not using public IPs there are no changes required to upgrade to v2.**

In order to support importing multiple public IPs into AWS IPAM, we have updated the variable `top_cidr_authorization_context`. This variable has been renamed to `top_cidr_authorization_contexts` (notice the `s`) which has a strict structure for to inform provision public cidrs into the top level pool.


## Upgrade Guide

### HCL upgrade

Previously you could only specify the context for [1 public ip](https://github.com/aws-ia/terraform-aws-ipam/blob/991dcf02fd2175bd3a6b10a4ee61b01cf89f813d/examples/single_scope_ipv6/main.tf#L15C1-L18C4). This should now be updated to a list of maps that includes the corresponding cidr. See example below


#### Before

```hcl
  top_cidr_authorization_context = {
    message   = var.cidr_authorization_context_message
    signature = var.cidr_authorization_context_signature
  }
```

#### After

```hcl
  top_cidr_authorization_contexts = [{
    cidr      = var.cidr_authorization_context_cidr
    message   = var.cidr_authorization_context_message
    signature = var.cidr_authorization_context_signature
  }]
```

**IMPORTANT: Each `top_cidr_authorization_contexts[#].cidr` must have a corresponding matching reference in the `top_cidr` list.**
