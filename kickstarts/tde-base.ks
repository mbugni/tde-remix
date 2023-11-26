# tde-base.ks
#
# Provides the basics for the TDE desktop.

%packages --excludeWeakdeps

xorg-x11-xinit-session
setxkbmap

%end

%post

# set default GTK+ theme for root (see #683855, #689070, #808062)
cat > /root/.gtkrc-2.0 << EOF
include "/usr/share/themes/Adwaita/gtk-2.0/gtkrc"
include "/etc/gtk-2.0/gtkrc"
gtk-theme-name="Adwaita"
EOF
mkdir -p /root/.config/gtk-3.0
cat > /root/.config/gtk-3.0/settings.ini << EOF
[Settings]
gtk-theme-name = Adwaita
EOF

# set livesys session type
sed -i 's/^livesys_session=.*/livesys_session="tde"/' /etc/sysconfig/livesys

# add livesys init script
cat >> /usr/libexec/livesys/sessions.d/livesys-tde << LIVESYS_EOF

# set up autologin for user liveuser
if [ -f /etc/trinity/tdm/tdmrc ]; then
sed -i 's/^AllowNullPasswd=.*/AllowNullPasswd=true/' /etc/trinity/tdm/tdmrc
sed -i 's/^#AutoLoginEnable=.*/AutoLoginEnable=true/' /etc/trinity/tdm/tdmrc
sed -i 's/^#AutoLoginUser=.*/AutoLoginUser=liveuser/' /etc/trinity/tdm/tdmrc
else
cat > /etc/trinity/tdm/tdmrc << TDM_EOF
[X-*-Core]
AllowNullPasswd=true
AutoLoginEnable=true
AutoLoginUser=liveuser
TDM_EOF
fi

# custom session for liveuser
cat > /home/liveuser/.xsession << SESSION_EOF
#!/usr/bin/sh
# allow Anaconda installer to run using sudo
xhost +
# start a TDE session
exec /opt/trinity/bin/starttde
SESSION_EOF
chmod +x /home/liveuser/.xsession

# force custom X11 session for liveuser
cat > /home/liveuser/.dmrc << DMRC_EOF
[Desktop]
Session=custom
DMRC_EOF

# default settings for liveuser
mkdir -p /home/liveuser/.trinity/share/config

# disable desktop media icons
cat > /home/liveuser/.trinity/share/config/kdesktoprc << DESKTOP_EOF
[Media]
enabled=false
DESKTOP_EOF

# sudo settings for liveuser
cat > /home/liveuser/.trinity/share/config/tdesurc << TDESURC_EOF
[super-user-command]
super-user-command=su
TDESURC_EOF

# show liveinst.desktop on desktop and in menu
desktop-file-edit --set-key=NoDisplay --set-value=false /usr/share/applications/liveinst.desktop
# fix missing installer icon (see https://issues.redhat.com/browse/RHEL-13713)
desktop-file-edit --set-icon=anaconda /usr/share/applications/liveinst.desktop
# set executable bit disable KDE security warning
chmod +x /usr/share/applications/liveinst.desktop
mkdir /home/liveuser/Desktop
cp -a /usr/share/applications/liveinst.desktop /home/liveuser/Desktop/

LIVESYS_EOF

%end
