#!/bin/bash

repo_dir=$(dirname ${BASH_SOURCE[0]})

macos_tools=$repo_dir/macos-tools

if [[ ! -d $macos_tools ]]; then
    echo "Downloading latest macos-tools..."
    rm -Rf $macos_tools && git clone https://github.com/the-braveknight/macos-tools $macos_tools --quiet
fi

themes_dir=$repo_dir/Themes
config_install_plist=$repo_dir/config_install.plist

source $macos_tools/_hack_cmds.sh

drivers_dir=$downloads_dir/Drivers

case "$1" in
    --install-nvidia-drivers)
        rm -Rf $drivers_dir && mkdir -p $drivers_dir

        curl -fsSL https://raw.githubusercontent.com/Benjamin-Dobell/nvidia-update/master/nvidia-update.sh -o $drivers_dir/nvidia-update.sh
        sudo chmod +x $drivers_dir/nvidia-update.sh
        $drivers_dir/nvidia-update.sh
    ;;
    --install-theme)
        EFI=$($macos_tools/mount_efi.sh)
        themes_dest=$EFI/EFI/CLOVER/themes
        echo "Copying HexagonDark to $themes_dest"
        cp -r $themes_dir/HexagonDark $themes_dest
    ;;
    --install-initial-config)
        installConfig $config_install_plist
        $0 --install-theme
    ;;
esac
