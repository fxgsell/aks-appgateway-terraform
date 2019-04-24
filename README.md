## Prerequisits
* An Azure account
* Terraform installed where you run this.
* Create a service principal allowed to create all the resources needed for terraform.
* Copy `terraform.tfvars.sample` to `terraform.tfvars` and update the missing values with those from the above service principal.
* Create a user managed identity and get:
    - clientID
    - resourceID

## How to use
1. Run `terraform init` to configure the prerequisites
2. Run `terraform apply` to deploy to your Azure account
3. Run `terraform destroy` to cleanup

Optionaly run `make config` to install the K8s config to ~/.kube/azurek8s

## More links
https://azure.github.io/application-gateway-kubernetes-ingress/docs/tutorial.html#expose-services-over-https

## Todo Next
* Key Vault for Certificates 

## Done
* Terraform for AKS
* Helm for MSI
* Helm for AppGateway Ingress
