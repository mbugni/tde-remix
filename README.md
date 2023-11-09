# tde-remix

## Purpose
This project is an experimental TDE ([Trinity Desktop Environment][01]) Remix (like a [Fedora Remix][02]) and aims to offer a live and installable system based on CentOS Stream. You can build a live image and try the software, then install it in your PC if you want.

## How to build the LiveCD
[See a detailed description][03] of how to build the live media.

**NOTE**

If `selinux` is on, disable it during the build process:

```shell
$ sudo setenforce 0
```

### Prepare the build directories
Clone the project to get sources:

```shell
$ git clone https://github.com/mbugni/tde-remix.git /<source-path>
```

Install kickstart tools:

```shell
$ sudo dnf -y install pykickstart
```

Prepare the target directory for building results:

```shell
$ sudo mkdir /result

$ sudo chmod ugo+rwx /result
```

Choose a version (eg: desktop with italian support) and then create a single Kickstart file from the base code:

```shell
$ ksflatten --config /<source-path>/kickstarts/l10n/tde-desktop-it_IT.ks \
 --output /result/centos-9-tde-desktop.ks
```

### Prepare the build enviroment using Podman
Install Podman:

```shell
$ sudo dnf -y install podman
```

Create the root of the build enviroment:

```shell
$ sudo dnf -y --setopt='tsflags=nodocs' --setopt='install_weak_deps=False' \
 --releasever=9 --installroot=/result/livebuild-c9 --repo=baseos \
 --repo=appstream install lorax-lmc-novirt
```

Pack the build enviroment into a Podman container:

```shell
$ sudo sh -c 'tar -c -C /result/livebuild-c9 . | podman import - centos/livebuild:c9'
```

### Build the live image using Podman
Build the .iso image by running the `livemedia-creator` command inside the container:

```shell
$ sudo podman run --privileged --volume=/result:/result --volume=/dev:/dev:ro \
 --volume=/lib/modules:/lib/modules:ro -it centos/livebuild:c9 \
 livemedia-creator --no-virt --nomacboot --make-iso --project='CentOS Stream' \
 --releasever=9 --tmp=/result --logfile=/result/lmc-logs/livemedia.log \
 --ks=/result/centos-9-tde-desktop.ks
```

The build can take a while (30 minutes or more), it depends on your machine performances.

Remove unused containers when finished:

```shell
$ sudo podman container prune
```

## Transferring the image to a bootable media
Install live media tools:

```shell
$ sudo dnf install livecd-iso-to-mediums
```

Create a bootable USB/SD device using the .iso image:

```shell
$ sudo livecd-iso-to-disk --format --reset-mbr /result/lmc-work-<code>/images/boot.iso /dev/sd[X]
```

## Post-install tasks
After installation, you can remove live system components to save space by running these commands:

```shell
$ sudo systemctl disable livesys.service
$ sudo systemctl disable livesys-late.service
$ sudo dnf remove anaconda\* livesys-scripts
```

## Change Log
All notable changes to this project will be documented in the [`CHANGELOG.md`](CHANGELOG.md) file.

The format is based on [Keep a Changelog][05].

[01]: https://www.trinitydesktop.org/
[02]: https://fedoraproject.org/wiki/Remix
[03]: https://weldr.io/lorax/lorax.html
[04]: https://github.com/mbugni/fedora-remix
[05]: https://keepachangelog.com/
