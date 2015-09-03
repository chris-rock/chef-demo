# -*- mode: ruby -*-
# vi: set ft=ruby :

# ensures the .cache dir is available
require 'fileutils'
FileUtils.mkdir_p '.cache'

Vagrant.configure(2) do |config|

  config.vm.define "server" do |server|
    server.vm.box = "bento/ubuntu-14.04"
    server.vm.hostname = "chef-server"
    server.vm.network "private_network", ip: "192.168.34.10"
    server.vm.synced_folder "./shared", "/vagrant"
    server.vm.synced_folder "./.cache", "/downloads"
    server.vm.provision "shell", inline: $setup_server_script

    server.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 2
    end

  end

  config.vm.define "analytics" do |analytics|
    analytics.vm.box = "bento/ubuntu-14.04"
    analytics.vm.hostname = "chef-analytics"
    analytics.vm.network "private_network", ip: "192.168.34.11"
    analytics.vm.synced_folder "./shared", "/vagrant"
    analytics.vm.synced_folder "./.cache", "/downloads"
    analytics.vm.provision "shell", inline: $setup_analytics_script

    analytics.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 2
    end
  end
end

$setup_server_script = <<SETUP_CHEF_SERVER
# install chef server
echo "Install Chef Server"
if [ ! -f /downloads/chef-server-core_12.1.2-1_amd64.deb ]; then
  wget -P /downloads https://web-dl.packagecloud.io/chef/stable/packages/ubuntu/trusty/chef-server-core_12.1.2-1_amd64.deb
fi

dpkg -i /downloads/chef-server-core_12.1.2-1_amd64.deb
chef-server-ctl reconfigure

# install chef manage
echo "Install Chef Manage"
chef-server-ctl install opscode-manage
chef-server-ctl reconfigure
opscode-manage-ctl reconfigure

# apply fix https://github.com/chef/chef-server/pull/465
cp -f /vagrant/sv-oc_id-run.erb /opt/opscode/embedded/cookbooks/private-chef/templates/default/sv-oc_id-run.erb

# create admin user
echo "Create admin and organization"
chef-server-ctl user-create admin Bob Admin admin@example.com insecurepassword --filename adminkey.pem
# create org
chef-server-ctl org-create brewinc "Brew, Inc." --association_user admin --filename brewinc-validator.pem

# sync admin and validator key
cp -f /home/vagrant/adminkey.pem /vagrant
cp -f /home/vagrant/brewinc-validator.pem /vagrant

# configure chef server with analytics
echo "Prepare Chef Server for Analytics integration"
chef-server-ctl stop
cp /vagrant/chef-server.rb /etc/opscode/chef-server.rb
chef-server-ctl reconfigure
cp -rf /etc/opscode-analytics /vagrant
chef-server-ctl start
SETUP_CHEF_SERVER

$setup_analytics_script = <<SETUP_ANALYTICS
# install chef server
echo "Install Chef Analytics"
if [ ! -f /downloads/opscode-analytics_1.1.6-1_amd64.deb ]; then
  wget -P /downloads https://web-dl.packagecloud.io/chef/stable/packages/ubuntu/trusty/opscode-analytics_1.1.6-1_amd64.deb
fi

dpkg -i /downloads/opscode-analytics_1.1.6-1_amd64.deb

echo "Configure Chef Analytics with Chef Server"
# copy config files
cp -rf /vagrant/opscode-analytics /etc/opscode-analytics
cp -f /vagrant/opscode-analytics.rb /etc/opscode-analytics

# replace fqdn with ip
sed -i -e 's/chef-server/192.168.34.10/g' /etc/opscode-analytics/actions-source.json

# reconfigure chef analytics
opscode-analytics-ctl reconfigure
# we do not need the inflight checks here
# opscode-analytics-ctl preflight-check
opscode-analytics-ctl test
SETUP_ANALYTICS
