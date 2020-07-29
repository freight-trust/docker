#!/bin/bash
if [[ "$DOCKER_APP_ENV" != "" ]]; then
	echo "docker_app_env '$DOCKER_APP_ENV';" > /etc/nginx/conf.d/00_app_env.conf
fi