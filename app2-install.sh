#!/bin/bash
# Update & install Apache
sudo yum update -y

# Install Apache with retry logic
until sudo yum install -y httpd; do
  echo "Retrying..."
  sleep 10
done


sudo systemctl enable httpd
sudo systemctl start httpd

# Get IMDSv2 token
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Fetch metadata
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id)

PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/local-ipv4)

# Landing page
sudo tee /var/www/html/index.html > /dev/null <<EOF
<h1>Welcome to my project. - APP-2</h1>
EOF

# App2 demo page
sudo mkdir -p /var/www/html/app2
sudo tee /var/www/html/app2/index.html > /dev/null <<EOF
<!DOCTYPE html>
<html>
<body style="background-color:rgb(150, 10, 100);">
  <h1>Path based routing demo - APP-2</h1>
  <p>Terraform Demo</p>
  <p>Application Version: V1</p>
</body>
</html>
EOF

# Metadata page
sudo tee /var/www/html/app2/metadata.html > /dev/null <<EOF
<!DOCTYPE html>
<html>
  <head>
    <title>Instance Metadata</title>
  </head>
  <body style='background-color: #e6f2ff;'>
    <h1>Load Balancer Test</h1>
    <h2>Instance ID: $INSTANCE_ID</h2>
    <h3>Private IP: $PRIVATE_IP</h3>
  </body>
</html>
EOF