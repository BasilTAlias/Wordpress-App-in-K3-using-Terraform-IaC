# Provider Configuration
provider "aws" {
  region = "us-east-1" # Replace with your preferred region
}

# EC2 Instance Resource
resource "aws_instance" "k3s_server" {
  ami             = "ami-04681163a08179f28" # Amazon Linux 2 AMI
  instance_type   = "t2.micro"              # Instance type
  key_name        = "Ec2-DockerKeypair"     # Replace with your EC2 key pair name
  security_groups = ["launch-wizard-1"]     # Replace with your security group (as a list)

  tags = {
    Name = "k3s-server1"
  }

   # User data script to install k3s and deploy your Kubernetes manifests
  user_data = <<-EOF
              #!/bin/bash
              set -e  # Exit script on any error

              # Install k3s
              echo "Installing k3s..."
              curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_SELINUX_RPM=true sh - || { echo "k3s installation failed"; exit 1; }

              # Configure kubectl
              echo "Configuring kubectl..."
              mkdir -p ~/.kube
              sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
              sudo chown $(id -u):$(id -g) ~/.kube/config
              export KUBECONFIG=~/.kube/config
              echo 'export KUBECONFIG=~/.kube/config' >> ~/.bashrc

              # Add k3s kubectl to PATH
              export PATH=$PATH:/usr/local/bin
              echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc

              # Wait for k3s to be ready
              echo "Waiting for k3s to be ready..."
              until kubectl get nodes; do
                echo "Retrying in 5 seconds..."
                sleep 5
              done

              # Apply deployment.yaml
              echo "Applying deployment.yaml..."
              kubectl apply -f /tmp/deployment.yaml || { echo "Failed to apply deployment.yaml"; exit 1; }

              # Apply service.yaml
              echo "Applying service.yaml..."
              kubectl apply -f /tmp/service.yaml || { echo "Failed to apply service.yaml"; exit 1; }

              echo "k3s setup and deployment completed successfully."
              EOF

  # Copy deployment.yaml and service.yaml to the EC2 instance
  provisioner "file" {
    source      = "deployment.yaml"
    destination = "/tmp/deployment.yaml"
  }

  provisioner "file" {
    source      = "service.yaml"
    destination = "/tmp/service.yaml"
  }

  # Ensure the files are copied before running the user_data script
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/basil/OneDrive/Desktop/Terraform Project/k3/docker-ec2key.pem") # Replace with the path to your private key
    host        = self.public_ip
  }
}

# Output the public IP of the EC2 instance
output "k3s_server_public_ip" {
  value = aws_instance.k3s_server.public_ip
}