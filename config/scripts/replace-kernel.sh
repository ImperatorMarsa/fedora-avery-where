#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
set -oue pipefail

FEDORA_VERSION="$(cat /usr/lib/os-release | grep -Po '(?<=VERSION_ID=)\d+')"
INSTALLED_KERNEL_PACKAGES="$(rpm -qa --qf "%{NAME}\n" | grep -P '^kernel(?!-tools).*')"

printf "### Fedora version ###\n$FEDORA_VERSION\n\n"

# Run script with sudo or add sudo to below if using script locally
wget -P /etc/yum.repos.d/ https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos/repo/fedora-$(rpm -E %fedora)/bieszczaders-kernel-cachyos-fedora-$(rpm -E %fedora).repo

printf "### Packages to be replaced ###\n$INSTALLED_KERNEL_PACKAGES\n\n"
sleep 2

# Use rpm-ostree's cliwrap to allow dracut to run on the container and generate
# an initramfs.
### COMMENT OUT BELOW LINE IF USING LOCALLY ###
rpm-ostree cliwrap install-to-root / && \
rpm-ostree override remove $INSTALLED_KERNEL_PACKAGES --install=kernel-cachyos-bore-eevdf