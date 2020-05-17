terraform {
  required_version = "~> 0.11.14"
}

provider "random" {
  version = "~> 2.2"
}

provider "aws" {
  version = "~> 2.55"
  region  = "${var.region}"
}

locals {
  random_string = "${random_string.this.result}"
  user          = "${element(split("@", element(split(":", data.aws_caller_identity.current.user_id), 1)), 0)}"
}

resource "random_string" "this" {
  length  = 4
  number  = false
  special = false
  upper   = false
}
