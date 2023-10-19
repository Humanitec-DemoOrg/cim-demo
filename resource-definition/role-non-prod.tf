variable "cluster_non_prod_oidc" {}
resource "humanitec_resource_definition" "role_non_prod" {
  driver_type = "humanitec/terraform"
  id          = "${local.app}-non-prod-role"
  name        = "${local.app}-non-prod-role"
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
          cluster_oidc = var.cluster_non_prod_oidc
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

resource "humanitec_resource_definition_criteria" "role_non_prod" {
  resource_definition_id = humanitec_resource_definition.role_non_prod.id
  app_id                 = humanitec_application.app.id
  env_id                 = "development"
}

