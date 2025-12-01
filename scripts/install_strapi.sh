#!/bin/bash
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "=== Starting Strapi Installation ==="

# Update system
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

# Install Node.js 20.x
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs build-essential

echo "Node version: $(node --version)"
echo "NPM version: $(npm --version)"

# Install PM2 globally
npm install -g pm2

# Create app directory
mkdir -p /home/ubuntu/strapi-app
cd /home/ubuntu/strapi-app

# Create Strapi as root, then fix permissions
echo "n" | npx -y create-strapi-app@latest my-strapi-project \
  --quickstart \
  --skip-cloud \
  --no-run

cd my-strapi-project

# Fix ownership
chown -R ubuntu:ubuntu /home/ubuntu/strapi-app

# Generate secrets
APP_KEY1=$(openssl rand -base64 32)
APP_KEY2=$(openssl rand -base64 32)
APP_KEY3=$(openssl rand -base64 32)
APP_KEY4=$(openssl rand -base64 32)
API_TOKEN=$(openssl rand -base64 32)
ADMIN_JWT=$(openssl rand -base64 32)
TRANSFER_TOKEN=$(openssl rand -base64 32)
JWT_SECRET=$(openssl rand -base64 32)

# Create .env file
cat > .env << EOF
HOST=0.0.0.0
PORT=1337
APP_KEYS=${APP_KEY1},${APP_KEY2},${APP_KEY3},${APP_KEY4}
API_TOKEN_SALT=${API_TOKEN}
ADMIN_JWT_SECRET=${ADMIN_JWT}
TRANSFER_TOKEN_SALT=${TRANSFER_TOKEN}
JWT_SECRET=${JWT_SECRET}
NODE_ENV=production
EOF

chown ubuntu:ubuntu .env

# Start with PM2 in development mode (allows content type creation)
sudo -u ubuntu pm2 start npm --name strapi -- run develop
sudo -u ubuntu pm2 startup systemd -u ubuntu --hp /home/ubuntu | grep "sudo" | bash
sudo -u ubuntu pm2 save

echo "=== Strapi Installation Complete ==="
echo "Access: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):1337/admin"
