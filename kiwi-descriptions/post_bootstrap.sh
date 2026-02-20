#!/usr/bin/bash

set -euxo pipefail

#======================================
# Greeting...
#--------------------------------------
echo "Bootstrap image: $kiwi_iname-$kiwi_iversion"
echo "Profiles: [$kiwi_profiles]"

#======================================
# Generate locales
#--------------------------------------
echo "C.UTF-8 UTF-8" > /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/default/locale
if [[ "$kiwi_profiles" == *"l10n"* ]]; then
	echo "it_IT.UTF-8 UTF-8" >> /etc/locale.gen
fi
echo "--- Generate locales ---"
locale-gen
locale -a

#======================================
# Base system
#--------------------------------------
## Configure additional sources
source /etc/os-release
cat << EOF > /etc/apt/sources.list
# See https://wiki.debian.org/SourcesList for more information
deb https://deb.debian.org/debian $VERSION_CODENAME main non-free-firmware contrib non-free
#deb-src https://deb.debian.org/debian $VERSION_CODENAME main non-free-firmware contrib non-free

deb https://deb.debian.org/debian $VERSION_CODENAME-updates main non-free-firmware contrib non-free
#deb-src https://deb.debian.org/debian $VERSION_CODENAME-updates main non-free-firmware contrib non-free

deb https://security.debian.org/debian-security/ $VERSION_CODENAME-security main non-free-firmware contrib non-free
#deb-src https://security.debian.org/debian-security/ $VERSION_CODENAME-security main non-free-firmware contrib non-free
EOF
## Update package database
apt update
## No interaction during install
export APT_LISTCHANGES_FRONTEND=none DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
## Setup base system
tasksel install standard
## Workaroud to address missing keymap for localectl systemd-firstboot. See:
##		https://groups.google.com/g/kiwi-images/c/5zHockGLFy8
apt --assume-yes install --no-install-recommends console-data
ln -s /usr/share/keymaps/i386/qwerty/it.kmap.gz /usr/share/keymaps/i386/qwerty/it.map.gz
echo "--- Import Trinity GPG signing key ---"
wget http://mirror.ppa.trinitydesktop.org/trinity/deb/trinity-keyring.deb && \
dpkg --install trinity-keyring.deb && \
## Add Trinity APT repository
rm trinity-keyring.deb
cat << EOF > /etc/apt/sources.list.d/trinity-desktop.list
# TDE R14.1.x series
deb http://mirror.ppa.trinitydesktop.org/trinity/deb/trinity-r14.1.x $VERSION_CODENAME main deps
#deb-src http://mirror.ppa.trinitydesktop.org/trinity/deb/trinity-r14.1.x $VERSION_CODENAME main deps
EOF
