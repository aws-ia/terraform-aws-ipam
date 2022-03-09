package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestExamplesMultipleIPv4Scopes(t *testing.T) {

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/multiple_scopes",
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
