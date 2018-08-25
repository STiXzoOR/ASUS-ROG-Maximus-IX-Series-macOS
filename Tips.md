# Tips
## How to mount EFI
Open Terminal and run `diskutil list`, this will show you all your available Volumes. Look up your disk's name and remember the disk identifier that corresponds with your disk (this should look something like diskX). Once you're sure you have the right disk identifier that corresponds with your disk, run `diskutil mount diskXs1`, with the X being your disk number.

If you have only one EFI partition, you can also run `diskutil mount EFI`.

You can also mount your EFI partition with Clover Configurator.

## How to install kexts
A small disclaimer first, please try to inject kexts whenever you can. There is a possibility that if you update, your kexts will be deleted because they're in a place they're not supposed to be in if you install them to either `/Library/Extensions` or `/System/Library/Extensions`. You should only install kexts to one of these locations if the author of the kexts tell you to do so.

To inject a kext, [mount your EFI]((Tips.md#how-to-mount-efi)) and go to /EFI/EFI/Clover/kexts/Other and place your kext(s) in there. Also make sure that `InjectKexts` is set to `Yes` inside of your config.plist.

## How to know if you need to hot-patch DSDT
Download [IOREG](http://mac.softpedia.com/get/System-Utilities/IORegistryExplorer.shtml) and search for what a patch tells you to replace in it's comment.

- Example:
So let's say you want to rename HDAS to HDEF, please search if you even have HDEF first and if you do, this patch is not needed. If you do not have HDEF, apply the patch and reboot. You should now see HDEF in your IOREG

Be **very** careful while entering the patching info.

## Choosing a SMBIOS
An SMBIOS will mask your system as an iMac, Macbook or Mac Pro.

There are a lot of SMBIOSes, you need to pick the correct one for your hardware. Here are some examples:
* iMac14,1 for Haswell (ix-4xxx) systems **without** a dgpu.
* iMac14,2 for Haswell (ix-4xxx) systems **with** a dgpu.
* iMac15,1 for Z97 motherboads.
* iMac17,1 for Skylake (ix-6xxx).
* iMac18,2 for Kaby-Lake i5s (i5-7xxx) systems.
* iMac18,3 for Kaby-Lake i7s (i7-7xxx) systems.
* iMac18,2 for Coffee-Lake i5s (i5-8xxx) systems.
* iMac18,3 for Coffee-Lake i7s (i7-8xxx) systems.
* MacPro6,1 for X99, X299, X399 motherboards.

## WhateverGreen (former NvidiaGraphicsFixup) and some SMBIOSes explained
Because of the way how vanilla iMacs work, a small piece of a kernel extension that comes with macOS needs to be modified to prevent a black screen on some SMBIOSes after booting. Here is the list of affected SMBIOSes:
* iMac15,1 and up (iMac17,1, iMac18,x)
* MacPro6,1

You do not have to manually modify anything inside of the kext that causes this issue since [lvs1974](https://github.com/lvs1974) made a kext, called [NvidiaGraphicsFixup](https://github.com/lvs1974/NvidiaGraphicsFixup), to patch this issue. You will need to install Lilu and NvidiaGraphicsFixup to apply this patch.

NvidiaGraphicsFixup can do a lot of things:
* Adds the AGDP fix to iMac15,1;, iMac17,1;, iMac18,x and MacPro6,1 SMBIOSes to prevent a black screen after boot.
* Modifies macOS to recognize NVIDIA's web drivers as platform binaries. This resolves the issue with transparent windows without content, which appear for applications that use Metal and have Library Validation enabled. Common affected applications are iBooks and Little Snitch Network Monitor, though this patch is universal and fixes them all.
* Injects IOVARendererID into GPU properties (required for Shiki-based solution for non-freezing Intel and/or any discrete GPU)
* Allows to use ports HDMI, DP, Digital DVI with audio (Injects @0connector-type - @5connector-type properties into GPU)

Since this kext is replaced by WhateverGreen now, you can download WhateverGreen kext from [here](https://github.com/acidanthera/WhateverGreen). How to install [here](Tips.md#how-to-install-kexts)

## WhateverGreen (former IntelGraphicsDVMTFixup)
Quoted from [the IntelGraphicsDVMTFixup Github repo](https://github.com/BarbaraPalvin/IntelGraphicsDVMTFixup):
`
A common problem with Broadwell/Skylake/KabyLake is relatively small DVMT-prealloc setting by PC OEMs. The Apple framebuffer kexts generally assume 64mb or larger, and most PC OEMs use only 32mb. And often, there is no way to change it easily due to limited BIOS, locked down BIOS, etc.
`

In other words, this kext is meant for users who have now ay to change the pre-allocated DVMT.

This kext features the following:
* Fixes an issue related to a DVMT panic when entering the installation screen.
* Fixes the need for "FakeID = 0x12345678" in the config.plist.

Since this kext is replaced by WhateverGreen now, you can download WhateverGreen kext from [here](https://github.com/acidanthera/WhateverGreen). How to install [here](Tips.md#how-to-install-kexts)

## USBInjectAll
This kext injects all available USB ports to the OS. This is absolutely necessary when installing, you will get the `Still waiting for root device...` hang otherwise.

Only Intel controllers are currently supported and the most commonly used SMBIOS model identifiers are in the kext.

[link to repo](https://github.com/RehabMan/OS-X-USB-Inject-All)

Patches needed:
- Port limit patch (raw XML)
```plist
<dict>
    <key>Comment</key>
    <string>change 15 port limit to 26 in XHCI kext</string>
    <key>MatchOS</key>
    <string>10.13.x</string>
    <key>Name</key>
    <string>com.apple.driver.usb.AppleUSBXHCIPCI</string>
    <key>Find</key>
    <data>g32MEA==</data>
    <key>Replace</key>
    <data>g32MGw==</data>
</dict>
```

- Clover configurator friendly:
```
Comment: change 15 port limit to 26 in XHCI kext
Name:    com.apple.driver.usb.AppleUSBXHCIPCI
Find:    837d8c10
Replace: 837d8c1b
```

DSDT Patches (All of these are Clover Configurator friendly, raw patches [here](https://github.com/RehabMan/OS-X-USB-Inject-All/blob/master/config_patches.plist#L8-L53)):
(DISCLAIMER: These patches should only be used when they are needed. More info [here](Tips.md#how-to-know-if-you-need-to-hot-patch-dsdt))

```
Comment: change _OSI to XOSI
Find:    5f4f5349
Replace: 584f5349
```

```
Comment: change EHC1 to EH01
Find:    45484331
Replace: 45483031
```

```
Comment: change EHC2 to EH02
Find:    45484332
Replace: 45483032
```

```
Comment: change XHCI to XHC
Find:    58484349
Replace: 5848435f
```

```
Comment: change XHC1 to XHC
Find:    58484331
Replace: 5848435f
```

## Nvidia Web drivers not kicking in
If you have NvidiaWeb checked in your config and webdrivers are still not working, try the following:

* Open Terminal and do the following one line at a time:
    * `sudo -s`
    * `nvram -c`
    * `nvram myvar=test`
    * `exit`
* Reboot
* Open Terminal and do `nvram -p | grep -i myvar`

If you don't get any output fromt the last command, install EmuVariableUefi-64.efi and the RC Scripts via the [latest clover install package](https://github.com/Dids/clover-builder/releases/latest/).

## Installing macOS on a windows drive (dualboot)
Before we go into this section, you must know the difference between GPT and MBR Partition Tables.
A partition table is a table maintained on disk by the operating system describing the partitions on that disk.

GPT is used for UEFI OSes, MBR on the other hand is common to be used for Legacy OSes. Windows supports both, only it's standard partition table is set to MBR. macOS doesn't like MBR a lot, so that's why you need to convert your windows disk to GPT.

There is [software](https://docs.microsoft.com/en-us/windows/deployment/mbr-to-gpt) around that can do this for you, without having to wipe the entire disk and losing all your data. (Disclaimer: This will not work unless you have Windows 10 Creator's Update (version 1703) or later (check by running `winver` in Run or typing it in Cortana/Start menu). It has been embedded in Windows' systems.)

You should run this program on your windows disk, so that it's converted to GPT. Now you're ready to install macOS on there

## AptioMemoryFix & AptioInputFix explained
If you wanted to boot macos succesfully, you needed one of the following:
* OsxAptioFix
* OsxAptioFix**2**
* OsxAptioFix-Free2000 (generally used with X99)

These fixed some issues with the macos kernel and memory.

There's now a new EFI driver to replace OsxAptioFix2, called AptioMemoryFix. This *should* cure NVRAM in most cases and end the need for custom slide values.

AptioInputFix shims the AMI Keycode protocol onto the Apple KeyMap protocols and fixes the global timer to prevent pointer coordinate overflows.

I really, **really** recommend you to use this new driver. The old ones are busted and do not provide the level of patching this one brings.

Here's some advice about the new driver by someone who knows how it works: (Credits to Reddestdream)

![alt text](https://raw.githubusercontent.com/camielverdult/Ramblings-of-a-hackintosher-High-Sierra/master/Pictures/The%20new%20hotness.png)

Me and a lot of hackintoshers advice you to switch over to the new efi drivers.

### Sounds good! Where do I get it?
AptioMemoryFix and AptioInputFix are both able to be installed via the clover install package (latest [here](https://github.com/Dids/clover-builder/releases/latest)).

You can take a look at [the repo on github](https://github.com/acidanthera/AptioFixPkg) for more information.