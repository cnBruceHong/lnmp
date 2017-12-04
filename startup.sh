#!/usr/bin/env bash
docker run -d -v $1:/home/web/code -P -p 80:80 --name $2 brucehong/php-dev