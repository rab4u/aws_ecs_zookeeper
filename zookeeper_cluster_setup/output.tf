output "zookeeper_server_urls" {
  value = "${join(":2181, ", var.server_ip_address_list)}:2181"
}

output "zookeeper_metric_urls" {
  value = "${join(":7000/metrics, ", var.server_ip_address_list)}:7000/metrics"
}