#
# Aerospike Server Dockerfile
#
# http://github.com/aerospike/aerospike-server.docker
#

FROM ubuntu:14.04

# Add Aerospike package and run script
ADD http://aerospike.com/download/server/3.3.21/artifact/ubuntu12 /tmp/aerospike.tgz

# Work from /tmp
WORKDIR /tmp

# Install Aerospike
RUN \
  apt-get update -y \
  && tar xzf aerospike.tgz \
  && cd aerospike-server-community-* \
  && sudo dpkg -i aerospike-server-*

#To build AMC
RUN apt-get install -y build-essential python-dev python-pip man

#AMC
ADD http://www.aerospike.com/download/amc/3.4.6/artifact/ubuntu12 /tmp/amc.deb

RUN \
  dpkg -i amc.deb \
  && rm amc.deb

#Runit
RUN apt-get install -y runit


# Add the Aerospike configuration specific to this dockerfile
ADD aerospike.conf /etc/aerospike/aerospike.conf

#Add runit services
ADD sv /etc/service

# Mount the Aerospike data directory
VOLUME ["/opt/aerospike/data"]

# Expose Aerospike ports
#
#   3000 – service port, for client connections
#   3001 – fabric port, for cluster communication
#   3002 – mesh port, for cluster heartbeat
#   3003 – info port
#   8081 - AMC port
#
EXPOSE 3000 3001 3002 3003 8081

ENTRYPOINT ["/usr/sbin/runsvdir-start"]
