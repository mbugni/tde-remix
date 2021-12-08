# tde-desktop-it_IT.ks
#
# Provides a basic TDE desktop with italian localization support.

%include ../tde-desktop.ks

lang --addsupport=it_IT.UTF-8 it_IT.UTF-8
keyboard --xlayouts=it --vckeymap=it
timezone Europe/Rome

%packages --excludeWeakdeps

glibc-langpack-it
hunspell-it
langpacks-it
trinity-tde-i18n-Italian

%end


%post

echo ""
echo "POST TDE DESKTOP it_IT *******************************"
echo ""

# Set italian locale
cat >> /etc/rc.d/init.d/livesys << EOF_LIVESYS

# Force italian keyboard layout (rhb #982394)
localectl set-locale it_IT.UTF-8
localectl set-x11-keymap it
localectl set-keymap it

EOF_LIVESYS

%end
