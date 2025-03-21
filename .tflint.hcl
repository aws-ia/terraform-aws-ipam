# https://github.com/terraform-linters/tflint/blob/master/docs/user-guide/module-inspection.md
# borrowed & modified indefinitely from https://github.com/ksatirli/building-infrastructure-you-can-mostly-trust/blob/main/.tflint.hcl

plugin "aws" {
    enabled = true
    version = "0.21.1"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

config {
  module     = true
  force      = false
}

## Ignored Rules:

rule "aws_vpc_ipam_pool_invalid_aws_service" {
  # https://github.com/terraform-linters/tflint-ruleset-aws/issues/357
  enabled = false
}

## Enabled Rules

rule "terraform_required_providers" {
  enabled = true
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
  format  = "snake_case"
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_module_pinned_source" {
  enabled = true
}

rule "terraform_standard_module_structure" {
  enabled = true
}

rule "terraform_workspace_remote" {
  enabled = true
}
