<p align="center">
  <img class="comment" src="https://github.com/pwallner/UI-Ware/raw/main/images/UIWare.svg" alt="UI-Ware"/>
</p>

# UI-Ware for UnifiOS (UDM, UDR, UXG)
[![LICENSE](https://shields.io/badge/License-GPL-lightgrey)](https://raw.githubusercontent.com/pwallner/UI-Ware/main/LICENSE)
[![Donate to this project using PayPal](https://shields.io/badge/Paypal-Donate-blue?logo=paypal&style=flat)](https://www.paypal.com/donate/?business=2667RS4MQ9M5Y&no_recurring=1&item_name=Please+support+me+if+you+like+my+work.+Thank+you%21&currency_code=EUR)
[![Donate to this project using Buy Me A Coffee](https://shields.io/badge/By%20me%20a%20coffee-Donate-yellow?logo=buymeacoffee&style=flat)](https://buymeacoff.ee/mcpat)


## Project Notes

**Author:** Patrick Wallner

Based on Optware, a software repository for embedded devices which use the [Linux kernel](https://www.kernel.org/linux.html), arised the idea of UI-Ware for UnifiOS devices. Installing UI-Ware allow users to take advantage by adding software to the device which permits it to perform new tasks or provide other features besides those they were marketed for, or simply to perform those functions better.

Please see below for instructions on how to install UI-Ware and associated utils.

## Table of Contents

  * [Install](#install)
  * [Surviving Reboots](#surviving-reboots)
  * [How to use UI-Ware](#how-to-use-ui-ware)
  * [Upgrades](#upgrades)
  * [Packages](#packages)
  * [The future of UI-Ware](#the-future-of-ui-ware)
  * [Support my work](#support-my-work)
  * [FAQ](#faq)


## Install
1. We first need to download the tar file onto the device. Connect to it via SSH and type the following command to download the tar file. NOTE: always [this link](https://github.com/pwallner/UI-Ware/releases) check for the latest release.

    ```sh
    curl -LJo wireguard-kmod.tar.Z https://github.com/pwallner/UI-Ware/releases/download/v1.0/ui-ware-1.0.tar.Z
    ```

2. From this directory type the following to extract the files:

	* For the UDM, UDM-Pro, UDM-SE, or UXG-Pro, extract the files into `/mnt/data/opt`
	
		```sh
		tar -C /mnt/data -xvzf ui-ware-1.0.tar.Z
		```
	* For the UDR, extract the files into `/data/opt`
	
		```sh
		tar -C /data -xvzf ui-ware-1.0.tar.Z
		```

2. Once the extraction is complete, cd into `/mnt/data/opt` (or `/data/opt` for UDR) and run the script **setup-uiware.sh** as shown below
    ```
    cd /mnt/data/opt
    chmod +x setup-uiware.sh
    ./setup-uiware.sh
    ```
 This will setup the complete ui-ware system to `/mnt/data/opt` or `/data/opt` as well as create a link to the `/opt` folder and finally load the basic apps which are needed.  

## Surviving Reboots
> ⚠️ **You will need to run setup-uiware.sh whenever the UDM is rebooted as the symlink to `/opt` have to be recreated.** 

* For the UDM or UDM Pro, Boostchicken has a package that can be installed to automatically run the UI-Ware script anytime the router is rebooted. Just follow the instructions [here](https://github.com/boostchicken/udm-utilities/tree/master/on-boot-script) and drop the **10-uiware.sh** script into the `/mnt/data/on_boot.d` directory when finished.
* For the UDM-SE or UDR, create a systemd boot service to run the setup script at boot by running the following commands:
	
	```sh
	curl -Lo /etc/systemd/system/setup-uiware.service https://raw.githubusercontent.com/pwallner/UI-Ware/main/src/boot/setup-uiware.service
	systemctl daemon-reload
	systemctl enable setup-uiware
	```
* Note this only adds the setup script to start at boot. If you also want to bring up some apps at boot, you will need to use additional boot scripts.

## How to use UI-Ware
It's like a debian system, use the `apt` commands like `apt-get update` `apt-get upgrade` and the most important one `apt-get install <package>`.

## Upgrades
Upgrades are not really necessary caused by the `apt` feature. But if something happens, you can "safely" download new versions and extract over prior releases. Please note, that all basic files will be overwritten, all other files will stay untouched.

## Packages
The main reason for developing the UI-Ware were the missing features:
 - NFS server/client for easy exchange of data
 - CIFS server (client) for easy exchange of data
 - OpenVPN server (client)
 - Wireguard[^1]
 - FTP server

But during developing of the first feature (NFS), I generated 170 software packages because I was compiling directly on my own UDM. Don't ask why, I had my reasons...

So I can provide now additionly fully functional apps:

 - GCC 6.4.0
 - Automake
 - Autoconf
 - Make
 - Openssl 1.1.1
 - wireguard tools
 - ftp
 - wget (with SSL support)
 - tar
 - Git
 
and many many more.
## The future of UI-Ware
TBC...

## Support my work
I'm a working single dad and this is only my hobby which I did in my rare free time. So I really appreciate if you make a small donation to let me buy some sweets for my son!

[!["Buy Me A Coffee"](https://github.com/pwallner/UI-Ware/raw/main/images/coffee.png)](https://buymeacoff.ee/mcpat)
[![Support via PayPal](https://github.com/pwallner/UI-Ware/raw/main/images/paypal.svg)](https://www.paypal.com/donate/?business=2667RS4MQ9M5Y&no_recurring=1&item_name=Please+support+me+if+you+like+my+work.+Thank+you%21&currency_code=EUR)
<!-- [![Donate](https://www.paypalobjects.com/en_US/AT/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/donate/?business=2667RS4MQ9M5Y&no_recurring=1&item_name=Please+support+me+if+you+like+my+work.+Thank+you%21&currency_code=EUR) -->
[![Donate](https://github.com/pwallner/UI-Ware/raw/main/images/QR-Code.png)](https://www.paypal.com/donate/?business=2667RS4MQ9M5Y&no_recurring=1&item_name=Please+support+me+if+you+like+my+work.+Thank+you%21&currency_code=EUR)
## FAQ

<details markdown='1'>

<summary>A package is missing in the repo, what can I do</summary>
	
 - Send a request, you know I'm a busy man, but maybe I can help
 - Compile a package, send it to me, I can add it to the repo[^2]

</details>

[^1]:Special thx to the [wireguard-kmod](https://github.com/tusc/wireguard-kmod) team for support and the code which I can use.
[^2]:See guidelines to follow [TBC]
