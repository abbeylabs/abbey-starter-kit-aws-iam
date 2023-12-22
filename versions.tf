terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    abbey = {
      source = "abbeylabs/abbey"
      version = "~> 0.2.6"
    }
  }
}
