provider "aws" {
  region = "us-east-1"
}

provider "abbey" {
  bearer_auth = var.abbey_token
}
