variable "ingress_resource_name" {}
variable "ingress_group_name" {}
variable "ingress_cert_arn" {}

resource "humanitec_resource_definition" "ingress" {
  id          = var.ingress_resource_name
  name        = var.ingress_resource_name
  type        = "ingress"
  driver_type = "humanitec/ingress"

  driver_inputs = {
    values_string = jsonencode({
      "annotations" : {
        "alb.ingress.kubernetes.io/certificate-arn" : "${var.ingress_cert_arn}",
        "alb.ingress.kubernetes.io/group.name" : "${var.ingress_group_name}",
        "alb.ingress.kubernetes.io/listen-ports" : "[{\"HTTP\":80},{\"HTTPS\":443}]",
        "alb.ingress.kubernetes.io/scheme" : "internet-facing",
        "alb.ingress.kubernetes.io/ssl-redirect" : "443",
        "alb.ingress.kubernetes.io/target-type" : "ip"
      },
      #   "api_version" : "v1",
      "class" : "alb",
      "no_tls" : true
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


resource "humanitec_resource_definition_criteria" "ingress" {
  resource_definition_id = humanitec_resource_definition.ingress.id
  app_id                 = humanitec_application.app.id
}

//DNS

variable "dns_shared_resource_name" {}
variable "dns_shared_domain" {}

resource "humanitec_resource_definition" "dns" {
  id          = var.dns_shared_resource_name
  name        = var.dns_shared_resource_name
  type        = "dns"
  driver_type = "humanitec/dns-wildcard"

  provision = {
    "ingress" = {
      "is_dependent" : false,
      "match_dependents" : false
    }
  }

  driver_inputs = {
    values_string = jsonencode({
      "domain" : var.dns_shared_domain,
      "template" : "$${context.app.id}-$${context.env.id}"
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


resource "humanitec_resource_definition_criteria" "dns" {
  resource_definition_id = humanitec_resource_definition.dns.id
  app_id                 = humanitec_application.app.id
  res_id                 = "shared.${var.dns_shared_resource_name}"
}
