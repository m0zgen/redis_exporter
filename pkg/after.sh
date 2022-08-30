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
_SERVICE_HOME=/var/lib/redis-exporter
_REDIS_USER=redis
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

    if [[ ! -d "$_SERVICE_HOME" ]]; then
        mkdir -p "$_SERVICE_HOME"
    fi
    useradd -s /sbin/nologin -c "Redis Exporter User" -d /var/lib/redis-exporter -r -M ${_USER}
    # id -u redis-exporter &> /dev/null || /usr/sbin/useradd -s /sbin/nologin -r -M redis-exporter
fi

if id -u "$_REDIS_USER" >/dev/null 2>&1; then
    usermod -a -G "$_REDIS_USER" "$_USER"
fi

# Final steps
chown -R -L ${_USER}:${_USER} ${BINARY_DEST}
sleep 2
chown -R -L ${_USER}:${_USER} ${_SERVICE_HOME}

systemctl --system daemon-reload

systemctl enable --now $_SERVICE.service

# Additional checking: start if not active
if ! service_active "$_SERVICE"; then
    systemctl start $_SERVICE.service
fi
