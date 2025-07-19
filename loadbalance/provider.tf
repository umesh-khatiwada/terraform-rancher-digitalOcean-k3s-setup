terraform {
  # S3 Backend configuration for remote state storage
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "loadbalance/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locks"
    
    # Optional: Use profile if you have AWS CLI configured
    # profile = "your-aws-profile"
  }

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
