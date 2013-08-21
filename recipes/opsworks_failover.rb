#
# Author:: Phillip Goldenburg <phillip.goldenburg@sailpoint.com>
# Cookbook Name:: redis
# Recipe:: opsworks_failover
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

layers = node[:opsworks][:instance][:layers]
layer_name = layers.select{|l| l.include?("redis") }.first || layers.first
oldest_host = node[:opsworks][:layers][layer_name.to_sym][:instances].sort_by{ |k, v| v[:booted_at] }.first[0]
if oldest_host == node[:opsworks][:instance][:hostname]
  bash "set_master" do
    user "root"
    code <<-EOH
    sed -i s/^slaveof.*//g /etc/redis/#{node['redis']['port']}.conf
    echo 'SLAVEOF NO ONE' | #{ node['redis']['source']['prefix'] }/bin/redis-cli
    EOH
  end
else
  bash "set_slave" do
    user "root"
    code <<-EOH
    echo 'slaveof #{oldest_host} 6379' | tee -a /etc/redis/#{node['redis']['port']}.conf
    echo 'SLAVEOF #{oldest_host} 6379' | #{ node['redis']['source']['prefix'] }/bin/redis-cli
    EOH
  end
end