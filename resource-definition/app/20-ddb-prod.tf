resource "humanitec_resource_definition" "ddb_prod" {
  driver_type = "humanitec/terraform"
  id          = "${local.app}-ddb-prod"
  name        = "${local.app}-ddb-prod"
  type        = "dynamodb-table"

  provision = {
    "aws-policy#${local.app}-ddb-prod-policy" = {
      "is_dependent" : true,
      "match_dependents" : true
    }
  }

  driver_inputs = {
    secrets_string = jsonencode({
      variables = {
        access_key      = var.access_key
        secret_key      = var.secret_key
        assume_role_arn = var.assume_role_arn
        region          = var.region
      }
    }),
    values_string = jsonencode({
      "source" = {
        path = "terraform/ddb/prod"
        rev  = "refs/heads/main"
        url  = "https://github.com/Humanitec-DemoOrg/cim-demo.git"
      },
      "variables" = {
        name = "$${context.app.id}-$${context.env.id}-$${context.res.id}"
        app  = "$${context.app.id}"
        env  = "$${context.env.id}"
        res  = "$${context.res.id}"
      }

    })
  }
  lifecycle {
    ignore_changes = [
      criteria
    ]
  }

}

resource "humanitec_resource_definition_criteria" "ddb_prod" {
  resource_definition_id = humanitec_resource_definition.ddb_prod.id
  app_id                 = humanitec_application.app.id
  env_id                 = "prod"
}