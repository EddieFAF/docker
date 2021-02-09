#!/bin/bash

DOCKERDIR=/opt/docker

container_start () {
    cd $DOCKERDIR/$1/
    docker-compose -f $DOCKERDIR/$1/docker-compose.yml up -d
}

### Bitwarden
container_start bitwarden

### Clarkson
container_start clarkson

### Collabora
container_start collabora

### DIUN
container_start diun

### FreshRSS
container_start freshrss

### Frontail
container_start frontail

### Grafana
container_start grafana

### Grocy
container_start grocy

### InfluxDB
container_start influxdb

### Jellyfin
container_start jellyfin

### Jitsi
container_start jitsi

### MariaDB
container_start mariadb

### Mosquitto
container_start mosquitto

### Nextcloud
container_start nc

### OpenVPN
container_start openvpn

### Paperless
container_start paperless-ng

### PHPmyAdmin
container_start phpmyadmin

### Portainer
container_start portainer

### Redis
container_start redis

### Traefik
container_start traefik

### TTrss
container_start ttrss

##EOF

