# TDE Remix

## Purpose
This project is an experimental TDE ([Trinity Desktop Environment][01]) Remix (like a [Fedora Remix][04]) and aims to offer a live and installable system based on CentOS Stream. You can [download a live image][02] and try the software, and then install it in your PC if you want.
You can also customize the image starting from available scripts.

## How to build the LiveCD
[See a detailed description][03] of how to build the live media.

**NOTE**

If `selinux` is on, disable it during the build process:

```shell
$ sudo setenforce 0
```

### Prepare the working directories
Clone the project to get sources:

```shell
$ git clone https://github.com/mbugni/tde-remix.git /<source-path>
```

Choose or create a `/<target-path>` where to put results.

### Prepare the build container
Install Podman:

```shell
$ sudo dnf --assumeyes install podman
```

Create the container for the build enviroment:

```shell
$ sudo podman build --file=/<source-path>/Containerfile --tag=livebuild:el9
```

Initialize the container by running an interactive shell:

```shell
$ sudo podman run --privileged --network=host -it \ 
 --volume=/dev:/dev:ro --volume=/lib/modules:/lib/modules:ro \
 --volume=/<source-path>:/live/source:ro --volume=/<target-path>:/live/target \
 --name=livebuild-el9 --hostname=livebuild-el9 livebuild:el9 /usr/bin/bash
```

The container can be reused and upgraded multiple times. See [Podman docs][06] for more details.

To enter again into the build container:

```shell
$ sudo podman start -ia livebuild-el9
```

### Build the image

Run build commands inside the container.

#### Prepare the kickstart file

Choose a version (eg: TDE workstation with italian support) and then create a single Kickstart file from the source code:

```shell
[] ksflatten --config /live/source/kickstarts/l10n/tde-workstation-it_IT.ks \
 --output /live/target/el9-tde-workstation.ks
```

#### Check dependencies (optional)
Run the `ks-package-list` command if you need to check Kickstart dependencies:

```shell
[] ks-package-list --stream 9 --format "{name}" --verbose \
 /live/target/el9-tde-workstation.ks > /live/target/el9-tde-packages.txt
```

Use the `--help` option to get more info about the tool:

```shell
[] ks-package-list --help
```

#### Create the live image
Build the .iso image by running the `livemedia-creator` command:

```shell
[] livemedia-creator --no-virt --nomacboot --make-iso --project='CentOS Stream' \
 --releasever=9 --tmp=/live/target --logfile=/live/target/lmc-logs/livemedia.log \
 --ks=/live/target/el9-tde-workstation.ks
```

The build can take a while (30 minutes or more), it depends on your machine performances.

Remove unused resources when don't need anymore:

```shell
$ sudo podman container rm --force livebuild-el9
$ sudo podman image rm livebuild:el9
```

## Transferring the image to a bootable media
Install live media tools:

```shell
$ sudo dnf install livecd-iso-to-mediums
```

Create a bootable USB/SD device using the .iso image:

```shell
$ sudo livecd-iso-to-disk --format --reset-mbr \
 /<target-path>/lmc-work-<code>/images/boot.iso /dev/sd<X>
```

## Post-install tasks
After installation, you can remove live system resources to save space by running:

```shell
$ source /usr/local/post-install/livesys-cleanup.sh
```

A Flatpak quick setup script is provided:

```shell
$ source /usr/local/post-install/flatpak-setup.sh
```

## Change Log
All notable changes to this project will be documented in the [`CHANGELOG.md`](CHANGELOG.md) file.

The format is based on [Keep a Changelog][05].

[01]: https://www.trinitydesktop.org/
[02]: https://github.com/mbugni/tde-remix/releases
[03]: https://weldr.io/lorax/lorax.html
[04]: https://fedoraproject.org/wiki/Remix
[05]: https://keepachangelog.com/
[06]: https://docs.podman.io/