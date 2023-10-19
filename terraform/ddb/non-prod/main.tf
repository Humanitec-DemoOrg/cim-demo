
variable "name" {}

variable "app" {}
variable "env" {}

output "region" {
  value = data.aws_region.current.name
}

output "arn" {
  value = aws_dynamodb_table.this.arn
}

output "name" {
  value = local.name
}

locals {
  sanitized_name   = replace(replace(replace(replace(lower(var.name), "modules.", ""), ".externals.", ""), "/[^a-z\\-0-9]/", "-"), "/-*$/", "") #https://github.com/edgelaboratories/terraform-short-name/blob/main/main.tf
  name_is_too_long = length(local.sanitized_name) > 63
  truncated_name   = replace(substr(local.sanitized_name, 0, 63 - 1 - 0), "/-*$/", "")
  name             = local.name_is_too_long ? local.truncated_name : local.sanitized_name
}

resource "aws_dynamodb_table" "this" {
  name         = local.name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "UserId"
  range_key    = "GameTitle"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "GameTitle"
    type = "S"
  }

  attribute {
    name = "TopScore"
    type = "N"
  }

  global_secondary_index {
    name               = "GameTitleIndex"
    hash_key           = "GameTitle"
    range_key          = "TopScore"
    projection_type    = "INCLUDE"
    non_key_attributes = ["UserId"]
  }

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
    for_each = (var.assume_role_arn == "") == true ? [] : [1]
    content {
      role_arn = var.assume_role_arn
    }
  }

}
