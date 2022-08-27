#!/bin/bash
# Go binary builder, fpm builder
# Created by Y.G., https://sys-adm.in

# Envs
# ---------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
cd $SCRIPT_PATH

# Vars
# ---------------------------------------------------\
BIN_PATH="$SCRIPT_PATH/pkg"
BIN_NAME="redis_exporter"
BIN_VER=1.44.2
GIT_HASH=$(git rev-parse --short HEAD)
PACKAGES='rpm deb'
PACKAGES_PATH="$SCRIPT_PATH/pkgs"
AFTER="$SCRIPT_PATH/pkg/after.sh"
PRE_U="$SCRIPT_PATH/pkg/pre_u.sh"
POST_U="$SCRIPT_PATH/pkg/post_u.sh"



# Acts
# ---------------------------------------------------\
getDate() {
    date '+%d-%m-%Y_%H-%M-%S'
}

ifFpm() {
    
    for i in ${PACKAGES}; do
         fpm -s dir -t "$i" --name "$BIN_NAME" --version "$BIN_VER" \
         --iteration 1 -a x86_64 -f --prefix=/ --template-scripts --rpm-os linux --provides "$BIN_NAME" \
         --vendor "S-A Lab" --url "https://lab.sys-adm.in" --description "Redis Exporter" \
         --after-install ${AFTER} --pre-uninstall ${PRE_U} --post-uninstall ${POST_U} \
         -p pkgs pkg/"$BIN_NAME"=/usr/local/bin/ pkg/"$BIN_NAME".template=/usr/lib/systemd/system/"$BIN_NAME".service
    done
}

makeBin() {

    echo -e "\nBuilding: - $BIN_PATH"

    if [[ ! -d "$BIN_PATH" ]]; then
        mkdir $BIN_PATH
    fi

    env GOOS=linux GOARCH=amd64 go build -ldflags "-X 'main.BuildVersion=${BIN_VER}' -X 'main.BuildCommitSha=${GIT_HASH}' -X 'main.BuildDate=$(getDate)'" -o $BIN_PATH
    echo -e "Binary already ready in ${BIN_PATH}\n"

    if [[ ! -x "$(command -v fpm)" ]]; then \
        # echo 'NO'; \
        exit -1; \
    else
        echo "Making RPM/DEP packages to... Packages in: ${PACKAGES_PATH}"
        ifFpm
    fi


}

makeBin