#!/bin/bash
sudo yum update -y;
sudo yum install -y httpd;
sudo systemctl start httpd;
sudo systemctl enable httpd;
instance_id=$(sudo curl -s http://169.254.169.254/latest/meta-data/instance-id);
region=$(sudo curl -s http://169.254.169.254/latest/meta-data/placement/region);
availability_zone=$(sudo curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone);
sudo echo '<div><h2>Hello World</h2></div><br>' >> '/var/www/html/index.html';
sudo echo '<div><h2>EC2 Instance Data: </h2></div>' >> '/var/www/html/index.html';
sudo echo '<div><h4>Instance ID: '$instance_id'</h4></div>' >> '/var/www/html/index.html';
sudo echo '<div><h4>Region: '$region'</h4></div>' >> '/var/www/html/index.html';
sudo echo '<div><h4>Availability Zone: '$availability_zone'</h4></div><br>' >> '/var/www/html/index.html';
sudo echo '<div><h2>An Instance of Backend-Generated Content: </h2></div>' >> '/var/www/html/index.html';
sudo echo '<div><h4>Some Random Integer: '$RANDOM'</h4></div><br>' >> '/var/www/html/index.html';
sudo echo '<div><h2>An Instance of Static-Content: </h2></div>' >> '/var/www/html/index.html';
