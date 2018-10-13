#!/bin/bash

repo_dir=$(dirname ${BASH_SOURCE[0]})

macos_tools=$repo_dir/macos-tools

if [[ ! -d $macos_tools ]]; then
    echo "Downloading latest macos-tools..."
    rm -Rf $macos_tools && git clone https://github.com/the-braveknight/macos-tools $macos_tools --quiet
fi

downloads_dir=$repo_dir/Downloads
local_kexts_dir=$repo_dir/Kexts
hotpatch_dir=$repo_dir/Hotpatch/Downloads
themes_dir=$repo_dir/Themes
drivers_dir=$downloads_dir/Drivers
repo_plist=$repo_dir/org.stixzoor.maximus-ix.plist

deprecated_plist=org.stixzoor.deprecated.plist
essentials_plist=org.stixzoor.essentials.plist

source $macos_tools/_hack_cmds.sh

case "$1" in
    --download-drivers)
        rm -Rf $drivers_dir && mkdir -p $drivers_dir

        curl -s https://raw.githubusercontent.com/Benjamin-Dobell/nvidia-update/master/nvidia-update.sh -o $drivers_dir/nvidia-update.sh
    ;;
    --install-nvidia-drivers)
        $drivers_dir/nvidia-update.sh
    ;;
    --install-theme)
        EFI=$($macos_tools/mount_efi.sh)
        themes_dest=$EFI/EFI/CLOVER/themes
        echo "Copying HexagonDark to $themes_dest"
        cp -r $themes_dir/HexagonDark $themes_dest
    ;;
    --install-config)
        installConfig $repo_dir/config.plist
        $0 --install-theme
    ;;
    --install-initial-config)
        installConfig $repo_dir/config_install.plist
        $0 --install-theme
    ;;
    --update-config)
        updateConfig $repo_dir/config.plist
    ;;
esac
