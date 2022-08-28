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
BINARY_DEST=/usr/local/bin/redis_exporter

# Funcs
# ---------------------------------------------------\
service_active() {
    local n=$1
    if [[ $(systemctl list-units --type=service --state=active | grep $n.service | sed 's/^\s*//g' | cut -f1 -d' ') == $n.service ]]; then
        return 0
    else
        return 1
    fi
}

# Acts
# ---------------------------------------------------\
# Checking Redis user exists
if ! id -u "$_USER" >/dev/null 2>&1; then
    useradd -s /sbin/nologin -c "Redis Exporter User" -d /var/lib/redis-exporter -r -M ${_USER}
fi

# Final steps
chown -R -L ${_USER}:${_USER} ${BINARY_DEST}
systemctl --system daemon-reload

systemctl enable --now $_SERVICE.service

# Additional checking: start if not active
if ! service_active "$_SERVICE"; then
    systemctl start $_SERVICE.service
fi
