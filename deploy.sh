#!/bin/bash

# chmod +x script_name.sh
# ./deploy.sh

# 1. Install Git
echo "Installing Git..."
sudo apt update
sudo apt install -y git

# 2. Set Git Credentials (with user input)
echo "Please enter your Git name:"
read git_name
echo "Please enter your Git email:"
read git_email

echo "Setting up Git credentials..."
git config --global user.name "$git_name"
git config --global user.email "$git_email"

# 3. Generate SSH Key (if it doesn't already exist)
SSH_KEY="$HOME/.ssh/id_rsa"
if [ ! -f "$SSH_KEY" ]; then
    echo "Generating SSH key..."
    ssh-keygen -t rsa -b 4096 -C "$git_email" -f $SSH_KEY -N ""
else
    echo "SSH key already exists. Skipping key generation."
fi

# 4. Display the SSH key and prompt user to add it to GitHub
echo "Here is your public SSH key. Please add it to your GitHub account:"
cat "$SSH_KEY.pub"
echo "Visit https://github.com/settings/keys to add your SSH key."

read -p "Press [Enter] once you've added the SSH key to GitHub."

# 5. Test GitHub connection
echo "Testing GitHub connection..."
ssh -T git@github.com

# 7. Docker Setup and Deployment
echo "Setting up Docker..."

# Install Docker if not installed
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Installing Docker..."
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker $USER
else
    echo "Docker is already installed."
fi

echo "Everything is working, lesss get it broski..."