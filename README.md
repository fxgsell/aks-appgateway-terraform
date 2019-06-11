## Prerequisits
* An Azure account
* Terraform installed where you run this.
* Create a service principal allowed to create all the resources needed for terraform, `Owner` permission on the subscription is required to modify permission on the created resources, if this is too much permission you can modify the script to use a predifined resource group on wich you can set the `Owner` permission.
* Prepare an [Helm repository](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-helm-repos) and add the chart for [aad-pod-identity](https://github.com/Azure/aad-pod-identity/tree/master/charts).
* Copy `terraform.tfvars.sample` to `terraform.tfvars` and update the missing values with those from the above service principal and helm repo.
* Have the SSL certificate ready, you can obtain free certificates from [SSL For Free](https://www.sslforfree.com/). Extract the .key and the .crt into a folder called `ssl` at the root of the project.

## How to use
1. Run `make install` to configure the prerequisites.
1. Run `make apply` to deploy to your Azure account.
1. Run `make config` to install the K8s config to ~/.kube/azurek8s (you can export KUBECONFIG to use it or copy it to you default file).
1. Run `kubectl apply -f demo_app/guestbook-all-in-one.yaml` to deploy the test application on the cluster.
1. To add the SSL Ingress:
    1. Export an environement variable SECRET with the value for the name for you certificate.
    1. Export an environement variable DOMAIN with the domain name for your app.
    1. Then run `kubectl create secret tls ${SECRET} --key ssl/private.key --cert ssl/certificate.crt`
    1. Create the Ingress by running `sed 's/__DOMAIN__/$(DOMAIN)/g; s/__SECRET__/$(SECRET)/g' demo_app/ssl-ing-guestbook.yaml | kubectl apply -f -`
1. To add the Ingress without SSL:
    1. Run `kubectl apply -f demo_app/ing-guestbook.yaml` to deploy the Ingress.
1. Delete the resource group to remove everything.

Optionaly run `make config` to install the K8s config to ~/.kube/azurek8s

## More links
https://azure.github.io/application-gateway-kubernetes-ingress/docs/tutorial.html#expose-services-over-https

## Done
* Terraform for AKS
* Helm for MSI
* Helm for AppGateway Ingress with SSL
