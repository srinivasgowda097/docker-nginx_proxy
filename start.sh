#!/bin/bash

if [ ! -e /var/run/docker.sock ] ; then
  echo Please map docker socket to /var/run/docker.sock
  exit 1
fi

for container in $(docker ps -q) ; do
  for variable in $(docker inspect --format='{{range $p, $conf := .Config.Env}} {{$conf}} {{end}}' $container) ; do

    key=$(echo $variable | awk -F'=' '{print $1}')
    if [ "$key" == "VIRTUAL_HOST" ] ; then
      container_ip=$(docker inspect --format='{{.NetworkSettings.IPAddress}}' $container)
      vhost=$(echo $variable | awk -F'=' '{print $2}')
      conf=/etc/nginx/conf.d/"$vhost".conf
      echo "server {" > $conf
      echo "  listen 80;" >> $conf
      echo "  server_name $vhost;" >> $conf
      echo "  location / {" >> $conf
      echo "    proxy_set_header X-Real-IP \$remote_addr;" >> $conf
      echo "    proxy_set_header Host \$http_host;" >> $conf
      echo "    proxy_pass http://$container_ip:80;" >> $conf
      echo "  }" >> $conf
      echo "}" >> $conf

    fi
  done
done

