# cim-demo

## DNS and ALB
1. Configure your AWS IAM user https://github.com/Humanitec-DemoOrg/aws-examples/tree/main/humanitec-onboarding-aws-iam-user
1. Install and configure as per https://github.com/Humanitec-DemoOrg/aws-examples/tree/main/alb-acm-route53-ingress
1. configure shared/terraform.tfvars from shared/terraform.tfvars.EXAMPLE: Make sure the parameters for your shared ALB are configured correctly, including ACM certificate and `ingress_group_name` as per manifest (example: `manifests/ingress.yaml`)
1. cd shared/ && tofu init && tofu apply

## App and Infrastructure
1. configure app/terraform.tfvars from app/terraform.tfvars.EXAMPLE
1. `cd app/` and then `tofu init && tofu apply`

##  Score
1. Verify each score file, if you changed the `dns_shared_resource_name` please make sure to adjust if needed
1. Modify `deploy.sh` with your Humanitec token and app name
1. Deploy using `bash deploy.sh httpd` (consumer, backend, nginx, podinfo, etc.) One deployment at a time. If you get conflict, it means the deployment is not finished get
