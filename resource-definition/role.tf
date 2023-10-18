resource "humanitec_resource_definition" "role" {
  driver_type = "humanitec/terraform"
  id          = "${local.app}-role"
  name        = "${local.app}-role"
  type        = "aws-role"

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
          path = "terraform/role/"
          rev  = "refs/heads/main"
          url  = "https://github.com/nickhumanitec/examples.git"
        }
      )
      "variables" = jsonencode(
        {
          policies     = "$${resources.workload>aws-policy.outputs.arn}"
          name         = "$${context.app.id}-$${context.env.id}-$${context.res.id}"
          app          = "$${context.app.id}"
          env          = "$${context.env.id}"
          res          = "$${context.res.id}"
          cluster_oidc = "3F0B8D9900F089E916742738AC27FCBA"
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

resource "humanitec_resource_definition_criteria" "role" {
  resource_definition_id = humanitec_resource_definition.role.id
  app_id                 = humanitec_application.app.id
}
