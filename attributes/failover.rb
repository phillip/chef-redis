#
# Author:: Phillip Goldenburg <phillip.goldenburg@sailpoint.com>
# Cookbook Name:: redis
# Attributes:: failover
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

#default["zookeeper"]["server_list"] = []
default['redis']['failover']['cluster_name'] = "default"
default['redis']['failover']['get_hostname_cmd'] = "curl -s http://169.254.169.254/latest/meta-data/public-hostname" # or hostname