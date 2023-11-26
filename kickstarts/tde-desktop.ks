# tde-desktop.ks
#
# Provides a basic Linux box based on TDE desktop.

%include base-desktop.ks
%include base-extras.ks
%include tde-base.ks

repo --name=trinity-r14 --mirrorlist=http://mirror.ppa.trinitydesktop.org/trinity/rpm/el$releasever/trinity-r14-$basearch.list
repo --name=trinity-r14-noarch --mirrorlist=http://mirror.ppa.trinitydesktop.org/trinity/rpm/el$releasever/trinity-r14-noarch.list

%packages --excludeWeakdeps

# TDE repository
trinity-repo

# TDE desktop
# base apps
trinity-tdebase
# desktop apps
trinity-ark
trinity-kcalc
trinity-kcharselect
trinity-kicker-applets
trinity-kmilo
trinity-ksnapshot
trinity-kuser
trinity-tdesudo
# device control
trinity-kmix
trinity-krec
trinity-kscd
trinity-tdemid
trinity-tdenetworkmanager
trinity-tdepowersave
trinity-tdescreensaver
# styles and themes
# adwaita-gtk2-theme
trinity-gtk-qt-engine
trinity-gtk3-tqt-engine
trinity-tdeartwork-style
trinity-tdmtheme

%end

%post

echo ""
echo "POST TDE DESKTOP *************************************"
echo ""

# Set TDE as default X11 session
cat > /etc/skel/.dmrc << DMRC_EOF
[Desktop]
Session=tde
DMRC_EOF

# Default sudo settings
cat > /etc/trinity/tdesurc << TDESURC_EOF
[super-user-command]
super-user-command=sudo
TDESURC_EOF

# Default app settings **************************************
mkdir -p /etc/skel/.trinity/share/apps

# Konsole app settings
mkdir -p /etc/skel/.trinity/share/apps/konsole

# Default console settings
cp /opt/trinity/share/apps/konsole/shell.desktop /etc/skel/.trinity/share/apps/konsole/shell.desktop
cp /opt/trinity/share/apps/konsole/linux.desktop /etc/skel/.trinity/share/apps/konsole/linux.desktop
cat >> /etc/skel/.trinity/share/apps/konsole/shell.desktop << SHELL_EOF
Schema=Linux.schema
Term=xterm-256color
SHELL_EOF
sed -s -i 's/^Schema=.*/Schema=Linux.schema/' /etc/skel/.trinity/share/apps/konsole/*.desktop
sed -s -i 's/^Term=.*/Term=xterm-256color/' /etc/skel/.trinity/share/apps/konsole/*.desktop

# Default config settings ***********************************
mkdir -p /etc/skel/.trinity/share/config

# Session settings
cat > /etc/skel/.trinity/share/config/ksmserverrc << KSMSERVERRC_EOF
[General]
loginMode=default
KSMSERVERRC_EOF

systemctl enable tdm.service

%end
