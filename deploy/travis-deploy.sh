#!/bin/bash
ssh -o "StrictHostKeyChecking no" ubuntu@$AWS_IP env \
TAG=0.1.$TRAVIS_BUILD_NUMBER \
DOCKER_USER=$DOCKER_USER \
DOCKER_PASS=$DOCKER_PASS \
RDS_DB_NAME=$RDS_DB_NAME \
RDS_USERNAME=$RDS_USERNAME \
RDS_PASSWORD=$RDS_PASSWORD \
RDS_HOSTNAME=$RDS_HOSTNAME \
RDS_PORT=$RDS_PORT \
DEVISE_SECRET_KEY=$DEVISE_SECRET_KEY \
SECRET_KEY_BASE=$SECRET_KEY_BASE \
'bash -s' <<'ENDSSH'
docker login -u $DOCKER_USER -p $DOCKER_PASS
if [ $(docker ps -a | wc | awk '{ print $1 }') -gt 0 ]
then
  docker rm -f $(docker ps -aq)
fi
if [ $(docker images -q | wc | awk '{ print $1 }') -gt 0 ]
then
  docker rmi -f $(docker images -q)
fi
docker run -d -p 80:3000 --name excella-feedback \
  -e "RAILS_ENV=production" \
  -e "DEVISE_SECRET_KEY=$DEVISE_SECRET_KEY" \
  -e "RDS_DB_NAME=$RDS_DB_NAME" \
  -e "RDS_USERNAME=$RDS_USERNAME" \
  -e "RDS_PASSWORD=$RDS_PASSWORD" \
  -e "RDS_HOSTNAME=$RDS_HOSTNAME" \
  -e "RDS_PORT=$RDS_PORT" \
  -e "SECRET_KEY_BASE=$SECRET_KEY_BASE" \
  taejunyun/excella-fb:$TAG
ENDSSH
