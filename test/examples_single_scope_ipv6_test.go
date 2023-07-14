package test

import (
	"fmt"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

// Requires environment variables from ./examples_ipv4_basic_test.go to be set
const (
	ipv6_cidr = "IPV6_CIDR"
	message   = "MESSAGE"
	signature = "SIGNATURE"
)

func TestExamplesIPv6(t *testing.T) {
	// Runs tests if environment variables found
	if os.Getenv(ipv6_cidr) != "" && os.Getenv(message) != "" && os.Getenv(signature) != "" {
		fmt.Println("Environment variables found, running IPv6 tests.")

		_ipv6_cidr := os.Getenv(ipv6_cidr)
		_message := os.Getenv(message)
		_signature := os.Getenv(signature)

		terraformOptions := &terraform.Options{
			TerraformDir: "../examples/single_scope_ipv6",
			Vars: map[string]interface{}{
				"ipv6_cidr":                            _ipv6_cidr,
				"cidr_authorization_context_cidr":      _ipv6_cidr,
				"cidr_authorization_context_message":   _message,
				"cidr_authorization_context_signature": _signature,
			},
		}

		defer terraform.Destroy(t, terraformOptions)
		terraform.InitAndApply(t, terraformOptions)

	}
	fmt.Println("Must set environment variables, skipping IPv6 tests.")
}
