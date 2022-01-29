
# Kernel modules for UnifiOS (UDM, UDR, UXG)
## Project Notes

**Author:** Patrick Wallner

The tar file in this repository is a collection of binaries that can be loaded onto the above mentioned devices to run additional kernel modules:

 - Wireguard[^1]
 - NFS (Server/Client)[^2]
 - CIFS (Server/Client)[^3]

Please see below for instructions on how to install the pre built kernel modules.
## Table of Contents

  * [Installation](#installation)
  * [Build from source](#build-from-source)
  * [Surviving Reboots](#surviving-reboots)
  * [Upgrades](#upgrades)
  * [Issues loading modules](#issues-loading-modules)
  * [Usage](#usage)
  * [FAQ](#faq)

If you want to compile your own version, there is a separate build [page](https://github.com/pwallner/UI-Ware/blob/main/kernel-modules/README.building.md). This was built from the GPL sources Ubiquiti sent to the [wireguard-kmod](https://github.com/tusc/wireguard-kmod) team and latest version from UDM (v1.11.0) was send to me.

## Installation
As there are a lot of commands and apps needed, I assume you already installed my [UI-Ware](https://github.com/pwallner/UI-Ware), so the installation is really easy with one simple command:
```sh
apt-get install kernel-modules-$(uname -r)
```
If you receive an error like this, then you are running a firmware that currently doesn't have a module built for it: 
```sh
# apt-get install kernel-modules-$(uname -r)
Reading package lists... Done
Building dependency tree
Reading state information... Done
E: Unable to locate package kernel-modules-4.19.152-al-linux-v10.2.0-v1.11.0.3921-f2e3fac
E: Couldn't find any package by glob 'kernel-modules-4.19.152-al-linux-v10.2.0-v1.11.0.3921-f2e3fac'
E: Couldn't find any package by regex 'kernel-modules-4.19.152-al-linux-v10.2.0-v1.11.0.3921-f2e3fac'
```
Please reach out and send me details of your device:
```sh
# uname -a
Linux UDM 4.19.152-al-linux-v10.2.0-v1.11.0.3921-f2e3fac #1 SMP Tue Dec 21 08:05:39 UTC 2021 aarch64 GNU/Linux
```

## Build from source
To build this package please follow this [README](https://github.com/pwallner/UI-Ware/blob/main/kernel-modules/README.building.md)

## Surviving Reboots
> :warning: **If you follow all instructions from [UI-Ware](https://github.com/pwallner/UI-Ware), the device will survive a reboot.** 

Insert new scripts on demand if you want to have something loaded and started after a reboot.

* For the UDM or UDM Pro:
add script into the `/mnt/data/on_boot.d` directory when finished.
* For the UDM-SE or UDR, create a systemd boot service to run the setup script at boot by running the following commands:
	
	```sh
	cp <path/file> /etc/systemd/system/setup-<something>.service
	systemctl daemon-reload
	systemctl enable setup-<something>
	```

## Upgrades
If your device get's an upgrade, then the kernel-modules needs an update too. You can check with 
```sh
apt-get update
apt-get upgrade
```
## Issues loading modules
If you see the following then you are running a firmware that currently doesn't have a module built for it.
```sh
# opt-modprobe nfsd
FATAL: Module nfsd not found.
```
This can happen if your device was updated after installation of the package.

Please reach out and send me details of your device:
```sh
# uname -a
Linux UDM 4.19.152-al-linux-v10.2.0-v1.11.0.3921-f2e3fac #1 SMP Tue Dec 21 08:05:39 UTC 2021 aarch64 GNU/Linux
```
## Usage
#### Wireguard
For detailed instructions see [here](https://github.com/tusc/wireguard-kmod) .
#### NFS
TBC...
#### CIFS
TBC...

## FAQ

<details>
  <summary>Installation of kernel module ends with "FATAL: Module XXX not found"</summary>   
    
  * The kernel package does not contain a module built for your firmware or kernel version, nor is there a built-in module in your kernel. Please open an issue and report your version `uname -a` so we can try to update the module.
</details>
<details>
  <summary>I am missing a module I really want</summary>   
    
  * You can extract the tar.gz kernel file for your device and copy the `kernel-config` as `.config` in the extraced directory and configure the kernel with `make menuconfig` and copy back the new `.config` to the base as `kernel-config`.
  * Or you can ask me to build it, but you know, I'm a busy man.
  
</details>

[^1]:See at the [wireguard-kmod](https://github.com/tusc/wireguard-kmod) project for further details.
[^2]:See at the [instructions](https://github.com/pwallner/UI-Ware/wiki) for further details.
[^3]:See at the [instructions](https://github.com/pwallner/UI-Ware/wiki) for further details.
