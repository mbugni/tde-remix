# Low resources tips

## Purpose
This guide describes how to setup your system if you have low resources.

## Disable AppArmor and SELinux
Stop the AppArmor service:
```shell
$ sudo systemctl stop apparmor
```

Disable AppArmor from starting at boot:
```shell
$ sudo systemctl disable apparmor
```

Remove the AppArmor package and its dependencies:
```shell
$ sudo apt remove --purge apparmor
```

Disable SELinux by editing the `SELINUX` variable in the `/etc/selinux/config` file:
```
SELINUX=disabled
```

Edit the `/etc/default/grub` config file and append the following at the end of the `GRUB_CMDLINE_LINUX_DEFAULT` variable:
```
GRUB_CMDLINE_LINUX_DEFAULT="... apparmor=0 selinux=0"
```

Update the GRUB boot menu:
```shell
$ sudo update-grub
```

## Install SeaMonkey on Debian via APT
Install the required packages before importing the GPG key:
```shell
$ sudo apt install dirmngr software-properties-common apt-transport-https
```

Ensure to have the required GPG directories:
```shell
$ sudo gpg --list-keys
```

Import the GPG key:
```shell
$ sudo gpg --no-default-keyring --keyring /usr/share/keyrings/ubuntuzilla.gpg --keyserver keyserver.ubuntu.com --recv-keys 2667CA5C
```

Add the Ubuntuzilla repository:
```shell
$ printf 'deb [signed-by=/usr/share/keyrings/ubuntuzilla.gpg] https://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main\n' | sudo tee /etc/apt/sources.list.d/ubuntuzilla.list
```

Install SeaMonkey using the `apt` command:
```shell
$ sudo apt update

$ sudo apt install seamonkey-mozilla-build
```

If SeaMonkey doesn't start, you could have missing dependencies:
```shell
$ sudo apt install libdbus-glib-1-2
```

## Use an alternative Window Manager
You can follow the ["use another window manager"](https://wiki.trinitydesktop.org/Tips_And_Tricks#Use_another_window_manager_with_TDE) guide.

Assume you want to use [Openbox](https://openbox.org/) instead of the default TWin.
First, install Openbox:
```shell
$ sudo apt update

$ sudo apt install openbox
```

To set it permanently, edit the `$HOME/.trinity/share/config/twinrc` file and add the following:
```ini
[ThirdPartyWM]
WMExecutable=openbox
# Set this to pass additional arguments
# WMAdditionalArguments=
```