#!/bin/sh
#mac
#LOCAL_IP=$(ifconfig en0 | grep 'inet ' | cut -d: -f2 | awk '{ print $2}')

#linux
LOCAL_IP=$(ifconfig eth0 | grep 'inet ' | cut -d: -f2 | awk '{ print $1}')

#cat docker-compose.yml.template | sed -e 's/#LOCAL_IP#/'"$LOCAL_IP"'/g' > docker-compose.yml
#cat auth_config.yml.template | sed -e 's/#LOCAL_IP#/'"$LOCAL_IP"'/g' > auth_config.yml
#cat .env.template | sed -e 's/#LOCAL_IP#/'"$LOCAL_IP"'/g' > .env
docker-compose stop
docker-compose rm -f
docker-compose up -d
