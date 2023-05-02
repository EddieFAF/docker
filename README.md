# WARNING!!
This README is seriously outdated!!

## docker
docker related files

Here I collect everything related to Docker.

All services use either traefik as reverse proxy or are only used locally (no proxy).

The services using traefik depend on traefik running (obviously) and the labels use middlewares etc
defined in the traefik config.

### Installation
All traefik services use a docker network called t2_proxy. To create this network use:

