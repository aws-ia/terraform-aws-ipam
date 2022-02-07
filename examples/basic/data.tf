locals {
  sandbox_ou_arn = one([
    for _, ou in data.aws_organizations_organizational_units.ou.children[*] :
    ou.arn if ou.name == "sandbox"
  ])
  prod_ou_arn = one([
    for _, ou in data.aws_organizations_organizational_units.ou.children[*] :
    ou.arn if ou.name == "prod"
  ])
}

data "aws_organizations_organization" "org" {}

data "aws_organizations_organizational_units" "ou" {
  parent_id = data.aws_organizations_organization.org.roots[0].id
}
