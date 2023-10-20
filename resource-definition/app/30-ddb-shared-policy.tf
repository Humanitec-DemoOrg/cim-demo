resource "humanitec_resource_definition" "ddb_policy" {
  driver_type = "humanitec/terraform"
  id          = "${local.app}-ddb-policy"
  name        = "${local.app}-ddb-policy"
  type        = "aws-policy"

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
        path = "terraform/ddb/policy"
        rev  = "refs/heads/main"
        url  = "https://github.com/Humanitec-DemoOrg/cim-demo.git"
      },
      "variables" = {
        arn  = "$${resources['aws-policy>dynamodb-table'].outputs.arn}"
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

resource "humanitec_resource_definition_criteria" "ddb_non_prod_policy" {
  resource_definition_id = humanitec_resource_definition.ddb_policy.id
  app_id                 = humanitec_application.app.id
  res_id                 = "${local.app}-ddb-non-prod-policy"
}

resource "humanitec_resource_definition_criteria" "ddb_prod_policy" {
  resource_definition_id = humanitec_resource_definition.ddb_policy.id
  app_id                 = humanitec_application.app.id
  res_id                 = "${local.app}-ddb-prod-policy"
}
