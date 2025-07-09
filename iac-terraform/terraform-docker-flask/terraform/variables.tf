variable "postgres_user" {
  type        = string
  description = "PostgreSQL username"
  default     = "testuser"
}

variable "postgres_password" {
  type        = string
  description = "PostgreSQL password"
  default     = "testpassword"
}

variable "postgres_db" {
  type        = string
  description = "PostgreSQL database name"
  default     = "testdb"
}
