#!/bin/bash

# Update packages
dnf update -y

# Install Nginx
dnf install -y nginx

# Start Nginx
systemctl start nginx

# Enable Nginx after reboot
systemctl enable nginx

# Create a custom webpage
echo "<h1>Hello from Terraform User Data!</h1>" > /usr/share/nginx/html/index.html