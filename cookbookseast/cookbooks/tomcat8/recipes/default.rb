#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'aws'
package 'tomcat8' do
  action :install
end
service 'tomcat8' do
  action [ :enable, :start ]
end
aws_s3_file '/usr/share/tomcat8/webapps/demo.war' do
  bucket 'awsintuit'
  remote_path '/application/demo.war'
  region 'us-east-1'
end
aws_s3_file '/usr/share/tomcat8/lib/mysql-connector-java-5.1.41-bin.jar' do
  bucket 'awsintuit'
  remote_path '/application/mysql-connector-java-5.1.41-bin.jar'
  region 'us-east-1'
end
aws_s3_file '/usr/share/tomcat8/lib/tomcat-dbcp-8.0.41.jar' do
  bucket 'awsintuit'
  remote_path '/application/tomcat-dbcp-8.0.41.jar'
  region 'us-east-1'
end
cookbook_file '/etc/tomcat8/server.xml' do
  source 'server.xml'
  owner 'root'
  group 'tomcat'
  mode '0644'
  action :create
  notifies :restart, 'service[tomcat8]', :delayed
end
template '/usr/share/tomcat8/conf/context.xml' do
  source 'context.xml.erb'
  notifies :restart, 'service[tomcat8]', :delayed
  owner 'root'
  group 'tomcat'
  mode '0644'
end
execute "cratetables" do
   command "mysql -u #{node['application']['user']} --password=#{node['application']['password']} -h #{node['application']['dbendpoint']} -e \"SET sql_notes = 0;use intuitappdb;create table IF NOT EXISTS testdata (id int not null auto_increment primary key,foo varchar(25),bar int);insert into testdata (id, foo, bar)SELECT * FROM (SELECT 1,'hello',12345) AS tmp WHERE NOT EXISTS (SELECT id FROM testdata  WHERE id = 1)LIMIT 1;SET sql_notes = 1;\""
end
