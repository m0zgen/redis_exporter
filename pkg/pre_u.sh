#!/bin/bash
# Pre_u script
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

if service_exists "$_USER"; then
    systemctl stop "$_USER".service
fi
