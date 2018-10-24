# Post-Install

## Necessities:
* macOS installed

## Step 1 - Installing clover to disk
This process is pretty similar to installing clover to the bootable usb in the pre-install section

Download the latest version of clover from [here](https://github.com/Dids/clover-builder/releases) (click `Clover_vx.x_rxxxx.pkg`, should be ~18mb)

Right click (or CMD+click) on the package and click Open, you will get a prompt telling you that the software is from an unidentified developer instead. ([how to disable this](http://osxdaily.com/2016/09/27/allow-apps-from-anywhere-macos-gatekeeper/))

Click Continue, Continue, Agree and Agree. Now, click Customize and select the following:

For booting Clover UEFI:
```
- check "Install for UEFI booting only", "Install Clover in the ESP" will automatically select
- check "BGM" from Themes
- check "HFSPlus", "AptioMemoryFix-64" and "EmuVariableUefi-64" from "UEFI Drivers"
- if you are installing in APFS mode, check "ApfsDriverLoader-64" from "UEFI Drivers"
- most systems will work without DataHubDxe-64.efi, but some may require it
```

For booting Legacy:
```
- check "Install Clover in the ESP"
- in "Bootloader", check "Install boot0af in MBR" ("Install boot0ss in MBR" for HDD install if dual-boot Windows)
- "CloverEFI" should be checked
- check "BGM" from Themes 
```

Select your HDD/SSD drive and click Install.

## Step 2 - Kexts
Now we're going to install our kexts (kernel extensions), just like we did in the [Pre-Install](Pre-Install.md#step-3---downloading-kexts).

To start, the developer tools must be installed, if you don't have them already. Run Terminal, and type:
```
git
```

You will be prompted to install the developer tools. Since you have internet working, you can choose to have it download and install them automatically. Do that before continuing.
After the developer tools are installed, we need to make a copy of the project on github.

In Terminal:
```
mkdir ~/Projects
cd ~/Projects
git clone https://github.com/STiXzoOR/ASUS-ROG-MAXIMUS-IX-Series-macOS asus_rog_maximus_ix_series.git
cd asus_rog_maximus_ix_series.git
```

To download the kexts & tools, in Terminal:
```
./wizard.sh --download-requirements
```

To install kexts and tools:
```
./wizard.sh --install-downloads
```

## Step 3 - Pre-configured config.plist

To install the pre-configured config.plst to EFI, in Terminal:
```
./wizard.sh --install-config
```

## Step 4 - Custom Theme

To install the custom theme to EFI, in Terminal:
```
./wizard.sh --install-theme
```

## Step 5 - Graphics Drivers
### If you're using an AMD GPU you can skip this step.

To install Nvidia Web Drivers, in Terminal:
```
./wizard.sh --download-drivers
./wizard.sh --install-nvidia-drivers
```

If your WebDrivers are not functioning properly (you check this by clicking the NVIDIA driver button in the top bar),you  need to check if your NVRAM is working the way it should be. For more in-depth [click here](Tips,md#nvidia-web-drivers-not-kicking-in).

## Step 6 - ACPI Patches

##### To finish the setup, we need a correctly patched ACPI, in Terminal:
```
cd ~/Projects/asus_rog_maximus_ix_series.git
make
make install
```
