variable "ssh_user" {
  description = "User of the host"
  type = string
}

variable "ssh_private_key_path" {
  description = "The local path to the SSH private key."
  type        = string
}

variable "host_ip" {
  description = "The public or private IP address of the on-premise server."
  type        = string
}
