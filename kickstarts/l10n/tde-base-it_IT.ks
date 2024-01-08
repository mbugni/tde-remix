# base-it_IT.ks
#
# Defines the basics for TDE localization support.

%include base-it_IT.ks

%packages --excludeWeakdeps

tqt3-i18n
trinity-tde-i18n-Italian

%end

%post

echo ""
echo "POST TDE BASE it_IT **********************************"
echo ""

# Keyboard layout settings
cat > /etc/skel/.trinity/share/config/kxkbrc << KXKBRC_EOF
[Layout]
LayoutList=it
Model=pc104
Options=
ResetOldOptions=true
ShowFlag=true
ShowLabel=true
ShowLayoutIndicator=true
ShowSingle=false
SwitchMode=Global
Use=true
KXKBRC_EOF

%end
