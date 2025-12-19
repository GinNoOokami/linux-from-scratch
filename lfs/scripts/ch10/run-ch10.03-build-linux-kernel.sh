#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION=$KERNEL_VERSION
PACKAGE_NAME=linux-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    # Ensure clean build before compiling kernel
    make mrproper

    # Copy over the pre-configured kernel config file (manually created with make menuconfig)
    cp /config/kernel/.config .config

    make
    make modules_install

    cp -iv arch/x86/boot/bzImage /boot/vmlinuz-$KERNEL_VERSION_TAG
    cp -iv System.map /boot/System.map-$VERSION
    cp -iv .config /boot/config-$VERSION
    cp -r Documentation -T /usr/share/doc/linux-$VERSION

    # Configure the module load order
    install -v -m755 -d /etc/modprobe.d
    cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"