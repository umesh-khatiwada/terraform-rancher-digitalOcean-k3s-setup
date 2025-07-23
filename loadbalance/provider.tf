terraform {
  # Note: S3 backend temporarily disabled for initial deployment
  # Will be enabled after S3 bucket is created
  
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }  
}
variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
}

variable "pvt_key" {
  description = "Private key path"
  type        = string
}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "terraform" {
  name = "terraform"
}
