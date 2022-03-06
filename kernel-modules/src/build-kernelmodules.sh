#!/bin/bash
# Build the kernel modules for the UDM.

set -e

if [ ! -f "buildroot-2017.11.1/Config.in" ]
then
   if [ ! -f buildroot-2017.11.1.tar.bz2 ]
   then
      wget https://buildroot.org/downloads/buildroot-2017.11.1.tar.bz2
   fi
   tar -xvjf buildroot-2017.11.1.tar.bz2

   # copy packages and patches and add wireguard to buildroot menu selection
   cp -pr packages/* buildroot-2017.11.1/package
   for patch in patches/*.patch; do
	   patch -p0 < "$patch"
   done

   # run make clean after extraction
   (cd buildroot-2017.11.1 && make clean || true)
fi

cd buildroot-2017.11.1

if [ -f "base-version" ]; then
	last_base_used="$(cat base-version)"
fi
for base in ../bases/*/;
do
   # Exit if required kernel package does not exist.
   kernel_pkg=$(grep LINUX_KERNEL_CUSTOM_TARBALL_LOCATION "${base}/buildroot-config.txt" |
	   sed -En s/".*(linux-.*.tar.gz).*"/"\1"/p)
   if [ ! -f "../bases/${kernel_pkg}" ]; then
	   echo "Error: Linux kernel package ${kernel_pkg} not found. You need to download it to this directory."
	   exit 0
   fi

   # Use the configuration for the current base version.
   cp "${base}/buildroot-config.txt" ./.config
   cp "${base}/kernel-config" ./
   rm -rf ./linux-patches ./patches
   if [ -d "${base}/linux-patches" ]; then
      cp -rf "${base}/linux-patches" ./
   fi
   if [ -d "${base}/patches" ]; then
	   cp -rf "${base}/patches" ./
   fi
   rm -rf output/build/linux-*
   versions="$(cat ${base}/versions.txt)"
   prefix="$(cat ${base}/prefix)"
   arrIN=(${prefix//-/ })
   (IFS=','
   for ver in $versions; do
	# Skip building modules if already built.
	if [ -d "../kernel-modules/${prefix}${ver}" ]; then
  		echo "Skipping already built kernel modules for version ${prefix}${ver}."
		continue
	elif [[ -d "../kernel-modules/${arrIN[0]}" && ${arrIN[0]} == "4.4.198" ]]; then
		echo "Skipping already built kernel modules for version ${prefix}${ver} (${arrIN[0]})."
		continue
	fi

	# Cleanup if current base is different than last base used.
	if [ "${base}" != "${last_base_used}" ]; then
		rm -rf output/build/linux-*
		echo "${base}" > base-version
		last_base_used=${base}
	fi

	echo "Removing old compiled modules for version ${prefix}${ver}."
	rm -rf output/target/lib/modules/${prefix}${ver}

	echo "Building kernel version ${prefix}${ver} using base ${base}."
	make wireguard-linux-compat-dirclean
	sed -i -e '/CONFIG_LOCALVERSION=/s/.*/CONFIG_LOCALVERSION="'$ver'"/' kernel-config
	make wireguard-linux-compat-rebuild -j6
	   
	#Copy complete kernel modules
	if [ -d "./output/target/lib/modules/${prefix}${ver}" ]; then
		cp -r ./output/target/lib/modules/${prefix}${ver}  ../kernel-modules/${prefix}${ver}
	else
		cp -r ./output/target/lib/modules/${arrIN[0]}  ../kernel-modules/${arrIN[0]}
	fi
   done)
done

echo "Building archive kernel-modules-`date +%Y-%m-%d`.tar.Z"
cd ..
tar -cvzf ../releases/kernel-modules-`date +%Y-%m-%d`.tar.Z kernel-modules/
echo "Finished building kernel modules!"
