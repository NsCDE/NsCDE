# NsCDE Wayland Labwc Prototype

This directory is a standalone Wayland session project for an NsCDE-like
desktop based on labwc.

The prototype keeps two rules:

- NsCDE-provided session components run as native Wayland clients.
- Runtime configuration uses copied assets from this project, not direct
  references to the parent NsCDE tree.

## Initial Components

- `labwc` for the Wayland compositor.
- `sfwbar` and `lavalauncher` for the temporary CDE-like front panel.
- `fuzzel` for launching applications.
- `foot` for the default terminal.
- `fnott` for notifications.
- `swaybg` or `wbg` for wallpaper.
- `wl-clipboard`, `grim`, `slurp`, `wlr-randr`, and `kanshi` for Wayland tools.

## Build And Install

This subproject is intentionally independent from the parent Autotools build.

```sh
cd wayland
make check
sudo make install PREFIX=/usr
```

For packaging, use `DESTDIR`:

```sh
make install PREFIX=/usr DESTDIR="$pkgdir"
```

Installed files are placed under:

```text
/usr/bin/nscde-labwc
/usr/share/wayland-sessions/nscde-labwc.desktop
/usr/share/nscde-wayland/
```

## Running From The Source Tree

```sh
wayland/bin/nscde-labwc
```

To apply one compositor-wide output scale during startup:

```sh
NSCDE_WAYLAND_SCALE=1.5 wayland/bin/nscde-labwc
```

For display-manager sessions, write the scale factor to:

```text
~/.config/nscde-wayland/scale
```

Static assets stay in the source or installation directory:

```text
wayland/assets/
/usr/share/nscde-wayland/assets/
```

The bundled assets are copied into this subproject from the parent tree so the
Wayland session can be built and packaged on its own. They include CDE
backdrops, palettes, photos, fontsets, icon sets, XDG menu metadata, integration
templates, and translation sources.

On first run, only editable labwc configuration is copied into:

```text
~/.config/nscde-wayland/labwc/
```

The labwc session then reads configuration from:

```text
~/.config/nscde-wayland/labwc/
```

Systemd is supported through the host distribution, but this session does not
require `systemctl --user`; labwc `autostart` is the default startup path.
