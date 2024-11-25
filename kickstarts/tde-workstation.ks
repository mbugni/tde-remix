# kde-workstation.ks
#
# Provides a complete KDE workstation. Includes office, print and scan support.

%include tde-desktop.ks
%include base-workstation.ks

%packages --excludeWeakdeps

# Bluetooth
trinity-tdebluez
#bluez-hid2hci
bluez-obexd
#bluez-tools

# Printing
trinity-tdeprint

%end
