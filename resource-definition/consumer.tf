resource "humanitec_resource_definition" "workload_consumer_sa" {
  driver_type = "humanitec/template"
  id          = "${local.app}-consumer-sa"
  name        = "${local.app}-consumer-sa"
  type        = "k8s-service-account"

  driver_inputs = {
    values_string = jsonencode({
      templates = {
        init      = <<EOL
name: ${local.app}-consumer-sa
EOL
        manifests = <<EOL
serviceaccount.yaml:
  location: namespace
  data:
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: {{ .init.name }}
      annotations:
        eks.amazonaws.com/role-arn: $${resources.aws-role.outputs.arn}
EOL
        outputs   = <<EOL
name: {{ .init.name }}
EOL
        cookie    = ""
      }
    })
    secrets_string = jsonencode({
    })
  }
  lifecycle {
    ignore_changes = [
      criteria
    ]
  }
}

resource "humanitec_resource_definition_criteria" "workload_consumer_sa" {
  resource_definition_id = humanitec_resource_definition.workload_consumer_sa.id
  app_id                 = humanitec_application.app.id
  res_id                 = "modules.consumer"
}


resource "humanitec_resource_definition" "workload_consumer" {
  driver_type = "humanitec/template"
  id          = "${local.app}-consumer-workload"
  name        = "${local.app}-consumer-workload"
  type        = "workload"

  driver_inputs = {
    values_string = jsonencode({
      templates = {
        init      = ""
        manifests = ""
        outputs   = <<EOL
update:
    - op: add
      path: /spec/serviceAccountName
      value: $${resources.k8s-service-account.outputs.name}
EOL
        cookie    = ""
      }
    })
    secrets_string = jsonencode({
    })
  }

  lifecycle {
    ignore_changes = [
      criteria
    ]
  }

}

resource "humanitec_resource_definition_criteria" "workload_consumer" {
  resource_definition_id = humanitec_resource_definition.workload_consumer.id
  app_id                 = humanitec_application.app.id
  res_id                 = "modules.consumer"
}
