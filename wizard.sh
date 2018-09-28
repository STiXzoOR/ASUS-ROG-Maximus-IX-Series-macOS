#!/bin/bash

#set -x

downloads=Downloads

local_kexts_dir=Kexts
kexts_dir=$downloads/Kexts

kexts_exceptions=""

tools_dir=$downloads/Tools

hotpatch_dir=Hotpatch/Downloads

drivers_dir=$downloads/Drivers

themes_dir=Themes

if [[ ! -d macos-tools ]]; then
    echo "Downloading latest macos-tools..."
    rm -Rf macos-tools && git clone https://github.com/the-braveknight/macos-tools --quiet
fi

function showOptions() {
    echo "--download-requirements,  Download required kexts, hotpatches and tools."
    echo "--install-downloads,  Install kext(s) and tool(s)."
    echo "--install-config,  Install the config to EFI/CLOVER."
    echo "--update-config,  Update the existing config in EFI/CLOVER."
    echo "--update-kernelcache,  Update kernel cache."
    echo "-i,  inlude custom kexts while using --download-requirements option."
    echo "-h,  Show this help message."
    echo "Usage: $(basename $0) [--download-requirements -i <Author exact name:Kext(s) exact name> separated by |]"
    echo "Example: $(basename $0) --download-requirements -i 'lvs1974:HibernationFixup,AirportBrcmFixup|acidanthera:Lilu,AppleALC'"
}

function findKext() {
    find $kexts_dir $local_kexts_dir -name $1 -not -path \*/PlugIns/* -not -path \*/Debug/*
}

function removeKext() {
    sudo rm -Rf /Library/Extensions/$1 /System/Library/Extensions/$1
}

case "$1" in
    --download-tools)
        rm -Rf $tools_dir && mkdir -p $tools_dir

        macos-tools/bitbucket_download.sh -a RehabMan -n os-x-maciasl-patchmatic -o $tools_dir
        macos-tools/bitbucket_download.sh -a RehabMan -n os-x-maciasl-patchmatic -f RehabMan-patchmatic -o $tools_dir
        macos-tools/bitbucket_download.sh -a RehabMan -n acpica -o $tools_dir
    ;;
    --download-kexts)
        rm -Rf $kexts_dir && mkdir -p $kexts_dir

        # Bitbucket kexts
        macos-tools/bitbucket_download.sh -a RehabMan -n os-x-fakesmc-kozlek -o $kexts_dir
        macos-tools/bitbucket_download.sh -a RehabMan -n os-x-intel-network -o $kexts_dir
        macos-tools/bitbucket_download.sh -a RehabMan -n os-x-generic-usb3 -o $kexts_dir
        macos-tools/bitbucket_download.sh -a RehabMan -n os-x-usb-inject-all -o $kexts_dir
        macos-tools/bitbucket_download.sh -a RehabMan -n os-x-eapd-codec-commander -o $kexts_dir

        # GitHub kexts
        macos-tools/github_download.sh -u acidanthera -r Lilu -o $kexts_dir
        macos-tools/github_download.sh -u acidanthera -r AppleALC -o $kexts_dir
        macos-tools/github_download.sh -u acidanthera -r WhateverGreen -o $kexts_dir

        subcommand=$1; shift
        while getopts ":i:" option; do
            case $option in
            i)
                include_kexts=$OPTARG
            ;;
            ?)
                showOptions
                exit 0
            ;;
            esac
        done
        IFS="|" read -ra myArr <<< "$include_kexts"
        for author_kexts in "${myArr[@]}"; do
            IFS=":" read author kexts <<< "$author_kexts"
            for kext_name in $(echo $kexts | tr "," "\n"); do
                macos-tools/github_download.sh -u $author -r $kext_name -o $kexts_dir
            done
        done
    ;;
    --download-hotpatch)
        rm -Rf $hotpatch_dir && mkdir -p $hotpatch_dir

        macos-tools/hotpatch_download.sh -o $hotpatch_dir SSDT-SATA.dsl
        macos-tools/hotpatch_download.sh -o $hotpatch_dir SSDT-XOSI.dsl
    ;;
    --download-drivers)
        rm -Rf $drivers_dir && mkdir -p $drivers_dir

        curl -s https://raw.githubusercontent.com/Benjamin-Dobell/nvidia-update/master/nvidia-update.sh -o $drivers_dir/nvidia-update.sh
    ;;
    --install-apps)
        macos-tools/unarchive_file.sh -d $tools_dir
        macos-tools/install_app.sh -d $tools_dir
    ;;
    --install-binaries)
        macos-tools/unarchive_file.sh -d $tools_dir
        macos-tools/install_binary.sh -d $tools_dir
    ;;
    --install-kexts)
        macos-tools/unarchive_file.sh -d $kexts_dir
        macos-tools/install_kext.sh -d $kexts_dir -e $kexts_exceptions
        $0 --update-kernelcache
    ;;
    --install-nvidia-drivers)
        $drivers_dir/nvidia-update.sh
    ;;
    --install-essential-kexts)
        macos-tools/unarchive_file.sh -d $kexts_dir
        EFI=$(macos-tools/mount_efi.sh)
        kext_dest=$EFI/EFI/CLOVER/kexts/Other
        rm -Rf $kext_dest/*.kext
        macos-tools/install_kext.sh -s $kext_dest $(findKext FakeSMC.kext) $(findKext IntelMausiEthernet.kext) $(findKext AppleALC.kext) $(findKext WhateverGreen.kext) $(findKext USBInjectAll.kext) $(findKext Lilu.kext) $(findKext XHCI-200-series-injector.kext)
    ;;
    --remove-installed-kexts)
        # Remove kexts that have been installed by this script previously
        for kext in $(macos-tools/installed_kexts.sh); do
            removeKext $kext
        done
    ;;
    --remove-deprecated-kexts)
        # Remove deprecated kexts
        # More info: https://github.com/the-braveknight/macos-tools/blob/master/org.the-braveknight.deprecated.plist
        for kext in $(macos-tools/deprecated_kexts.sh); do
            removeKext $kext
        done
    ;;
    --update-kernelcache)
        sudo kextcache -i /
    ;;
    --install-config)
        macos-tools/install_config.sh config.plist
        $0 --install-theme
    ;;
    --install-initial-config)
        macos-tools/install_config.sh config_install.plist
        $0 --install-theme
    ;;
    --install-theme)
        EFI=$(macos-tools/mount_efi.sh)
        themes_dest=$EFI/EFI/CLOVER/themes
        cp -r $themes_dir/HexagonDark $themes_dest
    ;;
    --update-config)
        macos-tools/install_config.sh -u config.plist
    ;;
    --update)
        echo "Checking for updates..."
        git stash --quiet && git pull
        echo "Checking for macos-tools updates..."
        cd macos-tools && git stash --quiet && git pull && cd ..
    ;;
    --download-requirements)
        $0 --download-kexts $2 $3
        $0 --download-tools
        $0 --download-hotpatch
        $0 --download-drivers
    ;;
    --install-downloads)
        $0 --install-binaries
        $0 --install-apps
        $0 --install-nvidia-drivers
        $0 --remove-deprecated-kexts
        $0 --install-essential-kexts
        $0 --install-kexts
    ;;
esac
