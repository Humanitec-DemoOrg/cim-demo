resource "humanitec_resource_definition" "sns_policy" {
  driver_type = "humanitec/terraform"
  id          = "${local.app}-sns-policy"
  name        = "${local.app}-sns-policy"
  type        = "aws-policy"

  driver_inputs = {
    secrets = {
      variables = jsonencode({
        access_key      = var.access_key
        secret_key      = var.secret_key
        assume_role_arn = var.assume_role_arn
        region          = var.region
      })
    },
    values = {
      "source" = jsonencode(
        {
          path = "terraform/sns/policy"
          rev  = "refs/heads/main"
          url  = "https://github.com/nickhumanitec/examples.git"
        }
      )
      "variables" = jsonencode(
        {
          arn  = "$${resources['aws-policy>sns-topic'].outputs.arn}"
          name = "$${context.app.id}-$${context.env.id}-$${context.res.id}"
          app  = "$${context.app.id}"
          env  = "$${context.env.id}"
          res  = "$${context.res.id}"
        }
      )
    }
  }
  lifecycle {
    ignore_changes = [
      criteria
    ]
  }


}

resource "humanitec_resource_definition_criteria" "sns_non_prod_policy" {
  resource_definition_id = humanitec_resource_definition.sns_policy.id
  app_id                 = humanitec_application.app.id
  res_id                 = "${local.app}-sns-non-prod-policy"
}

resource "humanitec_resource_definition_criteria" "sns_prod_policy" {
  resource_definition_id = humanitec_resource_definition.sns_policy.id
  app_id                 = humanitec_application.app.id
  res_id                 = "${local.app}-sns-prod-policy"
}
