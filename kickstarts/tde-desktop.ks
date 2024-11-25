# tde-desktop.ks
#
# Provides a basic Linux box based on TDE desktop.

%include base-desktop.ks
%include base-extras.ks
%include base-flatpak.ks
%include tde-base.ks

%packages --excludeWeakdeps

# Flatpak
xdg-desktop-portal

# TDE desktop
# base apps
trinity-tdebase
# desktop apps
trinity-ark
trinity-arts-config-pulseaudio
trinity-kcalc
trinity-kcharselect
trinity-kicker-applets
trinity-kmilo
trinity-ksnapshot
trinity-kuser
trinity-mplayerthumbs
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

# Default config settings
mkdir -p /etc/skel/.trinity/share/config

# Session settings
cat > /etc/skel/.trinity/share/config/ksmserverrc << KSMSERVERRC_EOF
[General]
loginMode=default
KSMSERVERRC_EOF

# Enable pipewire/pulseaudio service
mkdir -p /etc/skel/.trinity/Autostart
cat > /etc/skel/.trinity/Autostart/pipewire-pulse.desktop << PIPEWIRE_EOF
[Desktop Entry]
Version=1.0
Name=PipeWire Pulse
Comment=Enable the PipeWire Pulse Service
Exec=/usr/bin/systemctl --user enable --now pipewire-pulse.service
StartupNotify=false
NoDisplay=true
Terminal=false
Type=Application
X-GNOME-Autostart-Phase=Initialization
X-KDE-autostart-phase=1
PIPEWIRE_EOF

# Enable TDM login manager
systemctl enable tdm.service

%end
