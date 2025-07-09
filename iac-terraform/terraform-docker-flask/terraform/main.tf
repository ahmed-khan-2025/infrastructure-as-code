terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# Build Flask image
resource "docker_image" "python_app"{
  name = "local-python-app"

  build {
    context    = abspath("${path.module}/../flask_app")
    # context    = "C:/Galib/InfrastructureAsACode-IaC/Terraform/Terraform-project/terraform-python/"
    #dockerfile = abspath("${path.module}/../Dockerfile")
    dockerfile = "Dockerfile" 
  }
}

resource "docker_network" "custom_bridge" {
  name = "custom_bridge"
}
# resource "docker_network" "custom_bridge" {
#   name = "custom_bridge"

#   lifecycle {
#     prevent_destroy = true
#   }
# }

resource "docker_container" "postgres" {
  name  = "postgres-db"
  image = "postgres:15-alpine"

  env = [
    "POSTGRES_USER=testuser",
    "POSTGRES_PASSWORD=testpassword",
    "POSTGRES_DB=testdb",
  ]

  ports {
    internal = 5432
    external = 5432
  }

  networks_advanced {
    name    = docker_network.custom_bridge.name
    aliases = ["postgres-db"]
  }

  restart = "always"
}

resource "docker_container" "python_app" {
  name  = "python-app-container"
  image = docker_image.python_app.name

  ports {
    internal = 5000
    external = 5000
  }

  env = [
    "POSTGRES_HOST=postgres-db",
    "POSTGRES_DB=testdb",
    "POSTGRES_USER=testuser",
    "POSTGRES_PASSWORD=testpassword",
  ]

  depends_on = [docker_container.postgres]

  networks_advanced {
    name    = docker_network.custom_bridge.name
    aliases = ["python-app-container"]
  }
}
