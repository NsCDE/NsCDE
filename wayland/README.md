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

To inspect the current test session:

```sh
nscde-wayland-doctor
```

To capture a Wayland screenshot:

```sh
nscde-wayland-screenshot area
nscde-wayland-screenshot copy-area
```

Static assets stay in the source or installation directory:

```text
wayland/assets/
/usr/share/nscde-wayland/assets/
```

Component configuration for `fuzzel`, `foot`, `fnott`, and `sfwbar` also stays
under the same Wayland project directory. `nscde-wayland-run` passes those paths
to individual NsCDE components without changing global XDG search paths for the
whole session.

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

## Runtime Isolation

`nscde-labwc` does not globally override `XDG_CONFIG_DIRS` or `XDG_DATA_DIRS`.
NsCDE-specific component paths are applied by `nscde-wayland-run` only for the
component being launched. Use `nscde-wayland-run app COMMAND` when panel actions
start normal desktop applications so they keep the original XDG environment.

Theme, icon, MIME/default-application, GTK, Qt, KDE, and portal preferences must
use NsCDE-specific extra config files. Do not write directly to shared desktop
files such as `~/.config/gtk-3.0/settings.ini`, `~/.config/kdeglobals`,
`~/.config/mimeapps.list`, `qt5ct.conf`, or `qt6ct.conf`. Keep generated
runtime preferences under `~/.config/nscde-wayland/` or pass explicit config
paths to the component that needs them.
