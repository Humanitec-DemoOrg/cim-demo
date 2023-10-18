
variable "name" {}
variable "arn" {}

variable "app" {}
variable "env" {}

output "region" {
  value = data.aws_region.current.name
}

output "arn" {
  value = aws_iam_policy.this.arn
}

output "name" {
  value = var.name
}

resource "aws_iam_policy" "this" {
  name_prefix = var.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "sns:*"
        ],
        "Resource" : "${var.arn}"
      }
    ]
  })
  tags = {
    env = "${var.app}-${var.env}"
  }
}

// boilerplate for Humanitec terraform driver
variable "region" {}
variable "access_key" {}
variable "secret_key" {}
variable "assume_role_arn" { default = "" }

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
  dynamic "assume_role" {
    for_each = (var.var.assume_role_arn == "") == true ? [] : [1]
    content {
      role_arn = var.assume_role_arn
    }
  }

}
