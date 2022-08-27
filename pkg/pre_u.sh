#!/bin/bash
# Pre_u script
# Created by Y.G., https://sys-adm.in

# Envs
# ---------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

_USER=redis-exporter
BINARY_DEST=/usr/local/bin/redis_exporter

systemctl stop redis_exporter.service
