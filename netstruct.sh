#!/bin/bash

# NetStruct Setup Script by Philipp Schmid
# MIT License

echo "🔄 Updating package list..."
sudo apt update -y

echo "📦 Installing Apache2..."
sudo apt install apache2 -y

echo "🐘 Installing PHP (default version)..."
sudo apt install php unzip -y

echo "🔁 Restarting Apache2 to load PHP..."
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

# IP Address detection (local non-loopback)
IP=$(hostname -I | awk '{print $1}')

echo ""
echo "✅ NetStruct has been installed successfully!"
echo "🔁 Please restart your system to apply all settings:"
echo "    sudo reboot"
echo ""
echo "🌐 After reboot, open:"
echo "    http://$IP/drag/index.html"
