# NsCDE-zh Agent Guide

## Project Overview

NsCDE-zh is a Chinese (Simplified) localization fork of [NsCDE](https://github.com/NsCDE/NsCDE) — a retro CDE-style desktop environment built on FVWM. The codebase is primarily Korn Shell scripts, Python 3, FvwmScript GUI programs, and C utilities.

## Build System

Autoconf/Automake. **Required order:**

```bash
./autogen.sh          # runs autoreconf -f -i -v
./configure --prefix=/usr
make
sudo make install
```

Build dependencies (Debian/Ubuntu):
```
autoconf automake gcc make libx11-dev libxext-dev libxpm-dev ksh gettext
```

Runtime dependencies: `ksh fvwm python3 python3-yaml python3-pyxdg python3-psutil PyQt5 qt5ct xsettingsd stalonetray dunst xclip xdotool imagemagick xterm`

## Version

Single source of truth: `configure.ac` line `AC_INIT([NsCDE], 2.3.4, ...)`. CI extracts version from this line.

## Directory Structure

- `src/` — C utilities (colorpicker, pclock, XOverrideFontCursor)
- `lib/python/` — Python theme engines (`.py.in` templates, processed by configure)
- `lib/scripts/` — FvwmScript GUI dialogs (ColorMgr, FontMgr, WindowMgr, etc.)
- `lib/fvwm-modules/` — FVWM module configs
- `data/fvwm/` — FVWM configuration files (`.fvwmconf`, `.fvwmconf.in`)
- `data/backdrops/`, `data/palettes/` — CDE-style visual assets
- `nscde_tools/` — Shell script utilities (`.in` templates). These are the main runtime tools.
- `po/` — gettext `.po` translation files (Croatian `hr` and Chinese `zh`)
- `pkg/` — Packaging for Debian, RPM, Arch (pacman), FreeBSD
- `xdg/` — XDG desktop entries and menus
- `bin/` — Main entry points (`nscde`, `nscde_fvwmclnt`)
- `doc/` — Documentation (docbook format)

## Key Technical Facts

- **Shell**: All shell scripts use AT&T Korn Shell 93 (`ksh`). Not bash, not mksh.
- **Templates**: Files ending in `.in` are processed by `configure` to substitute paths (e.g., `@NSCDE_DATADIR@`, `@KSH@`, `@PYTHON@`). Never edit generated output files directly.
- **FVWM version**: Supports both FVWM2 and FVWM3. FrontPanel config differs between them (`FrontPanel.fvwm2.fvwmconf` vs `FrontPanel.fvwm3.fvwmconf`).
- **Localization**: Uses gettext. `.po` files in `po/` compile to `.mo` files. The main `NsCDE.po`/`NsCDE.zh.po` contains Notifier/FVWM menu translations. **Warning**: recompiling `NsCDE.mo` requires immediate NsCDE restart or FVWM will segfault.
- **Install paths**: Defaults to `/usr/local` (`$NSCDE_ROOT`). User config goes to `~/.NsCDE` (`$FVWM_USERDIR`), not `~/.fvwm`.

## Packaging

CI (`.github/workflows/build-packages.yml`) builds for Debian, Ubuntu, Fedora RPM, Arch, and FreeBSD. Version tags follow pattern `v2.3.4_zh`.

```bash
# Debian
dpkg-buildpackage -rfakeroot -b

# Arch
makepkg -si

# RPM: uses pkg/rpm/NsCDE.spec with rpmbuild
```

## Locale Configuration

Supported locales defined in `configure.ac`: `LOCALES="hr zh"`. To add a new locale, update this line and create corresponding `.po` files following existing patterns.

## Common Pitfalls

- Don't confuse ksh syntax with bash (e.g., `[[ ]]` behavior, `echo -ne` usage)
- `.in` files contain `@VARIABLE@` placeholders — these are substituted at build time
- FvwmScript dialogs have fixed widget sizes; translations must fit within them
- Some child dialogs share parent `.po` files (e.g., NColorsDialog uses NsCDE-ColorMgr.po)
- The `bootstrap` script (`nscde_tools/bootstrap.in`) runs on first login and sets up `~/.NsCDE`
