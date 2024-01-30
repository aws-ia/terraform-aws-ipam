terraform {
  required_version = "~> 1.7"



  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.34"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.10.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
}
