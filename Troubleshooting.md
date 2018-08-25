# Common problems when installing Web Drivers

## Black screen
Check out [this](Tips.md#nvidiagraphicsfixup-and-some-smbioses-explained).

## Nvidia Web drivers not working
Check if you have NvidiaWeb check in System Parameters. If you do, check out [here](Tips.md#nvidia-web-drivers-not-kicking-in).

## No native NVRAM support
Check out [this](Tips.md#nvidia-web-drivers-not-kicking-in).

## Massive ACPI kernel panic on Gigabyte boards
You can fix this by dropping the MATS table in your config.plist. Open your config.plist with Clover Configurator and Go to ACPI > Drop Tables (bottom left). Click the + button and set Signature to `MATS`.