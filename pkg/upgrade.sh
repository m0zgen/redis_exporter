#!/bin/bash
# After upgrade --after-upgrade
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
_REDIS_USER=redis

# Funcs
# ---------------------------------------------------\

id -u redis-exporter &> /dev/null || /usr/sbin/useradd -s /sbin/nologin -r -M redis-exporter
getent group redis &> /dev/null && usermod -a -G redis redis-exporter

