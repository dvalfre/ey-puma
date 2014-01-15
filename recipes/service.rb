#
# Cookbook Name:: puma
# Recipe:: service
#

service "nginx" do
  supports :reload => true
end
