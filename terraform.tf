terraform {
  required_providers {
    nomad = {
      source  = "hashicorp/nomad"
      version = "~> 1.4"
    }
    
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }
  }
}
