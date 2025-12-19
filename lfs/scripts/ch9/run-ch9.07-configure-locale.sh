#!/bin/bash
set -xe

. "$(dirname "$0")"/../common.sh

{
ensure_root_user && ensure_chroot

time {
    # Configure default profile locale
    cat > /etc/profile << "EOF"
# Begin /etc/profile

for i in $(locale); do
  unset ${i%=*}
done

if [[ "$TERM" = linux ]]; then
  export LANG=C.UTF-8
else
  export LANG=en_US.ISO-8859-1
fi

# End /etc/profile
EOF
}

} 2>&1 | tee "$LOG_FILE"