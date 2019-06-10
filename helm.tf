
provider "helm" {
  install_tiller  = true
  service_account = "tiller"

  kubernetes  {
    host                   = "${azurerm_kubernetes_cluster.k8s.kube_config.0.host}"
    client_certificate     = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)}"
    client_key             = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)}"
    cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)}"
  }
}

data "helm_repository" "chart_msi" {
    name = "${var.helm_repo}"
    username = "${var.helm_username}"
    password = "${var.helm_password}"
    url  = "${var.helm_url}"
}

resource "helm_release" "aad-identity" {
  name       = "aad-release"
  repository = "${data.helm_repository.chart_msi.metadata.0.name}"
  chart      = "${data.helm_repository.chart_msi.metadata.0.name}/aad-pod-identity"

  set_string {
    name  = "azureIdentity.resourceID"
    value = "/subscriptions/${var.subscription}/resourceGroups/${azurerm_resource_group.k8s.name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${azurerm_user_assigned_identity.k8s.name}"
  }

  set_string {
    name  = "azureIdentity.clientID"
    value = "${azurerm_user_assigned_identity.k8s.client_id}"
  }

  set_string {
    name  = "azureIdentityBinding.selector"
    value = "datalake-msi"
  }
}

data "helm_repository" "chart_agi" {
    name = "application-gateway-kubernetes-ingress"
    url  = "https://azure.github.io/application-gateway-kubernetes-ingress/helm/"
}

resource "helm_release" "appgateway_ingress" {
  name       = "ingress-azure"
  repository = "{data.helm_repository.chart_agi.metadata.0.name}"
  chart      = "application-gateway-kubernetes-ingress/ingress-azure"

  set_string {
    name  = "appgw.subscriptionId"
    value = "${var.subscription}"
  }
  set_string {
    name  = "appgw.resourceGroup"
    value = "${azurerm_resource_group.k8s.name}"
  }
  set_string {
    name  = "appgw.name"
    value = "${azurerm_application_gateway.network.name}"
  }

  set_string {
    name  = "armAuth.type"
    value = "aadPodIdentity"
  }
  set_string {
    name  = "armAuth.identityResourceID"
    //value = "/subscriptions/${var.subscription}/resourceGroups/${azurerm_resource_group.k8s.name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${azurerm_user_assigned_identity.k8s.name}"
    value = "${azurerm_user_assigned_identity.k8s.id}"
  }
  set_string {
    name  = "armAuth.identityClientID"
    value = "${azurerm_user_assigned_identity.k8s.client_id}"
  }

  set_string {
    name  = "aksClusterConfiguration.apiServerAddress"
    value = "kubernetes"
  }

  set {
    name  = "rbac.enabled"
    value = true
  }
}