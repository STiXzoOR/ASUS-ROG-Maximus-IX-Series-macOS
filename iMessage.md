# How to setup iMessage & FaceTime

## Requirements:

- Clover
- Clover Configurator: <http://mackie100projects.altervista.org>

## Step 1: Seting the correct BSD name

Open Terminal and run the following commands: (Warning: This will delete most of your preferences.)

- sudo rm -rf /Library/Preferences/SystemConfiguration/NetworkInterfaces.plist
- sudo rm -rf /Library/Preferences/SystemConfiguration/preferences.plist

By now, OS X (macOS) should re-discover all your Network Interfaces and rebuild the network configuration files, hopefully now with the correct BSD names. If the BSD names are still not correct and you have additional add-on PCI or USB NIC's then try removing them and delete the two files again, reboot and let OS X assign the 'built-in' NIC's first, then re-install your add-on NIC's one by one.

You can check your BSD name by System Profiler > Network.

## Step 2: Reset iMessage Configuration files

If you are starting with a clean OS X install then there is no need for you to perform any of the procedures in this chapter. You can skip this step if this is your case.

However if you have been trying to get iMessage to work for sometime and have been using different System ID's and/or Apple_ID's then the chances are that the iMessage configuration and cache files could contain invalid or non-useful data.

By deleting these files we can force iMessage to reset-itself and re-build the configuration files which will force iMessage to re-authenticate it-self with Apples iMessage servers. I always recommend performing this procedure after making any significant changes to OS X's System ID's such as the S/N, SmUUD (System_Id), System Type, MLB & ROM.

Before commencing you should logout of **all** Apple iCloud services and disconnect from your network, then reboot this way OS X will not start the iCloud services and allow us to remove the config files.

Open Terminal, run these commands:

* `sudo rm -rf /StartupDrive/Users/Username/Library/Caches/com.apple.iCloudHelper*`
* `sudo rm -rf /StartupDrive/Users/Username/Library/Caches/com.apple.Messages*`
* `sudo rm -rf /StartupDrive/Users/Username/Library/Caches/com.apple.imfoundation.IMRemoteURLConnectionAgent*`
* `sudo rm -rf /StartupDrive/Users/Username/Library/Preferences/com.apple.iChat*`
* `sudo rm -rf /StartupDrive/Users/Username/Library/Preferences/com.apple.icloud*`
* `sudo rm -rf /StartupDrive/Users/Username/Library/Preferences/com.apple.imagent*`
* `sudo rm -rf /StartupDrive/Users/Username/Library/Preferences/com.apple.imessage*`
* `sudo rm -rf /StartupDrive/Users/Username/Library/Preferences/com.apple.imservice*`
* `sudo rm -rf /StartupDrive/Users/Username/Library/Preferences/com.apple.ids.service*`
* `sudo rm -rf /StartupDrive/Users/Username/Library/Preferences/com.apple.madrid.plist*`
* `sudo rm -rf /StartupDrive/Users/Username/Library/Preferences/com.apple.imessage.bag.plist*`
* `sudo rm -rf /StartupDrive/Users/Username/Library/Preferences/com.apple.identityserviced*`
* `sudo rm -rf /StartupDrive/Users/Username/Library/Preferences/com.apple.ids.service*`
* `sudo rm -rf /StartupDrive/Users/Username/Library/Preferences/com.apple.security*`
* `sudo rm -rf /StartupDrive/Users/Username/Library/Messages`

StartupDrive being the name of the macOS partition and Username being your User name.

## Step 3: Generate SMBIOS value

Open your config.plist in Clover Configurator and go to SMBIOS. Click the arrow up and arrow down button, you should now see a menu with different SMBIOSes. Click [here](Tips.md#choosing-a-smbios) for more info on how to choose an SMBIOS.

Once you've selected an SMBIOS that corresponds with your hardware, we are going to generate a UUID. Go to `System Parameters > Custom UUID` and click `Generate New`. Copy the UUID you just generated and paste it into `SMBIOS > smUUID`. Now go to the Rt Variables section and click Generate. In the Info tab below ROM and MLB, copy ROM from info to ROM and copy MLB from info to MLB.

It should look like something like this: (The values are **not** supposed to be the same, do not copy these.)

![alt text](Pictures/ROM&MLB.png)

Reboot

Credit: This guide is based from [jaymonkey guide](https://www.tonymacx86.com/threads/how-to-fix-imessage.110471/)
