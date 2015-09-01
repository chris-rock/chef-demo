FROM	ubuntu
MAINTAINER Christoph Hartmann <chris@lollrock.com>

ENV	DEBIAN_FRONTEND noninteractive
RUN	apt-get update
RUN apt-get install -y wget
RUN cd /tmp && wget https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/10.04/x86_64/chef_12.4.1-1_amd64.deb
RUN dpkg -i /tmp/chef_12.4.1-1_amd64.deb

RUN apt-get install -y curl

RUN mkdir -p /etc/chef
VOLUME /shared/

# run chef all 5 min
CMD cp -r /shared/* /etc/chef/ && chef-client --logfile /var/log/chef-client.log && chef-client --daemonize --logfile /var/log/chef-client.log --interval 300 && tail -f /var/log/chef-client.log
