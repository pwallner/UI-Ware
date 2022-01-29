## Building the Kernel Modules

**Author:** Patrick Wallner

1. Make sure you have Git LFS installed on your system, which you will need to download the kernel sources. This is sometimes an extra package you have to download from your distro's package manager. Once you install it, make sure to run the following to install LFS:

    ```sh
    git lfs install
    ```

2. Clone the kernel-modules repository onto your computer and go into the directory. 

    ```sh
    git clone https://github.com/pwallner/UI-Ware.git
    cd kernel-modules/src
    ```

3. Check that the device kernel sources downloaded correctly by examining that their file sizes are ~100MB+ each.

    ```sh
    ls -lh bases/*.tar.gz
    ```

    * If the size is a few bytes instead of 100MB, then the kernel sources did not download correctly. This is most probably due to Git LFS not being installed or the LFS quota being exceeded.
    * If you are having trouble with Git LFS, you can download the files manually through the [GitHub web interface](https://github.com/pwallner/UI-Ware/tree/main/kernel-modules/src/bases).

4. The build is divided into multiple kernel bases, where each kernel base is used for multiple firmware versions. Add any custom versions you want to build to the `versions.txt` file in the correct base folder (for example `udm-<BASE_VERSION>`).

    * Your firmware version can be found by running `uname -r` on the UDM and taking the end `-vX.Y.Z.xxxx-yyyyyyy` suffix, where X.Y.Z is your UDM version. Look at the other `versions.txt` files for what it should look like.

5. Run `build-kernelmodules.sh` in this directory to build the kernel modules for each version in the `versions.txt` files.

    ```sh
    ./build-kernelmodules.sh
    ```

    * This will take anywhere from 20 minutes to a couple of hours depending on the CPU power of your system.

6. If successful, you should find:

    * The newly built kernel modules under the `kernel-modules` directory in the current folder
    * A newly built tarball named `kernel-modules-YYYY-MM-DD.tar.Z` in the releases folder one directory up (`../releases`) that you can install on your device following the regular instructions in the main [README](https://github.com/pwallner/UI-Ware/blob/main/kernel-modules/README.md).
        * You can transfer the tarball or modules to your device using `scp`. For example, assuming your device is at 192.168.1.254, the following command will transfer the tarball to the your device's `/mnt/data` directory.
            ```sh
            scp ../releases/kernel-modules-2022-01-25.tar.Z root@192.168.1.254:/mnt/data
            ```

7. If building multiple times, the build script will skip building previously built modules. If you want to force re-build everything, then delete the previously built kernel module folder from the `kernel-modules` folder first.

    ```sh
    rm -rf kernel-modules/*
    ```
