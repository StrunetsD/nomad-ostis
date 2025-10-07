output "node_ip_address" {
  description = "The IP address of the configured Nomad node."
  value       = var.host_ip
}

output "nomad_server_address" {
  description = "The full address for the Nomad API server."
  value       = "http://${var.host_ip}:4646"
}