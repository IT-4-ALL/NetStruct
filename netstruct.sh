#!/bin/bash

# NetStruct Setup Script by Philipp Schmid
# MIT License

# 1. Check and install Python if not available
echo "🐍 Checking for Python..."
if command -v python3 &>/dev/null; then
    echo "✅ Python3 is installed."
else
    echo "🔧 Python3 not found. Installing Python3..."
    sudo apt install python3 -y
fi

# 2. Ensure `python` command is available
if ! command -v python &>/dev/null; then
    echo "🔗 Creating symlink: python -> python3"
    sudo ln -s /usr/bin/python3 /usr/bin/python
else
    echo "✅ 'python' command is already available."
fi

# 3. Update package list
echo "🔄 Updating package list..."
sudo apt update -y

# 4. Install Apache2
echo "📦 Installing Apache2..."
sudo apt install apache2 -y

# 5. Install PHP and unzip
echo "🐘 Installing PHP and unzip..."
sudo apt install php unzip -y

# 6. Restart Apache2
echo "🔁 Restarting Apache2..."
sudo systemctl stop apache2
sudo systemctl start apache2

# 7. Download NetStruct zip
echo "🌐 Downloading NetStruct zip file..."
cd /tmp
wget -O netstruct.zip "https://github.com/IT-4-ALL/NetStruct/raw/main/netstruct.zip"

# 8. Extract to /var/www/html
echo "📁 Extracting to /var/www/html..."
sudo unzip -o netstruct.zip -d /var/www/html

# 9. Set permissions
echo "🛠️ Setting ownership to root:www-data..."
sudo chown -R root:www-data /var/www/html

echo "🔐 Setting full permissions on /var/www/html/drag..."
sudo chmod -R 777 /var/www/html/drag

# 10. Add cronjob
echo "🕓 Adding @reboot cronjob for Python script..."
CRONLINE='@reboot sleep 20 && /usr/bin/python /var/www/html/drag/python/start.py'
(crontab -l 2>/dev/null | grep -v -F "$CRONLINE" ; echo "$CRONLINE") | crontab -

# 11. Cleanup
echo "🧼 Cleaning up..."
rm netstruct.zip

# 12. Show access URL
IP=$(hostname -I | awk '{print $1}')

echo ""
echo "✅ NetStruct has been installed successfully!"
echo "🔁 Please restart your system to apply all settings:"
echo "    sudo reboot"
echo ""
echo "🌐 After reboot, open:"
echo "    http://$IP/drag/index.html"
