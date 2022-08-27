#!/bin/bash
# Go binary builder
# Created by Y.G., https://sys-adm.in

# Envs
# ---------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

_USER=redis-exporter
BINARY_DEST=/usr/local/bin/redis_exporter

# Checking Redis user exists
if ! id -u "$_USER" >/dev/null 2>&1; then
    useradd -s /sbin/nologin -c "Redis Exporter User" -d /var/lib/redis -r -M ${_USER}
fi

# Final steps
chown -R -L ${_USER}:${_USER} ${BINARY_DEST}
systemctl --system daemon-reload; systemctl enable --now redis_exporter
