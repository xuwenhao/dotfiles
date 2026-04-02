#!/bin/bash
# Allow bubblewrap (bwrap) to create network namespaces under AppArmor.
#
# On Ubuntu 24.04+ with kernel.apparmor_restrict_unprivileged_userns=1,
# bwrap fails with "loopback: Failed RTM_NEWADDR: Operation not permitted".
# This script installs an unconfined AppArmor profile granting bwrap the
# userns capability.
#
# Usage: sudo ./setup-bwrap-apparmor.sh

set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "Error: must run as root (sudo)." >&2
  exit 1
fi

cat > /etc/apparmor.d/usr.bin.bwrap <<'PROFILE'
# AppArmor profile for bubblewrap - allow unprivileged user namespace operations
abi <abi/4.0>,
include <tunables/global>

profile bwrap /usr/bin/bwrap flags=(unconfined) {
  userns,
}
PROFILE

apparmor_parser -r /etc/apparmor.d/usr.bin.bwrap
echo "Done: bwrap AppArmor profile installed and loaded."
