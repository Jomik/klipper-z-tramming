# Z Tramming for Klipper

Z Tramming for 3d printers running Klipper,
that do not have separate drivers for the z axis.

<!--prettier-ignore-->
<!--toc:start-->

- [Z Tramming for Klipper](#z-tramming-for-klipper)
  - [Why should you use this?](#why-should-you-use-this)
  - [How does it work?](#how-does-it-work)
  - [How to use it?](#how-to-use-it)
  - [How to install it?](#how-to-install-it)
    - [Manual installation](#manual-installation)
  - [How to configure it?](#how-to-configure-it)
  - [Alternatives](#alternatives)
  <!--toc:end-->

## Why should you use this?

If the printer is not perfectly square, the z axis will not move in level.
This means your nozzle could be at different heights at different sides of the bed.

Some 3d printers, like the Sovol SV06, do not have separate drivers for the z axis.
Thus automatic calibration of the axis is not possible, as the motors are not independent.

This is a solution to this problem.
But it requires some manual adjustments of the z axis motors.

## How does it work?

The macro probes each side of the bed,
then calculates the amount you need to rotate one of the motor screws.
If we have to rotate clockwise by 1 hour and 20 minutes,
it means that we need to rotate the motor 1 full rotation for the hour,
then another third of a rotation for the 20 minutes.
Calculation is done using the pitch of your lead screw.
This is the only input you need to provide.

As more people use this and contribute,
I will strive to keep a list so that it becomes easy.

## How to use it?

Simply run the `Z_TRAMMING` in your console.
Your printer will probe and then use Mainsail's prompt to inform you what to do next.
Continue till you are happy.

:warning: **WARNING**:
This macro will disable your z stepper _without_ informing Klipper.
Ensure you run `G28 Z` if you abort without using the prompt.
See [this](https://github.com/Klipper3d/klipper/issues/906) for the reason.

## How to install it?

To ease installation, there is a script you can simply curl and execute.

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Jomik/klipper-z-tramming/main/install.sh)"
```

Then you only need to configure your lead screw pitch. See [How to configure it?](#how-to-configure-it).

### Manual installation

- Clone this repository to your printer's Klipper host.

```sh
git clone https://github.com/Jomik/klipper-z-tramming.git ~/z_tramming
```

- Symlink it to your config folder.

```sh
ln -s ~/klipper-z-tramming/z_tramming.cfg ~/printer_data/config/z_tramming
```

- Copy the `z_tramming_settings.cfg` to your config folder.

```sh
cp ~/klipper-z-tramming/z_tramming_settings.cfg ~/printer_data/config/z_tramming_settings.cfg
```

- Include the macros in your `printer.cfg` by adding these lines:

```cfg
[include z_tramming_settings.cfg]
[include ./z_tramming/z_tramming.cfg]
```

- Add the repo to moonraker

```sh
cat >>$HOME/printer_data/config/moonraker.conf <<EOF
[update_manager Z_Tramming]
type: git_repo
channel: dev
path: ~/z_tramming
origin: $origin
managed_services: klipper
primary_branch: main
EOF
```

- Update the settings to your liking, see [How to configure it?](#how-to-configure-it).

## How to configure it?

Open `z_tramming_settings.cfg` and uncomment the line with `variable_screw_pitch`,
set the number to your pitch.
You can look at the examples in the file for some known values.

## Alternatives

- [Z-tilt via Probe Klipper Macro by gerGO PRINT 3D](https://cults3d.com/en/3d-model/tool/z-markers-for-sovol-sv06-plus)
- [Klipper_Z_Tramming by GatoMiopia](https://github.com/GatoMiopia/Klipper_Z_Tramming).
