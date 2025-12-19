#!/bin/bash
PWD=$(dirname "$0")
. "$PWD/../common.sh"
set -xeuo pipefail

ensure_lfs_path_set && ensure_root_user

# Make sure PTYs works before building
# This needs to be done before the main build or else it interrupts it
with_chroot $PWD/check_ptys.sh

with_chroot $PWD/run-ch8.03-build-man-pages.sh
with_chroot $PWD/run-ch8.04-install-iana-etc.sh
with_chroot $PWD/run-ch8.05-build-glibc.sh
with_chroot $PWD/run-ch8.06-build-zlib.sh
with_chroot $PWD/run-ch8.07-build-bzip2.sh
with_chroot $PWD/run-ch8.08-build-xz.sh
with_chroot $PWD/run-ch8.09-build-lz4.sh
with_chroot $PWD/run-ch8.10-build-zstd.sh
with_chroot $PWD/run-ch8.11-build-file.sh
with_chroot $PWD/run-ch8.12-build-readline.sh
with_chroot $PWD/run-ch8.13-build-m4.sh
with_chroot $PWD/run-ch8.14-build-bc.sh
with_chroot $PWD/run-ch8.15-build-flex.sh
with_chroot $PWD/run-ch8.16-build-tcl.sh
with_chroot $PWD/run-ch8.17-build-expect.sh
with_chroot $PWD/run-ch8.18-build-dejagnu.sh
with_chroot $PWD/run-ch8.19-build-pkgconf.sh
with_chroot $PWD/run-ch8.20-build-binutils.sh
with_chroot $PWD/run-ch8.21-build-gmp.sh
with_chroot $PWD/run-ch8.22-build-mpfr.sh
with_chroot $PWD/run-ch8.23-build-mpc.sh
with_chroot $PWD/run-ch8.24-build-attr.sh
with_chroot $PWD/run-ch8.25-build-acl.sh
with_chroot $PWD/run-ch8.26-build-libcap.sh
with_chroot $PWD/run-ch8.27-build-libxcrypt.sh
with_chroot $PWD/run-ch8.28-build-shadow.sh
with_chroot $PWD/run-ch8.29-build-gcc.sh
with_chroot $PWD/run-ch8.30-build-ncurses.sh
with_chroot $PWD/run-ch8.31-build-sed.sh
with_chroot $PWD/run-ch8.32-build-psmisc.sh
with_chroot $PWD/run-ch8.33-build-gettext.sh
with_chroot $PWD/run-ch8.34-build-bison.sh
with_chroot $PWD/run-ch8.35-build-grep.sh
with_chroot $PWD/run-ch8.36-build-bash.sh
with_chroot $PWD/run-ch8.37-build-libtool.sh
with_chroot $PWD/run-ch8.38-build-gdbm.sh
with_chroot $PWD/run-ch8.39-build-gperf.sh
with_chroot $PWD/run-ch8.40-build-expat.sh
with_chroot $PWD/run-ch8.41-build-inetutils.sh
with_chroot $PWD/run-ch8.42-build-less.sh
with_chroot $PWD/run-ch8.43-build-perl.sh
with_chroot $PWD/run-ch8.44-build-xmlparser.sh
with_chroot $PWD/run-ch8.45-build-intltool.sh
with_chroot $PWD/run-ch8.46-build-autoconf.sh
with_chroot $PWD/run-ch8.47-build-automake.sh
with_chroot $PWD/run-ch8.48-build-openssl.sh
with_chroot $PWD/run-ch8.49-build-libelf.sh
with_chroot $PWD/run-ch8.50-build-libffi.sh
with_chroot $PWD/run-ch8.51-build-python.sh
with_chroot $PWD/run-ch8.52-build-flitcore.sh
with_chroot $PWD/run-ch8.53-build-wheel.sh
with_chroot $PWD/run-ch8.54-build-setuptools.sh
with_chroot $PWD/run-ch8.55-build-ninja.sh
with_chroot $PWD/run-ch8.56-build-meson.sh
with_chroot $PWD/run-ch8.57-build-kmod.sh
with_chroot $PWD/run-ch8.58-build-coreutils.sh
with_chroot $PWD/run-ch8.59-build-check.sh
with_chroot $PWD/run-ch8.60-build-diffutils.sh
with_chroot $PWD/run-ch8.61-build-gawk.sh
with_chroot $PWD/run-ch8.62-build-findutils.sh
with_chroot $PWD/run-ch8.63-build-groff.sh
with_chroot $PWD/run-ch8.64-build-grub.sh
with_chroot $PWD/run-ch8.65-build-gzip.sh
with_chroot $PWD/run-ch8.66-build-iproute2.sh
with_chroot $PWD/run-ch8.67-build-kbd.sh
with_chroot $PWD/run-ch8.68-build-libpipeline.sh
with_chroot $PWD/run-ch8.69-build-make.sh
with_chroot $PWD/run-ch8.70-build-patch.sh
with_chroot $PWD/run-ch8.71-build-tar.sh
with_chroot $PWD/run-ch8.72-build-texinfo.sh
with_chroot $PWD/run-ch8.73-build-vim.sh
with_chroot $PWD/run-ch8.74-build-markupsafe.sh
with_chroot $PWD/run-ch8.75-build-jinja2.sh
with_chroot $PWD/run-ch8.76-build-udev.sh
with_chroot $PWD/run-ch8.77-build-man-db.sh
with_chroot $PWD/run-ch8.78-build-procps-ng.sh
with_chroot $PWD/run-ch8.79-build-util-linux.sh
with_chroot $PWD/run-ch8.80-build-e2fsprogs.sh
with_chroot $PWD/run-ch8.81-build-sysklogd.sh
with_chroot $PWD/run-ch8.82-build-sysvinit.sh
with_chroot $PWD/run-ch8.83-strip-debug-symbols.sh
# with_chroot $PWD/run-ch8.84-cleanup.sh
