#!/bin/bash
. "$(dirname "$0")"/../common.sh
set -xeuo pipefail

{
ensure_root_user && ensure_chroot

VERSION="9.1.1166"
PACKAGE_NAME=vim-$VERSION

pushd "/sources"

tar -xf $PACKAGE_NAME.tar.gz
pushd $PACKAGE_NAME

time {

    # Change default vim config to /etc
    echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

    ./configure --prefix=/usr

    make

    # In docker, lines are set to 15 by default but the tests require a minimum of 24 so change that before running tests
    stty rows 24 cols 180
    chown -R tester .
    sed '/test_plugin_glvs/d' -i src/testdir/Make_all.mak
    su tester -c "LINES=24 TERM=xterm-256color LANG=en_US.UTF-8 make -j1 test" &> vim-test.log
    tail vim-test.log

    make install

    # Make a link for vi
    ln -sv vim /usr/bin/vi
    for L in  /usr/share/man/{,*/}man1/vim.1; do
        ln -sv vim.1 $(dirname $L)/vi.1
    done

    # Move the docs to a location consistent with others
    ln -sv ../vim/vim91/doc /usr/share/doc/$PACKAGE_NAME

    # Setup default configuration
    cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF
}

popd
rm -rf $PACKAGE_NAME

popd

} 2>&1 | tee "$LOG_FILE"