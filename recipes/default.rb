#
# Cookbook Name:: cookbook_pusher
# Recipe:: default
#
# Copyright 2013, computerlyrik
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# make path in the userdir, if no run on server

unless Chef::Config[:solo]
  path = '/cookbook_pusher'
else
  path = "#{node['cookbook_pusher']['solo_dir']}/cookbook_pusher"
end

node.set['cookbook_pusher']['path'] = path

directory path

# opscode key
template "#{path}/auth.pem" do
  variables(
    authkey: node['cookbook_pusher']['authkey']
  )
end

template "#{path}/knife.rb" do
  variables(
    path: path,
    opscode_name: node['cookbook_pusher']['opscode_name']
  )
end

directory "#{path}/cookbooks"

############################       automagic

include_recipe 'git'

chef_gem 'octokit' do
  compile_time false if respond_to?(:compile_time)
end

Chef::Recipe.send(:include, RepositoryHelper)
push("#{node['cookbook_pusher']['prefix']}+user:#{node['cookbook_pusher']['github_name']}")

