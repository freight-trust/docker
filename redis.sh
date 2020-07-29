
#!/bin/bash
set -e
source buildconfig

header "Installing Redis..."

## Install Redis.
run apt-get install -y redis-server libhiredis-dev
run mkdir /etc/service/redis
run cp /runit/redis /etc/service/redis/run
run cp /config/redis.conf /etc/redis/redis.conf
run touch /etc/service/redis/down