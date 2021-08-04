#!/bin/bash

DOCKERDIR=/opt/docker

pull_image () {
    cd $DOCKERDIR/$1/
    docker-compose -f $DOCKERDIR/$1/docker-compose.yml pull
}

pull_image bitwarden
pull_image clarkson
pull_image collabora
pull_image diun
pull_image freshrss
pull_image frontail
pull_image grafana
pull_image grocy
pull_image influxdb
pull_image jellyfin
pull_image jitsi
pull_image mariadb
pull_image mosquitto
pull_image nc
pull_image openvpn
pull_image paperless-ng
pull_image phpmyadmin
pull_image portainer
pull_image redis
pull_image traefik
pull_image ttrss

echo
echo "Docker-Update durchgelaufen. Falls keine Fehler aufgetreten sind, jetzt mit './upup-docker.sh' die Container erneuern!"
echo
echo "Wenn die Container laufen (docker ps -a), die Reste der alten mit 'docker system prune' säubern..."
echo
#EOF

