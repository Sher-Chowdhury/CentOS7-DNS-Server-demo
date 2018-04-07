#!/usr/bin/env bash
# exit 0
set -ex

echo '##########################################################################'
echo '##### About to run setup-kerberos-client.sh script #############'
echo '##########################################################################'

setenforce enforcing
systemctl start firewalld
systemctl enable firewalld


