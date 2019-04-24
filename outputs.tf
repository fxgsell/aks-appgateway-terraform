output "kube_config" {
  value = "${azurerm_kubernetes_cluster.k8s.kube_config_raw}"
}

output "host" {
  value = "${azurerm_kubernetes_cluster.k8s.kube_config.0.host}"
}

#output "metatstore_connection_string" {
#  value = "Server=tcp:${azurerm_mysql_server.datacatalog.fqdn},1433;Initial Catalog=${azurerm_mysql_database.metastore.name};Persist Security Info=False;User ID=${azurerm_mysql_server.datacatalog.administrator_login};Password=${azurerm_mysql_server.datacatalog.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
#}

