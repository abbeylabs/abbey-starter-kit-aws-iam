locals {
  account_name = ""
  repo_name = ""

  project_path = "github://${local.account_name}/${local.repo_name}"
  policies_path = "${local.project_path}/policies"

  aws_account = ""
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
          one_of = ["replace-me@example.com"]
        }
      }
    ]
  }

  output = {
    location = "${local.project_path}/access.tf"
    append = <<-EOT
      resource "aws_iam_user_group_membership" "user_{{ .user.aws_iam.id }}_group_${data.aws_iam_group.group1.group_name}" {
        user = "{{ .user.aws_iam.${local.aws_account}.id }}"
        groups = [data.aws_iam_group.group1.group_name]
      }
    EOT
  }
}

data "aws_iam_group" "group1" {
  group_name = "group1"
}
