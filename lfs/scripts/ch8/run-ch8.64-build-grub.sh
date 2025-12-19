#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="2.12"
PACKAGE_NAME=grub-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.xz
pushd $PACKAGE_NAME

time {
    # It's important that no existing gcc flags are set
    unset {C,CPP,CXX,LD}FLAGS

    # Adding a missing file from the tarball
    echo depends bli part_gpt > grub-core/extra_deps.lst

    ./configure                 \
        --prefix=/usr           \
        --sysconfdir=/etc       \
        --disable-efiemu        \
        --disable-werror

    make
    make install

    # Move the Bash completion support file to the location recommended by the Bash completion maintainers
    mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"