#!/bin/bash

ssh -o "StrictHostKeyChecking no" ubuntu@$AWS_IP env TAG=0.1.$CIRCLE_BUILD_NUM DOCKER_USER=$DOCKER_USER DOCKER_PASS=$DOCKER_PASS 'bash -s' << 'ENDSSH'
  docker login -u $DOCKER_USER -p $DOCKER_PASS
  docker stop excella-feedback
  docker rm excella-feedback
  docker run -d -p 3000:3000 --name excella-feedback -e "RAILS_ENV=production" taejunyun/excella-fb:$TAG
ENDSSH
