#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package 'nginx' do
  action :install
end

service 'nginx' do
  action [ :enable, :start ]
end
directory '/etc/nginx/certs' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end
aws_s3_file '/etc/nginx/certs/server_certificate.pem' do
  bucket 'awsintuit'
  remote_path 'server_certificate.pem'
  region 'us-east-1'
  notifies :restart, 'service[nginx]'

end
aws_s3_file '/etc/nginx/certs/server_privatekey.pem' do
  bucket 'awsintuit'
  remote_path 'server_privatekey.pem'
  region 'us-east-1'
  notifies :restart, 'service[nginx]'
end

cookbook_file "/etc/nginx/nginx.conf" do
  source "nginx.conf"
  mode "0644"
  notifies :restart, 'service[nginx]'
end

