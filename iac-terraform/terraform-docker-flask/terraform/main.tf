terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# Docker network
resource "docker_network" "custom_bridge" {
  name = "custom_bridge"
}

# Build Docker image from Flask app
resource "docker_image" "python_app" {
  name = "local-python-app"

  build {
    context    = abspath("${path.module}/../flask_app")
    dockerfile = "Dockerfile"
  }
}

# PostgreSQL container
resource "docker_container" "postgres" {
  name  = "postgres-db"
  image = "postgres:15-alpine"

  env = [
    "POSTGRES_USER=${var.postgres_user}",
    "POSTGRES_PASSWORD=${var.postgres_password}",
    "POSTGRES_DB=${var.postgres_db}"
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

# Python Flask container
resource "docker_container" "python_app" {
  name  = "python-app-container"
  image = docker_image.python_app.name

  env = [
    "POSTGRES_USER=${var.postgres_user}",
    "POSTGRES_PASSWORD=${var.postgres_password}",
    "POSTGRES_DB=${var.postgres_db}",
    "POSTGRES_HOST=postgres-db"
  ]

  ports {
    internal = 5000
    external = 5000
  }

  depends_on = [docker_container.postgres]

  networks_advanced {
    name    = docker_network.custom_bridge.name
    aliases = ["python-app-container"]
  }
}
