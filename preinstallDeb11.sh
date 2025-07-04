#!/bin/bash
sudo true

echo "-------------------- Checking OS version --------------------"
source /etc/os-release

if [[ "$ID" != "debian" || "$VERSION_ID" != "11" ]]; then
    echo "❌ This script is intended only for Debian 11. Exiting."
    exit 1
fi

echo "✅ Debian 11 confirmed."

echo "-------------------- Updating system --------------------"
sudo apt update && sudo apt upgrade -y
if [ $? -ne 0 ]; then
    echo "❌ Failed to update system packages. Exiting."
    exit 1
fi

echo "-------------------- Installing essential base tools --------------------"
sudo apt install -y vim nano curl wget unzip lsof apt-transport-https ca-certificates gnupg lsb-release
if [ $? -ne 0 ]; then
    echo "❌ Failed to install base tools. Exiting."
    exit 1
fi

echo "-------------------- Setting up Docker repository --------------------"
sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
if [ $? -ne 0 ]; then
    echo "❌ Failed to download and save Docker GPG key. Exiting."
    exit 1
fi

echo \
 "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
 $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
if [ $? -ne 0 ]; then
    echo "❌ Failed to add Docker repository. Exiting."
    exit 1
fi

echo "-------------------- Installing Docker --------------------"
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
if [ $? -ne 0 ]; then
    echo "❌ Failed to install Docker. Exiting."
    exit 1
fi

echo "-------------------- Disabling IPv6 in Docker --------------------"
sudo mkdir -p /etc/docker
echo '{ "dns": ["8.8.8.8", "8.8.4.4"], "ipv6": false }' | sudo tee /etc/docker/daemon.json > /dev/null

echo "Restarting Docker service..."
sudo systemctl enable docker
sudo systemctl restart docker

if ! systemctl is-active --quiet docker; then
    echo "⚠️ Docker service did not start properly. You may need to check logs: sudo journalctl -u docker"
else
    echo "✅ Docker service is running with IPv6 disabled."
fi

echo "-------------------- Installing Microsoft package repository for .NET --------------------"
wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
if [ $? -ne 0 ]; then
    echo "❌ Failed to download Microsoft package config. Exiting."
    exit 1
fi

sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

sudo apt update

echo "-------------------- Installing .NET SDK 6 --------------------"
sudo apt install -y dotnet-sdk-6.0
if [ $? -ne 0 ]; then
    echo "❌ Failed to install .NET SDK. Exiting."
    exit 1
fi

echo "-------------------- Final verification --------------------"
echo ""
docker --version || echo "⚠️ Docker version check failed."
dotnet --version || echo "⚠️ .NET SDK version check failed."
echo ""
echo "Base tools installed: vim, nano, curl, wget, unzip, lsof ✔️"
echo "Docker installed, configured, and checked ✔️"
echo ".NET SDK installed and checked ✔️"
echo ""
echo "✅ Pre-install preparation finished successfully. You can now run your project's install.sh script next."
