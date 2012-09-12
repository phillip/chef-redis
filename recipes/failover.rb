#
# Author:: Phillip Goldenburg <phillip.goldenburg@sailpoint.com>
# Cookbook Name:: redis
# Recipe:: failover
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

gem_package "zk"
package "curl"

directory "/opt/bin" do
  owner "root"
  group "root"
  mode "0775"
  recursive true
end

template "/opt/bin/zk_client" do
  source "zk_client.rb.erb"
  mode "0744"
  owner "root"
  group "root"
end

if node['platform'] == "ubuntu"
  template "/etc/init/zk_client.conf" do
    source "zk_client_upstart.erb"
    mode "0744"
    owner "root"
    group "root"
  end
  
  service "zk_client" do
    provider Chef::Provider::Service::Upstart
    action :enable
  end
end