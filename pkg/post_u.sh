#!/bin/bash
# Post_u
# Created by Y.G., https://sys-adm.in

set -e

# Envs
# ---------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

_USER=redis-exporter
_SERVICE=redis_exporter

service_active() {
    local n=$1
    if [[ $(systemctl list-units --type=service --state=active | grep $n.service | sed 's/^\s*//g' | cut -f1 -d' ') == $n.service ]]; then
        return 0
    else
        return 1
    fi
}

if service_active "$_SERVICE"; then
    systemctl stop $_SERVICE.service
fi

systemctl --system daemon-reload;
getent passwd $_USER > /dev/null 2&>1

if [ $? -eq 0 ]; then
    userdel -f ${_USER}
fi
