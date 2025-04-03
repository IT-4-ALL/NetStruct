#!/bin/bash

# NetStruct Setup Script by Philipp Schmid
# MIT License

echo "🐍 Checking for Python..."
if command -v python3 &>/dev/null; then
    echo "✅ Python3 is installed."
else
    echo "🔧 Python3 not found. Installing Python3..."
    sudo apt install python3 -y
fi

if ! command -v python &>/dev/null; then
    echo "🔗 Creating symlink: python -> python3"
    sudo ln -s /usr/bin/python3 /usr/bin/python
else
    echo "✅ 'python' command is already available."
fi

echo "🔄 Updating package list..."
sudo apt update -y

echo "📦 Installing Apache2, PHP, wget, unzip..."
sudo apt install apache2 php wget unzip -y

echo "🔁 Restarting Apache2..."
sudo systemctl stop apache2
sudo systemctl start apache2

echo "🌐 Downloading NetStruct zip file..."
cd /tmp
wget -O netstruct.zip "https://github.com/IT-4-ALL/NetStruct/raw/main/netstruct.zip"

echo "📁 Extracting to /var/www/html..."
sudo unzip -o netstruct.zip -d /var/www/html

echo "🛠️ Setting ownership to root:www-data..."
sudo chown -R root:www-data /var/www/html

echo "🔐 Setting full permissions on /var/www/html/drag..."
sudo chmod -R 777 /var/www/html/drag

echo "🕓 Adding @reboot cronjob for Python script..."
CRONLINE='@reboot sleep 20 && /usr/bin/python /var/www/html/drag/python/start.py'
(crontab -l 2>/dev/null | grep -v -F "$CRONLINE" ; echo "$CRONLINE") | crontab -

echo "🧼 Cleaning up..."
rm netstruct.zip

# IP Detection
IP=$(hostname -I | awk '{print $1}')

echo ""
echo "✅ NetStruct has been installed successfully!"
echo "🔁 Please restart your system to apply all settings:"
echo "    sudo reboot"
echo ""
echo "🌐 After reboot, open:"
echo "    http://$IP/drag/index.html"
