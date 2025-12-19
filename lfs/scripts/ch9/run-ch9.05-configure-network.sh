#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_root_user && ensure_chroot

time {
    # Configure the default interface with some hardcoded values
    cat > /etc/sysconfig/ifconfig.eth0 << "EOF"
ONBOOT=yes
IFACE=eth0
SERVICE=ipv4-static
IP=192.168.1.70
GATEWAY=192.168.1.1
PREFIX=24
BROADCAST=192.168.1.255
EOF

    # Configure the DNS using Google public servers
    cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf

nameserver 8.8.8.8
nameserver 8.8.4.4

# End /etc/resolv.conf
EOF

    # Create the hostname as "lfs"
    echo "lfs" > /etc/hostname

    # Configure the default host file
    cat > /etc/hosts << "EOF"
# Begin /etc/hosts

127.0.0.1 localhost.localdomain localhost
# 127.0.1.1 <FQDN> <HOSTNAME>
# <192.168.1.2> <FQDN> <HOSTNAME> [alias1] [alias2 ...]
::1       localhost ip6-localhost ip6-loopback
ff02::1   ip6-allnodes
ff02::2   ip6-allrouters

# End /etc/hosts
EOF
}

} 2>&1 | tee "$LOG_FILE"