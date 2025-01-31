variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "private_subnet_ids" {
  description = "Private subnet ID"
  type        = list(string)
}

variable "app_sg_id" {
  description = "Security group id for the main app"
  type        = string
}
