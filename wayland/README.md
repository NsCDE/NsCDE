# NsCDE Wayland Labwc Prototype

This directory contains the first Wayland session scaffold for an
NsCDE-like desktop based on labwc.

The prototype keeps two rules:

- NsCDE-provided session components run as native Wayland clients.
- Runtime configuration uses copied assets, not direct references to the
  existing NsCDE data or icon directories.

## Initial Components

- `labwc` for the Wayland compositor.
- `sfwbar` and `lavalauncher` for the temporary CDE-like front panel.
- `fuzzel` for launching applications.
- `foot` for the default terminal.
- `fnott` for notifications.
- `swaybg` or `wbg` for wallpaper.
- `wl-clipboard`, `grim`, `slurp`, `wlr-randr`, and `kanshi` for Wayland tools.

## Running From the Source Tree

```sh
NSCDE_SOURCE_ROOT=/path/to/NsCDE-zh wayland/bin/nscde-labwc
```

On first run, the launcher copies selected assets into:

```text
~/.local/share/nscde-wayland/
~/.local/share/themes/NsCDE-Wayland/
```

The labwc session then reads configuration from:

```text
~/.config/nscde-wayland/labwc/
```

Systemd is supported through the host distribution, but this session does not
require `systemctl --user`; labwc `autostart` is the default startup path.
