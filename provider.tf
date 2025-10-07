provider "nomad" {
  address = module.nomad_node.nomad_server_address
}
