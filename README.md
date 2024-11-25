# tde-remix

## Purpose
This project is a TDE ([Trinity Desktop Environment][08]) remix and aims to offer a live and installable system based on Debian (like a [Debian Live][01]). You can [download a live image][02] and try the software, and then install it in your PC if you want.
You can also customize the image starting from available scripts.

Main goals of this remix are:
* lightweight enviroment suitable also for old PC
* adding common extra-repos
* supporting printers and scanners

## How to build the LiveCD
[See a detailed description][03] about how to build a live media using kiwi-ng.

### Prepare the working directories
Clone the project into your `<source-path>` to get sources:

```shell
$ git clone https://github.com/mbugni/tde-remix.git /<source-path>
```

Choose or create a `<target-path>` folder where to put results.

### Prepare the build container
Install Podman:

```shell
$ sudo apt --assume-yes install podman containers-storage fuse-overlayfs
```

Create the container for the build enviroment:

```shell
$ sudo podman build --file=/<source-path>/Containerfile --tag=tdebuild:amd64
```

Pack the build enviroment into a Podman container:

```shell
$ sudo podman run --privileged --network=host -it \
--volume=/<source-path>:/live/source:ro --volume=/<target-path>:/live/target \
--name=tdebuild-amd64 --hostname=tdebuild-amd64 tdebuild:amd64 /usr/bin/bash
```

Exit from the build container. The container can be reused and upgraded multiple times.
See [Podman docs][06] for more details.

To enter again into the build container:

```shell
$ sudo podman start -ia tdebuild-amd64
```

### Build the image
First, start the build container if not running:

```shell
$ sudo podman start tdebuild-amd64
```

Choose a variant (eg: workstation with localization support) that corresponds to a profile (eg: `Workstation-l10n`).

Available profiles/variants are:
* `Minimal` (console only, mainly for testing)
* `Desktop` (minimal TDE environment with basic tools)
* `Workstation` (TDE environment with more features like printing and scanning support)

For each variant you can append `-l10n` to get localization (eg: `Desktop-l10n`).

Build the .iso image by running the `kiwi-ng` command:

```shell
$ sudo podman exec tdebuild-amd64 kiwi-ng --profile=Workstation-l10n --type=iso \
--debug --color-output --shared-cache-dir=/live/target/cache system build \
--description=/live/source/kiwi-descriptions --target-dir=/live/target
```

The build can take a while (20 minutes or more), it depends on your machine performances.

Remove unused containers when finished:

```shell
$ sudo podman container rm --force tdebuild-amd64
$ sudo podman image rm tdebuild:amd64
```

> [!NOTE]
>
> The above is for building 64 bit images.
> Follow the [i386 how to](./how-to-build-i386.md) if you need to build a 32 bit image.

## Transferring the image to a bootable media
You can use a tool like [Ventoy][07] to build multiboot USB devices, or simply transfer the image to a single
USB stick using the `dd` command:

```shell
$ sudo dd if=/<target-path>/TDE-Remix.x86_64-<version>.iso of=/dev/<stick-device>
```

## Post-install tasks
After installation, remove live system resources to save space by running:

```shell
$ source /usr/local/libexec/remix/livesys-cleanup
```

## ![Bandiera italiana][04] Per gli utenti italiani
Questo è un remix di TDE ([Trinity Desktop Environment][08]), basato su Debian (analogo a una [Debian Live][01]) con il supporto in italiano per lingua e tastiera. Nell'[immagine .iso][02] che si ottiene sono già installati i pacchetti e le configurazioni per il funzionamento in italiano del sistema (come l'ambiente grafico, i repo extra etc).

Il remix ha come obiettivi principali:
* un ambiente grafico leggero adatto anche a vecchi PC
* aggiunta dei repository comuni
* supporto per stampanti e scanner

## Change Log
All notable changes to this project will be documented in the [`CHANGELOG.md`](CHANGELOG.md) file.

The format is based on [Keep a Changelog][05].

[01]: https://www.debian.org/devel/debian-live/
[02]: https://github.com/mbugni/tde-remix/releases
[03]: https://osinside.github.io/kiwi
[04]: http://flagpedia.net/data/flags/mini/it.png
[05]: https://keepachangelog.com/
[06]: https://docs.podman.io/
[07]: https://www.ventoy.net/
[08]: https://www.trinitydesktop.org/