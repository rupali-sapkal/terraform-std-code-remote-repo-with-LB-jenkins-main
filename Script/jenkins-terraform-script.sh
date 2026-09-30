#!/bin/bash

echo "🔹 Updating system..."
sudo apt update

echo "🔹 Installing Java (Required for Jenkins)..."
sudo apt install -y fontconfig openjdk-21-jre
java -version

echo "🔹 Adding Jenkins repository key..."
sudo mkdir -p /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "🔹 Adding Jenkins repository..."
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" | \
sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "🔹 Installing Jenkins..."
sudo apt update
sudo apt install -y jenkins

echo "🔹 Starting Jenkins service..."
sudo systemctl start jenkins
sudo systemctl enable jenkins

echo "🔹 Jenkins installed successfully!"
echo "➡️ Access Jenkins at: http://<EC2-PUBLIC-IP>:8080"

echo "🔹 Fetching Jenkins Admin Password..."
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# ----------------------------
# Terraform Installation
# ----------------------------

echo "🔹 Installing dependencies for Terraform..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y gnupg software-properties-common curl

echo "🔹 Adding HashiCorp GPG key..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

echo "🔹 Adding HashiCorp repository..."
sudo apt-add-repository \
"deb https://apt.releases.hashicorp.com $(lsb_release -cs) main"

echo "🔹 Installing Terraform..."
sudo apt update
sudo apt install -y terraform

echo "🔹 Verifying Terraform installation..."
terraform -version

echo "✅ Setup Completed Successfully!"

