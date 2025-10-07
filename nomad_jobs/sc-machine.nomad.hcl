job "sc-machine" {
  datacenters = ["dc1"]
  type        = "service"

  group "sc-group" {
    count = 2

    network {
      port "ws" {
        to = 8090
      }
    }

    service {
      name = "sc-machine-svc"
      port = "ws"
      tags = ["urlprefix-/ ws=true"]
      
      connect {
        sidecar_service {}
      }
    }

    task "sc-machine" {
      driver = "docker"

      config {
        image   = "ostis/sc-machine:0.10.0"
        command = "/sc-machine/scripts/docker_entrypoint.sh"
        args = [
          "run",
          "-b", "/sc-machine/build/Release/bin",
          "-c", "/sc-machine/sc-machine.ini",
        ]
        ports = ["ws"]

        volumes = [
          "/opt/kb:/kb",
          "/opt/kb/kb.bin:/kb.bin",
        ]
      }

      env {
        SC_SERVER_LOG_LEVEL = "Debug"
        REBUILD_KB          = "0"
        KB_PATH             = "/kb"
        BINARY_PATH         = "/sc-machine/build/Release/bin"
        EXTENSIONS_PATH     = "/sc-machine/build/Release/lib/extensions"
        CONFIG_PATH         = "/sc-machine/sc-machine.ini"
        SC_SERVER_HOST      = "0.0.0.0"
      }

      resources {
        cpu    = 500
        memory = 1024
      }
    }
  }
}

