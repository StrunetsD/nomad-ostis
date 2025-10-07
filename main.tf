module "nomad_node" {
  source = "./modules/onprem-nomad-node"

  host_ip              = var.host_ip
  ssh_user             = var.ssh_user
  ssh_private_key_path = var.ssh_private_key_path
}

resource "nomad_job" "fabio" {
  depends_on = [module.nomad_node]

  jobspec = file("${path.root}/nomad_jobs/fabio.nomad.hcl")
}

resource "nomad_job" "sc_machine" {
  depends_on = [module.nomad_node]

  jobspec = file("${path.root}/nomad_jobs/sc-machine.nomad.hcl")
}