# base-centos.ks
#
# Defines the basics for a CentOS live system.

%packages --excludeWeakdeps

# Repositories
centos-stream-release
centos-stream-repos
epel-release

%end

%post

echo ""
echo "POST BASE CENTOS *************************************"
echo ""

# Enable PowerTools repo
dnf config-manager --set-enabled powertools

# Configure temporary DNS
cat > /etc/resolv.conf << EOF_RESOLVE
# Generated by CentOS live kickstart
nameserver 8.8.8.8
nameserver 208.67.222.222
EOF_RESOLVE

# Load variables with current OS info
source /etc/os-release

echo "Preparing live scripts for version ${VERSION}"

echo "Create the live installer script"
curl https://raw.githubusercontent.com/rhinstaller/anaconda/rhel-${VERSION}/data/liveinst/liveinst --output /usr/bin/liveinst
chmod +x /usr/bin/liveinst

echo "Create the desktop launcher to start installation from live media"
curl https://raw.githubusercontent.com/rhinstaller/anaconda/rhel-${VERSION}/data/liveinst/liveinst.desktop --output /usr/share/applications/liveinst.desktop
sed -i 's/^Exec=.*/Exec=\/usr\/bin\/sudo \/usr\/bin\/liveinst/' /usr/share/applications/liveinst.desktop
sed -i 's/^Icon=.*/Icon=anaconda/' /usr/share/applications/liveinst.desktop
cat >> /usr/share/applications/liveinst.desktop << EOF_DESKTOP
Name[it]=Installa sul disco rigido
GenericName[it]=Installa
Comment[it]=Installa il live CD sul disco rigido
EOF_DESKTOP

%end
