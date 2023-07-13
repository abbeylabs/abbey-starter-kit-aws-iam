terraform {
  backend "http" {
    address        = "https://api.abbey.io/terraform-http-backend"
    lock_address   = "https://api.abbey.io/terraform-http-backend/lock"
    unlock_address = "https://api.abbey.io/terraform-http-backend/unlock"
    lock_method    = "POST"
    unlock_method  = "POST"
  }

  required_providers {
    abbey = {
      source = "abbeylabs/abbey"
      version = "0.2.2"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "abbey" {
  # Configuration options
  bearer_auth = var.abbey_token
}

provider "aws" {
  region = "us-west-2"
}

resource "abbey_grant_kit" "IAM_membership" {
  name = "IAM_membership"
  description = <<-EOT
    Grants membership to an IAM Group.
    This Grant Kit uses a single-step Grant Workflow that requires only a single reviewer
    from a list of reviewers to approve access.
  EOT

  workflow = {
    steps = [
      {
        reviewers = {
          # Typically uses your Primary Identity.
          # For this local example, you can pass in an arbitrary string.
          # For more information on what a Primary Identity is, visit https://docs.abbey.io.
          one_of = ["replace-me@example.com"]
        }
      }
    ]
  }

  output = {
    # Replace with your own path pointing to where you want your access changes to manifest.
    # Path is an RFC 3986 URI, such as `github://{organization}/{repo}/path/to/file.tf`.
    location = "github://replace-me-with-organization/replace-me-with-repo/access.tf" #CHANGEME
    append = <<-EOT
      resource "null_resource" "null_grant_${random_pet.random_pet_name.id}" {
      resource "aws_iam_user_group_membership" "user_{{ .data.system.abbey.secondary_identities.aws_iam.name }}_group_${aws_iam_group.group.name}" {
        user = {{ .data.system.abbey.secondary_identities.aws_iam.name }}
        groups = ["${data.aws_iam_group.group1.name}"]
      }
    EOT
  }
}

resource "abbey_identity" "user_1" {
  name = "User 1"

  linked = jsonencode({
    abbey = [
      {
        type  = "AuthId"
        value = "replace-me@example.com" #CHANGEME
      }
    ]

    aws_iam = [
      {
        name = "ReplaceWithAWSIamName" #CHANGEME
      })
}

data "aws_iam_group" "group1" {
  name = "group1"
}


