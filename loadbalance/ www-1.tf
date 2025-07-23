resource "digitalocean_droplet" "www-1" {
    image = "ubuntu-20-04-x64"
    name = "www-worker"
    region = "blr1"
    size = "s-2vcpu-4gb"
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
      "curl -sfL https://get.k3s.io | K3S_URL=https://134.209.153.28:6443 K3S_TOKEN=K10df56510d8b43e7ec1cee60c0e790924f52ad464b6105ffe30105c7cb9dc83f8a::server:6811b85b1f0bb493e26024d7b5b40e63 sh -",
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