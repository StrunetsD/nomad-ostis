job "fabio" {
  datacenters = ["dc1"]
  type        = "system" 

  group "fabio-group" {
    
    network {
      mode = "host"
    }

    task "fabio" {
      driver = "docker"

      config {
        image = "fabio/fabio:latest"
        command = "fabio"
        args = [
          "-proxy.addr", ":443;cs=default", 
          "-registry.consul.addr", "127.0.0.1:8500"
        ]
      }

      template {
        data = <<EOF
          [certSource "default"]
          type = "self"
          certPath = "fabio.crt"
          keyPath = "fabio.key"
        EOF

        destination = "local/fabio.properties"
      }

      resources {
        cpu    = 200 
        memory = 128 
      }
    }
  }
}
