# tde-desktop.ks
#
# Provides a basic Linux box based on TDE desktop.

%include base-desktop.ks
%include tde-packages.ks

repo --name=trinity-r14 --mirrorlist=http://mirror.ppa.trinitydesktop.org/trinity/rpm/el$releasever/trinity-r14-$basearch.list
repo --name=trinity-r14-noarch --mirrorlist=http://mirror.ppa.trinitydesktop.org/trinity/rpm/el$releasever/trinity-r14-noarch.list


%post

echo ""
echo "POST TDE DESKTOP *************************************"
echo ""

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

# add initscript
cat >> /etc/rc.d/init.d/livesys << EOF

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

# auto start TDE for liveuser
cat > /home/liveuser/.xsession << SESSION_EOF
#!/usr/bin/sh
export XAUTHORITY=~/.Xauthority
xhost +
exec dbus-launch --exit-with-session /opt/trinity/bin/starttde
SESSION_EOF
chmod +x /home/liveuser/.xsession

# show liveinst.desktop on desktop and in menu
sed -i 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop
# set executable bit disable KDE security warning
chmod +x /usr/share/applications/liveinst.desktop
mkdir /home/liveuser/Desktop
cp -a /usr/share/applications/liveinst.desktop /home/liveuser/Desktop/

# make sure to set the right permissions and selinux contexts
chown -R liveuser:liveuser /home/liveuser/
restorecon -R /home/liveuser/

EOF

systemctl enable tdm.service

%end
