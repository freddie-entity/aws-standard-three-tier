#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo service httpd start  
export INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
echo "<html><body><h1>ENRICH | Instance ID: <b>"$INSTANCE_ID"</b></h1></body></html>" > /var/www/html/index.html