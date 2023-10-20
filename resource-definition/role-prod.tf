variable "cluster_prod_oidc" {}
resource "humanitec_resource_definition" "role_prod" {
  driver_type = "humanitec/terraform"
  id          = "${local.app}-prod-role"
  name        = "${local.app}-prod-role"
  type        = "aws-role"

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
        path = "terraform/role/"
        rev  = "refs/heads/main"
        url  = "https://github.com/nickhumanitec/examples.git"
      },
      "variables" = {
        policies     = "$${resources.workload>aws-policy.outputs.arn}"
        name         = "$${context.app.id}-$${context.env.id}-$${context.res.id}"
        app          = "$${context.app.id}"
        env          = "$${context.env.id}"
        res          = "$${context.res.id}"
        cluster_oidc = var.cluster_prod_oidc
      }
    })
  }
  lifecycle {
    ignore_changes = [
      criteria
    ]
  }
}

resource "humanitec_resource_definition_criteria" "role_prod" {
  resource_definition_id = humanitec_resource_definition.role_prod.id
  app_id                 = humanitec_application.app.id
  env_id                 = "prod"
}

