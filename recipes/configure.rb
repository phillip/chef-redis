#
# Author:: Phillip Goldenburg <phillip.goldenburg@sailpoint.com>
# Cookbook Name:: redis
# Recipe:: configure
#
# Copyright 2012, Phillip Goldenburg
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

if node['redis']['source']['create_service']
  node.set['redis']['daemonize'] = "yes"
  if node['redis']['source']['init_style'] == "init"
    service "redis" do
      supports  :status => false, :restart => false, :reload => false
      action    :nothing
    end
  elsif node['redis']['source']['init_style'] == "upstart"
    service "redis" do
      provider Chef::Provider::Service::Upstart
      action :nothing
    end
  end
end
  
gte_2_6 = Gem::Version.new(node['redis']['source']['version']) >= Gem::Version.new('2.6.0')
  
template "/etc/redis/#{node['redis']['port']}.conf" do
  source  (gte_2_6 ? "redis-2.6.conf.erb" : "redis.conf.erb")
  owner   "root"
  group   "root"
  mode    "0644"

  notifies :restart, "service[redis]"
end
