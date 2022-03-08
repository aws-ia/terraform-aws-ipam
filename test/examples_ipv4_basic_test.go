package test

import (
	"fmt"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

// You must set these environment variables for this test
const (
	sandbox = "SANDBOX_OU_ARN"
	test    = "TEST_ACCOUNT"
	prod    = "PROD_OU_ARN"
)

func TestExamplesIPv4Basic(t *testing.T) {
	if os.Getenv(test) == "" || os.Getenv(sandbox) == "" || os.Getenv(prod) == "" {
		fmt.Println("Must set environment variables.")
		os.Exit(1)
	}

	test_account_id := os.Getenv(test)
	dev_ou_arn := os.Getenv(sandbox)
	prod_ou_arn := os.Getenv(prod)

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/ipv4_basic",
		Vars: map[string]interface{}{
			"prod_account":   test_account_id,
			"sandbox_ou_arn": dev_ou_arn,
			"prod_ou_arn":    prod_ou_arn,
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
