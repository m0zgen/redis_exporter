#!/bin/bash
# Go binary builder
# Created by Y.G., https://sys-adm.in

set -e 

# Envs
# ---------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

_USER=redis-exporter
BINARY_DEST=/usr/local/bin/redis_exporter

# Checking exists
service_exists() {
    local n=$1
    if [[ $(systemctl list-units --all -t service --full --no-legend "$n.service" | sed 's/^\s*//g' | cut -f1 -d' ') == $n.service ]]; then
        return 0
    else
        return 1
    fi
}

# Checking Redis user exists
if ! id -u "$_USER" >/dev/null 2>&1; then
    useradd -s /sbin/nologin -c "Redis Exporter User" -d /var/lib/redis -r -M ${_USER}
fi

# Final steps
chown -R -L ${_USER}:${_USER} ${BINARY_DEST}
systemctl --system daemon-reload

if service_exists "$_USER"; then
    systemctl enable --now redis_exporter
fi
