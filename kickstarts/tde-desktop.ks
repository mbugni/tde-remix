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
trinity-gwenview
trinity-gwenview-i18n
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
trinity-tdeprint
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

# set TDE as default X11 session
cat > /etc/skel/.dmrc << DMRC_EOF
[Desktop]
Session=tde
DMRC_EOF

systemctl enable tdm.service

%end
