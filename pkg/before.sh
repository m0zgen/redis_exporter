#!/bin/bash
# Go binary builder
# Created by Y.G., https://sys-adm.in

# Opts
# ---------------------------------------------------\
set -e 

# Envs
# ---------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

# Vars
# ---------------------------------------------------\
_USER=redis-exporter
_SERVICE=redis_exporter
_SERVICE_OPTS_DIR=/var/lib/redis-exporter
BINARY_DEST=/usr/local/bin/redis_exporter


# if [[ ! -d "$_SERVICE_OPTS_DIR" ]]; then
#     mkdir -p "$_SERVICE_OPTS_DIR"
# fi

# echo "START_OPTS=\"-web.listen-address :9121 -redis.addr redis://127.0.0.1:6379\"" > /var/lib/redis-exporter/env-opts

if [[ -f /usr/lib/systemd/system/redis_exporter.service ]]; then
    id -u redis-exporter &> /dev/null || /usr/sbin/useradd -s /sbin/nologin -r -M redis-exporter
    getent group redis &> /dev/null && usermod -a -G redis redis-exporter
fi