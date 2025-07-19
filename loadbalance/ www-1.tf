resource "digitalocean_droplet" "www-1" {
    image = "ubuntu-20-04-x64"
    name = "www-1"
    region = "nyc3"
    size = "s-1vcpu-1gb"
    ssh_keys = [
      data.digitalocean_ssh_key.terraform.id
    ]
  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }
  
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      # Update system packages
      "sudo apt update",
      # Install nginx
      "sudo apt install -y nginx",
      # Wait for nginx to be ready
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
      # Install K3s agent and join the cluster
      "curl -sfL https://get.k3s.io | K3S_URL=https://134.209.153.28:6443 K3S_TOKEN=K10e2aa12d2fae01a7aa63fbe621561a1e22f5727a467e6d7539e0c9ee988f129ca::server:0f716ba2f9f3e1e063034d28e0615698 sh -",
      # Wait for K3s agent to be ready
      "sleep 10",
      # Verify K3s agent is running
      "sudo systemctl status k3s-agent --no-pager"
    ]
  }
}

# Outputs for the K3s worker node
output "worker_node_ip" {
  description = "Public IP address of the K3s worker node"
  value       = digitalocean_droplet.www-1.ipv4_address
}

output "worker_node_private_ip" {
  description = "Private IP address of the K3s worker node"
  value       = digitalocean_droplet.www-1.ipv4_address_private
}

output "worker_node_status" {
  description = "Status of the worker node"
  value       = digitalocean_droplet.www-1.status
}

output "ssh_connection_command" {
  description = "SSH command to connect to the worker node"
  value       = "ssh root@${digitalocean_droplet.www-1.ipv4_address}"
}