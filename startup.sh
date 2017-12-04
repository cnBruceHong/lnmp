#!/usr/bin/env bash
docker run -d -v $1:/root/code -P -p 80:80 --name $2 cnbrucehong/php-dev