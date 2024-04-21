#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SCRIPT_NAME=$(basename "$0")
logger user.info "run $SCRIPT_NAME in $SCRIPT_DIR"


# backup existing sshd_config
BACKUP_FILE_NAME="/etc/ssh/sshd_config.$(date +%s).backup"
cp /etc/ssh/sshd_config "$BACKUP_FILE_NAME"
logger -t "$SCRIPT_NAME" user.debug "sshd_config saved in $BACKUP_FILE_NAME"


# replace initial sshd_config with template one
cp ~/viento/openssh/sshd_config.template /etc/ssh/sshd_config
logger -t "$SCRIPT_NAME" user.debug "sshd_config replaced with template"


# add public keys
mkdir -p ~/.ssh
touch ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

echo '' > ~/.ssh/authorized_keys

for file in ~/viento/pub/*.pub; do
  cat "$file" >> ~/.ssh/authorized_keys
done
logger -t "$SCRIPT_NAME" user.debug "keys copied"


# exit
logger -t "$SCRIPT_NAME" user.info "finish $SCRIPT_NAME in $SCRIPT_DIR with exit code 0"
exit 0
