#This script is intended to be used as user data for an EC2 instance. It will install Apache (httpd) and create a simple web page that displays the hostname of the instance.

#!/bin/bash

# Exit if any command fails
set -e

# Update packages
sudo yum update -y

# Install Apache (httpd)
sudo yum install -y httpd

# Start Apache service
sudo systemctl start httpd

# Enable Apache on boot
sudo systemctl enable httpd

# Create simple web page
echo "This is $(hostname)" | sudo tee /var/www/html/index.html