# How to build i386 images

## Purpose
This guide describes how to build a 32 bit TDE live system.

The main difference is the build container usage, so you can prepare source and target directories
just like the `amd64` image.

### Prepare the build container
Create the container for the build enviroment:

```shell
$ sudo podman build --arch=i386 --build-arg REGISTRY_PREFIX=docker.io/i386 \
--file=/<source-path>/Containerfile --tag=tdebuild:i386
```

Initialize the container by running an interactive shell:

```shell
$ sudo podman run --arch=i386 --privileged --network=host -it \
--volume=/<source-path>:/live/source:ro --volume=/<target-path>:/live/target \
--name=tdebuild-i386 --hostname=tdebuild-i386 tdebuild:i386 /usr/bin/bash
```

Exit from the build container. The container can be reused and upgraded multiple times.
See [Podman docs][06] for more details.

To enter again into the build container:

```shell
$ sudo podman start -ia tdebuild-i386
```

### Build the image
First, start the build container if not running:

```shell
$ sudo podman start tdebuild-i386
```

Build the .iso image by running the `kiwi-ng` command:

```shell
$ sudo podman exec tdebuild-i386 linux32 kiwi-ng --profile=Workstation-l10n --type=iso \
--debug --color-output --shared-cache-dir=/live/target/cache system build \
--description=/live/source/kiwi-descriptions --target-dir=/live/target
```

### Patch the built image
The resulting image is not bootable. In order to get it bootable, run the following command:

```shell
$ sudo podman exec tdebuild-i386 xorriso -indev /live/target/TDE-Remix.ix86-<version>.iso \
-outdev /live/target/TDE-Remix.i386.iso -publisher TDE_Remix \
-boot_image grub bin_path=boot/ix86/loader/eltorito.img \
-boot_image grub grub2_mbr=/lib/grub/i386-pc/boot_hybrid.img \
-boot_image any grub2_boot_info=on -boot_image any boot_info_table=on \
-boot_image any platform_id=0x00 -boot_image any emul_type=no_emulation \
-joliet on -commit_eject all
```