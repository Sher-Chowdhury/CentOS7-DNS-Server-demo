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

cp /etc/named.conf /etc/named.conf-orig 
sed -i 's/127.0.0.1/any/g' /etc/named.conf
sed -i 's/localhost/any/g' /etc/named.conf
sed -i 's/dnssec-validation yes/dnssec-validation no/g' /etc/named.conf

echo 'OPTIONS="-4"' > /etc/sysconfig/named


systemctl enable named
systemctl restart named

firewall-cmd --permanent --add-service=dns
systemctl restart firewalld.service


exit 0