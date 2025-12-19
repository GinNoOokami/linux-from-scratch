#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="257.3"
PACKAGE_NAME=systemd-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.gz
pushd $PACKAGE_NAME

time {
    # Remove two unneeded groups, render and sgx, from the default udev rules
    sed -e 's/GROUP="render"/GROUP="video"/' \
        -e 's/GROUP="sgx", //'               \
        -i rules.d/50-udev-default.rules.in
    
    # Remove one udev rule requiring a full Systemd installation
    sed -i '/systemd-sysctl/s/^/#/' rules.d/99-systemd.rules.in

    # Adjust the hardcoded paths to network configuration files for the standalone udev installation
    sed -e '/NETWORK_DIRS/s/systemd/udev/' \
        -i src/libsystemd/sd-network/network-util.h

    mkdir -p build
    pushd    build

    meson setup ..                  \
        --prefix=/usr               \
        --buildtype=release         \
        -D mode=release             \
        -D dev-kvm-mode=0660        \
        -D link-udev-shared=false   \
        -D logind=false             \
        -D vconsole=false

    # Get the list of the shipped udev helpers and save it into an environment variable
    export udev_helpers=$(grep "'name' :" ../src/udev/meson.build | awk '{print $3}' | tr -d ",'" | grep -v 'udevadm')

    # Build only the components needed for udev
    # shellcheck disable=SC2046
    ninja udevadm systemd-hwdb                                         \
        $(ninja -n | grep -Eo '(src/(lib)?udev|rules.d|hwdb.d)/[^ ]*') \
        $(realpath libudev.so --relative-to .)                         \
        $udev_helpers

    # Install the package
    install -vm755 -d {/usr/lib,/etc}/udev/{hwdb.d,rules.d,network}
    install -vm755 -d /usr/{lib,share}/pkgconfig
    install -vm755 udevadm                             /usr/bin/
    install -vm755 systemd-hwdb                        /usr/bin/udev-hwdb
    ln      -svfn  ../bin/udevadm                      /usr/sbin/udevd
    cp      -av    libudev.so{,*[0-9]}                 /usr/lib/
    install -vm644 ../src/libudev/libudev.h            /usr/include/
    install -vm644 src/libudev/*.pc                    /usr/lib/pkgconfig/
    install -vm644 src/udev/*.pc                       /usr/share/pkgconfig/
    install -vm644 ../src/udev/udev.conf               /etc/udev/
    install -vm644 rules.d/* ../rules.d/README         /usr/lib/udev/rules.d/
    install -vm644 $(find ../rules.d/*.rules \
                          -not -name '*power-switch*') /usr/lib/udev/rules.d/
    install -vm644 hwdb.d/*  ../hwdb.d/{*.hwdb,README} /usr/lib/udev/hwdb.d/
    install -vm755 $udev_helpers                       /usr/lib/udev
    install -vm644 ../network/99-default.link          /usr/lib/udev/network

    # Install some custom rules and support files useful in an LFS environment
    tar -xvf ../../udev-lfs-20230818.tar.xz
    make -f udev-lfs-20230818/Makefile.lfs install

    # Install the man pages
    tar -xf ../../systemd-man-pages-257.3.tar.xz                          \
        --no-same-owner --strip-components=1                              \
        -C /usr/share/man --wildcards '*/udev*' '*/libudev*'              \
                                    '*/systemd.link.5'                    \
                                    '*/systemd-'{hwdb,udevd.service}.8

    sed 's|systemd/network|udev/network|'                                 \
        /usr/share/man/man5/systemd.link.5                                \
    > /usr/share/man/man5/udev.link.5

    sed 's/systemd\(\\\?-\)/udev\1/' /usr/share/man/man8/systemd-hwdb.8   \
                                > /usr/share/man/man8/udev-hwdb.8

    sed 's|lib.*udevd|sbin/udevd|'                                        \
        /usr/share/man/man8/systemd-udevd.service.8                       \
    > /usr/share/man/man8/udevd.8

    rm /usr/share/man/man*/systemd*

    # Clean up the env var
    unset udev_helpers

    # Create the initial database
    udev-hwdb update
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"