# tde-packages.ks
#
# Defines common packages for the TDE desktop.

%packages --excludeWeakdeps

# Unwanted stuff
-gdm

# TDE repository
trinity-repo

# TDE base apps
trinity-tdebase

# Desktop apps
trinity-ark
trinity-gwenview
trinity-gwenview-i18n
trinity-kcalc
trinity-kcharselect
trinity-kicker-applets
trinity-kpdf
trinity-ksnapshot
trinity-kuser
trinity-tdesudo

# Device control
trinity-arts-config-pulseaudio
trinity-kmix
trinity-krec
trinity-kscd
trinity-tdenetworkmanager
trinity-tdepowersave
trinity-tdeprint
trinity-tdescreensaver

# Styles and themes
adwaita-gtk2-theme
trinity-gtk-qt-engine
trinity-gtk3-tqt-engine
trinity-tdeartwork-style
trinity-tdmtheme

# System utilities
fedora-release-kde
gnome-keyring-pam

%end
