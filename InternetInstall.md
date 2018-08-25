# Install macOS/X directly from the internet

**SKILL LEVEL:** ★★★☆☆

Some of us encounter that moment in our macOSx86 journey when we want to install macOS without any macOS access or just too lazy and to setup all that crap that needs space and whatnot, and thankfully there is a simple solution that is already available on real macs which is Internet Recovery. However, unlike real macs, we will need to download the recovery and make a USB installer of it and run it with our beloved Clover. Also this method has been around for a good long time, but since a lot of people didn't know it, sharing is caring.
***
### Disclamer
*This guide is for experienced people, novice fellows can still follow this (usually since a lot of them don’t have access to a macOS device) but will need some extra researches and finding on their own.*

*By following this guide, you accept that you will assume all responsibilities on your hardware/software and life and what you have if anything goes wrong. NOBODY HERE, INCLUDING ME, WILL BE TAKEN RESPONSIBLE OF SOMETHING GOING WRONG BUT YOU!*

*THIS GUIDE IS TO BE USED IN PARALLEL WITH THE OTHER GUIDES/PARTS IN THIS REPO, MAKE SURE YOU READ THEM FIRST. THIS IS NOT A BEGINNER GUIDE, BUT ALSO NOT EXPERT ORIENTED ONE EITHER.*
***
To begin with, make sure you have this:

* You have some basic knowledge on what you're doing (what's a kext, what's clover, what's UEFI, what's NVRAM, how/where to install kexts, how to inject kexts with clover, clover's config.plist, what is a DSDT/SSDT…). ***I will not be giving a beginner lesson in this guide***, so you better have you friend Google or father DuckDuckGo. (You can get close to Bing, but that's the girl you shouldn't be with). Also, you should know your way around issue and how you track it and fix it, add -v and debug=0x100 to keep the KP shown to know where the issue is. 
* A Hackable/hacked computer
	* If you already installed macOS and need reinstalling, your clover folder will be needed, so no need to make a new one
* A **fast** internet
	* 20Mbps to get this procedure done in an hour and half, the faster the better. Having less than that means you’ll be waiting even more (to put it into perspective, a fast laptop with an nvme SSD and an i7 6th gen HQ cpu, but with 4.7Mbps internet speed, will take about 3 to 4 hours, an equally specced device with a 20Mbps internet will take about an hour)
* An access to a **LAN** cable or a reliable WiFi connection
	- I recommend a good LAN cable than WiFi, since most LAN devices now are compatible (mostly intel and Realtek), they are fast and very reliable with low possibilities of cuttings or disturbances. Wifi on the other hand needs extra patches and/or kexts and may or may not work OOB, but if you know how to make it work and really don’t have a LAN access, you’re free to try it.
* A 4GB USB
	- No need for big USBs, a 4GB one is just enough
* A Windows computer access with Administrative rights
	- You can do this too on macOS, I’ll talk about it later, but this guide is mainly for people without macOS access.
* Your Clover folder and kexts
	- If you’re new here, make your clover folder from the Pre-Intall guide: [Step 3](https://github.com/camielverdult/Ramblings-of-a-hackintosher-High-Sierra/blob/master/Pre-Install.md#step-3---downloading-kexts) and [Step 4](https://github.com/camielverdult/Ramblings-of-a-hackintosher-High-Sierra/blob/master/Pre-Install.md#step-4---setting-up-the-configplist), also on some setups (desktops, you may need to check [Step 5](https://github.com/camielverdult/Ramblings-of-a-hackintosher-High-Sierra/blob/master/Pre-Install.md#step-5---biosuefi-settings). Laptop users, you can check [Step 3](https://github.com/camielverdult/Ramblings-of-a-hackintosher-High-Sierra/blob/master/Pre-Install.md#step-5---biosuefi-settings), add to the mix [VoodooPS2Controller](https://github.com/RehabMan/OS-X-Voodoo-PS2-Controller) and using config.plist from the closest setup found in this [repo](https://github.com/RehabMan/OS-X-Clover-Laptop-Config). (Credits for VoodooPS2Controller and the config.plist repo to Rehabman)
	- If you already have a working Clover folder (without DSDT/SSDT preferably), you're good to go.
* An AppleID (~~**MENDATORY**~~, maybe, some reported it wasnt needed, having one wont hurt.)
	- If you don’t have one, make one by following this (without a credit card) https://support.apple.com/en-us/HT204034 or with a credit card here https://appleid.apple.com/#!&page=signin 
* All your mental powers (we're not in 4chan here, you can unlock your brain now).

Now that you have prepared the above, we'll need to boot to windows now (we'll talk about macOS/X way later).

1. Downlaod [BootDiskUtility from cvad](http://cvad-mac.narod.ru/index/bootdiskutility_exe/0-5). (Check the InsanelyMac thread [here]( http://www.insanelymac.com/forum/topic/283190-bdutilityexe-make-clover-bootflash-with-macos-distr-under-windows/))
2. Extract it and open BootDiskUtility
3. Go to *DL Center* > hit *Update* > when it’s done, select in *HD Recovery for Mac OS X* your desired macOS/X version (goes from 10.9 up to 10.13, in the time of writing) > hit DL
	- ~~For some reason, if you do not select Update, you’ll see the 10.7 recovery if you want it for older systems~~
	- Once downloaded it will extract it as "*4.hfs*" which contains the Recovery Image of your macOS/X. 

4. Now open Options > Configuration… and make sure the "*Boot Partition Size*" is >=200MB. ***DO NOT CHOOSE*** "Enable Fixed Disks", *unless* you have an external HDD that won't show up (get you a normal USB flash drive). Select OK. 
5. Now select "*Format Disk*" and that will install CLOVER on the USB and repartition it.
6. Expand your USB after it has been formatted and partitioned, select your second partition and select "*Restore Partition*", choose your *4.hfs* and select Open.
7. Once done, you will see a CLOVER named partition on your computer, you can open it, and replace the folders **kexts**, **ACPI** (if you have your own SSDT/DSDT), **driver64UEFI** (or ***driver64*** for *legacy* users) and the **config.plist** with your own. For new fellows, replace the **config.plist**,add [HFSPlus.efi](https://github.com/JrCs/CloverGrowerPro/blob/master/Files/HFSPlus/X64/HFSPlus.efi) and [APFS.efi](https://cdn.discordapp.com/attachments/271330908328558593/388115381618999309/apfs.efi), add [VoodooPS2 kext]( https://bitbucket.org/RehabMan/os-x-voodoo-ps2-controller/downloads/) ***only for people with PS/2 devices*** (or Synaptics/ALPS/Elan… devices on laptops). Also [Lilu]( https://github.com/vit9696/Lilu/releases) in companion with [Whatevergreen]( https://github.com/vit9696/WhateverGreen/releases) for AMD/ATI GPU powered computers **OR** [NvidiaGraphicsFixup]( https://sourceforge.net/projects/nvidiagraphicsfixup/) for Nvidia **OR** [IntelGraphicsFixup](https://sourceforge.net/projects/intelgraphicsfixup/) for Intel HD4200 and higher. You will mostly **NEED** other things too, so head to the Vanilla Guide I linked above to get going. And most likely you'll need [USBInjectAll kext](https://bitbucket.org/RehabMan/os-x-usb-inject-all/downloads/) too to fix some USB booting issues (not guaranteed, but trying won't hurt).

**TiP**:
Clean up your clover folder as shown here:

        - Clover 
               > ACPI
                   > patched
    			       <files/folder>
                   > origin
    			       <files/folder>
                   > WINDOWS
    		   	       <files/folder>
               > tools
    	       	   <files/folder>
               > themes
    	           <files/folders>
               > kexts
                   > Other
                         > *insert kexts here*
               > misc
    	           <files/folders>
               > ROM
    	           <files/folders>
               > config.plist
               > CLOVERX64.EFI
               > driver64UEFI /OR/ driver64 [depends on your system, UEFI vs Legacy]
    	           <files/folders>
        - Boot
               > BOOTX64.EFI (or you can reanme CLOVERX64.EFI to BOOTX64.EFI)
    

8. Add your LAN card kext under CLOVER > EFI > CLOVER > kexts > Other >
	- Realtek https://bitbucket.org/RehabMan/os-x-realtek-network/downloads/ 
	- Intel https://bitbucket.org/RehabMan/os-x-intel-network/downloads/
	- Anything else, you look for it, sorry
	- For WiFi, you're on your own too, I do have a compatible one, but wireless is not as reliable as wired connections.

9. Plug your LAN cable, and boot up your Clover USB:
	- For UEFI people, boot it as you would
	- For Legacy people, choose your USB and hit quickly and repeatedly "6" on top of your letters to run CLOVERX64 if you kept CLOVERIA32 in the USB, if you removed it, you can boot it normally, but hitting "6" won't hurt. You will see a "6" on the top left screen where the cursor is. If by any means it shows a "UEFI Management/Setup" page, boot your usb normally without touching anything.

10. Boot to your macOS installer, prepare your install destination disk (HFS+ and whatnot, I will not show you how, as it is covered in the main vanilla guide)

11. When you hit "**Install macOS**" or "**Reinstall macOS**", you'll be asked to verify your computer, select next, then agree to terms and license (*yeah ofc, you read it, right?*) and it will ask you for an AppleID, put yours (or make one on another device) and select Sign in, once in, the download and install will start. The install will be the same as it normally goes, the first part when it downloads and prepares the files to be installed, and the second part when it will actually install macOS (with either the black Apple logo and the time remaining on the bottom or the classic window with macOS logo and the progress bar).

12. …

13. Follow now [Post-Install](https://github.com/camielverdult/Ramblings-of-a-hackintosher-High-Sierra/blob/master/Post-Install.md), and **ENJOY~**

There will be an update, hopefully, to do the same thing with macOS's recovery or recoveryhdupdate.pkg.
