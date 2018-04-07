#!/usr/bin/env bash
# exit 0
set -ex

echo '##########################################################################'
echo '##### About to run setup-setup-caching-only-dns-server.sh script #########'
echo '##########################################################################'


setenforce enforcing
systemctl start firewalld
systemctl enable firewalld



yum install -y bind



systemctl enable named
systemctl start named







exit 0