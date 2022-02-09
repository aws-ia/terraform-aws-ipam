package test

import (
	"fmt"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestExamplesBasic(t *testing.T) {
	if os.Getenv("TEST_ACCOUNT") == "" || os.Getenv("DEV_OU_ARN") == "" || os.Getenv("PROD_OU_ARN") == "" {
		fmt.Println("Must set environment variables.")
		os.Exit(1)
	}

	test_account_id := os.Getenv("TEST_ACCOUNT")
	dev_ou_arn := os.Getenv("DEV_OU_ARN")
	prod_ou_arn := os.Getenv("PROD_OU_ARN")

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/basic",
		Vars: map[string]interface{}{
			"prod_account": test_account_id,
			"dev_ou_arn":   dev_ou_arn,
			"prod_ou_arn":  prod_ou_arn,
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
