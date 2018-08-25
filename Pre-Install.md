# Pre-Install

## Necessities:
* 8GB+ USB stick
* Computer running MacOS (If you do not have a computer running MacOS, ask a friend/family member or check out how to make a Virtual Machine running MacOS on windows [here](https://techsviewer.com/install-macos-high-sierra-vmware-windows/).)
* A lot of time (remember: This is not something you do in 30 minutes and are done with forever.)
* A copy of the **full** High Sierra or Mojave installer

## Step 1 - Making a bootable USB
Open up Disk Utility and select your USB **drive**, not the partition, and click erase. 

(If you cannot see your drive, click on show in the top left corner and select "Drives".)

For "Format", you want to select MacOS Extended (journaled) or APFS (journaled). For "Partition Scheme", you want to select "GUID Partition Table". Click Erase and wait until the process is finished. 

(If the process fails, try again. This has happened to me several times on (High) Sierra's Disk Utility with different PCs.)

Rename your USB to "install_osx".

## Step 2
Open up App Store on your MacOS VM or computer and search for Install High Sierra (hotlink [here](https://itunes.apple.com/us/app/macos-high-sierra/id1246284741?mt=12))

Check if you have the full installer, the size should be 4.8GB in total.

Open Terminal and run the following command

##### For Mojave: 
```
sudo "/Applications/Install macOS Mojave Beta.app/Contents/Resources/createinstallmedia" --volume /Volumes/install_osx --nointeraction
```

##### For High Sierra: 
```
sudo "/Applications/Install macOS High Sierra.app/Contents/Resources/createinstallmedia" --volume /Volumes/install_osx --nointeraction
```

This will make a bootable USB to install macOS with, let the process run until it finishes.

## Step 3 - Install Clover
Download the latest version of clover from [here](https://github.com/Dids/clover-builder/releases) (click `Clover_vx.x_rxxxx.pkg`, should be ~18mb)

Right click (or CMD+click) on the package and click Open, you will get a prompt telling you that the software is from an unidentified developer instead. ([how to disable this](http://osxdaily.com/2016/09/27/allow-apps-from-anywhere-macos-gatekeeper/))

Click Continue, Continue, Agree and Agree. Now, click Customize and select the following:

##### For booting Clover UEFI:
```
- check "Install for UEFI booting only", "Install Clover in the ESP" will automatically select
- check "BGM" from Themes
- check "HFSPlus", "AptioMemoryFix-64" and "EmuVariableUefi-64" from "UEFI Drivers"
- if you are installing in APFS mode, check "ApfsDriverLoader-64" from "UEFI Drivers"
- most systems will work without DataHubDxe-64.efi, but some may require it
```

##### For booting Legacy:
```
- check "Install Clover in the ESP"
- in "Bootloader", check "Install boot0af in MBR" ("Install boot0ss in MBR" for HDD install if dual-boot Windows)
- "CloverEFI" should be checked
- check "BGM" from Themes 
```

## Step 3 - Downloading Kexts
We are now going to install some kernel extensions (often referred to as "kexts") necessary for booting at all. 

##### To start, the developer tools must be installed, if you don't have them already. Run Terminal, and type:
```
git
```

You will be prompted to install the developer tools. Since you have internet working, you can choose to have it download and install them automatically. Do that before continuing.
After the developer tools are installed, we need to make a copy of the project on github.

##### In Terminal:
```
mkdir ~/Projects
cd ~/Projects
git clone https://github.com/STiXzoOR/ASUS-ROG-MAXIMUS-IX-Series-macOS asus_rog_maximus_ix_series.git
cd asus_rog_maximus_ix_series.git
```

##### To download the kexts & tools, in Terminal:
```
./wizard.sh --download-requirements
```

##### To install kexts to EFI, in Terminal:
```
./wizard.sh --install-essential-kexts
```

## Step 4 - Pre-configured config.plist

##### To install the pre-configured config.plst to EFI, in Terminal:
```
./wizard.sh --install-initial-config
```

## Step 5 - BIOS/UEFI settings

Change the following settings before you boot into the macOS installer:

* Exit → Load Optimized Defaults : Yes
* Extreme Tweaker → Ai Overclock Tuner : XMP
* Extreme Tweaker → Xtreme Tweaking : Enabled
* Advanced \ CPU Configuration → Intel Virtualizaiton Technology: Enabled
* Advanced \ System Agent (SA) Configuration → Vt-d: Disabled
* Advanced \ PCH Configuration → IOAPIC 24-119 Entries: Enabled
* Advanced \ Onboard Devices Configuration → RGB LED Lighting → When system is in sleep, hibernate or soft off states: OFF
* Advanced \ AMP Configuration → Power On By PCI-E/PCI: Enabled
* Advanced \ Network Stack Configuration → Network Stack: Disabled
* Advanced \ USB Configuration → Legacy USB Support: Auto
* Advanced \ USB Configuration → XHCI Hand Off : Enabled
* Boot → Fast Boot : Disabled
* Boot → Secure Boot → OS Type : Other OS

Based on the GPU you’re using, change the following settings:

- Dedicated graphics card:
  - Advanced \ System Agent (SA) Configuration \ Graphics Configuration → Primary Display: PEG
- Intel iGPU:
  - Advanced \ System Agent (SA) Configuration \ Graphics Configuration → Primary Display: IGFX
  - Advanced \ System Agent (SA) Configuration \ Graphics Configuration → iGPU Multi-Monitor: Enabled
  - Advanced \ System Agent (SA) Configuration \ Graphics Configuration → DVMT Pre-Allocated: 128MB/192MB (If you cannot change this, check out the info [here](Tips.md#intelgraphicsdvmtfixup))

All done! You can now boot into the macOS installer.
Checkout how to install macOS on a mac [here](https://support.apple.com/en-us/HT204904).

If you get an error while booting, check [troubleshooting](Trobleshooting.md).
