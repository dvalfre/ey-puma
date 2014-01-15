#
# Cookbook Name:: puma
# Recipe:: default
#

include_recipe 'puma::service'
include_recipe 'puma::setup'
include_recipe 'puma::cleanup'