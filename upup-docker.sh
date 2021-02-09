#!/bin/bash

### Bitwarden
cd /opt/docker/bitwarden/
docker-compose -f /opt/docker/bitwarden/docker-compose.yml up -d

### Clarkson
cd /opt/docker/clarkson/
docker-compose -f /opt/docker/clarkson/docker-compose.yml up -d

### Collabora
cd /opt/docker/collabora/
docker-compose -f /opt/docker/collabora/docker-compose.yml up -d

### DIUN
cd /opt/docker/diun/
docker-compose -f /opt/docker/diun/docker-compose.yml up -d

### FreshRSS
cd /opt/docker/freshrss/
docker-compose -f /opt/docker/freshrss/docker-compose.yml up -d

### Frontail
cd /opt/docker/frontail/
docker-compose -f /opt/docker/frontail/docker-compose.yml up -d

### Grafana
cd /opt/docker/grafana/
docker-compose -f /opt/docker/grafana/docker-compose.yml up -d

### Grocy
cd /opt/docker/grocy/
docker-compose -f /opt/docker/grocy/docker-compose.yml up -d

### InfluxDB
cd /opt/docker/influxdb/
docker-compose -f /opt/docker/influxdb/docker-compose.yml up -d

### Jellyfin
cd /opt/docker/jellyfin/
docker-compose -f /opt/docker/jellyfin/docker-compose.yml up -d

### Jitsi
cd /opt/docker/jitsi/
docker-compose -f /opt/docker/jitsi/docker-compose.yml up -d

### MariaDB
cd /opt/docker/mariadb/
docker-compose -f /opt/docker/mariadb/docker-compose.yml up -d

### Mosquitto
cd /opt/docker/mosquitto/
docker-compose -f /opt/docker/mosquitto/docker-compose.yml up -d

### Nextcloud
cd /opt/docker/nc/
docker-compose -f /opt/docker/nc/docker-compose.yml up -d

### OpenVPN
cd /opt/docker/openvpn/
docker-compose -f /opt/docker/openvpn/docker-compose.yml up -d

### Paperless
cd /opt/docker/paperless-ng/
docker-compose -f /opt/docker/paperless-ng/docker-compose.yml up -d

### PHPmyAdmin
cd /opt/docker/phpmyadmin/
docker-compose -f /opt/docker/phpmyadmin/docker-compose.yml up -d

### Portainer
cd /opt/docker/portainer/
docker-compose -f /opt/docker/portainer/docker-compose.yml up -d

### Redis
cd /opt/docker/redis/
docker-compose -f /opt/docker/redis/docker-compose.yml up -d

### Traefik
cd /opt/docker/traefik/
docker-compose -f /opt/docker/traefik/docker-compose.yml up -d

### TTrss
cd /opt/docker/ttrss/
docker-compose -f /opt/docker/ttrss/docker-compose.yml up -d

##EOF

