resource "humanitec_resource_definition" "sqs_policy" {
  driver_type = "humanitec/terraform"
  id          = "${local.app}-sqs-policy"
  name        = "${local.app}-sqs-policy"
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
        path = "terraform/sqs/policy"
        rev  = "refs/heads/main"
        url  = "https://github.com/nickhumanitec/examples.git"
      },
      "variables" = {
        arn = "$${resources['aws-policy>sqs'].outputs.arn}"

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

resource "humanitec_resource_definition_criteria" "sqs_non_prod_policy" {
  resource_definition_id = humanitec_resource_definition.sqs_policy.id
  app_id                 = humanitec_application.app.id
  res_id                 = "${local.app}-sqs-non-prod-policy"
}

resource "humanitec_resource_definition_criteria" "sqs_prod_policy" {
  resource_definition_id = humanitec_resource_definition.sqs_policy.id
  app_id                 = humanitec_application.app.id
  res_id                 = "${local.app}-sqs-prod-policy"
}
