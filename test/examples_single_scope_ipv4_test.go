package test

import (
	"fmt"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

// You must set these environment variables for this test
const (
	test = "TEST_ACCOUNT"
)

func TestExamplesIPv4Basic(t *testing.T) {
	if os.Getenv(test) == "" {
		fmt.Println("Must set environment variables.")
		os.Exit(1)
	}

	test_account_id := os.Getenv(test)

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/single_scope_ipv4",
		Vars: map[string]interface{}{
			"prod_account":   []string{test_account_id},
			"sandbox_ou_arn": []string{test_account_id},
			"prod_ou_arn":    []string{test_account_id},
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
