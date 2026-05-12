# Repository Guidelines

## Project Structure & Module Organization
NsCDE-zh is an Autotools-based desktop environment project. Top-level
configuration lives in `configure.ac`, `Makefile.am`, and generated
`configure` / `Makefile.in` files. C helper programs are under `src/`
(`colorpicker`, `pclock`, `XOverrideFontCursor`). Runtime scripts and tools are
split between `nscde_tools/` and `lib/scripts/`, with Python helpers in
`lib/python/`. Theme, FVWM, palette, backdrop, and photo assets live in `data/`.
Desktop integration files are in `xdg/`, translations in `po/`, package recipes
in `pkg/`, and user documentation in `doc/`, `README*.md`, and `NsCDE.wiki/`.

## Build, Test, and Development Commands
- `./autogen.sh`: regenerate Autotools files after changing `configure.ac` or
  `Makefile.am`.
- `./configure --prefix=/usr`: configure paths and check required tools such as
  `ksh`, `msgfmt`, `sed`, X11 utilities, FVWM, and Python modules.
- `make`: build C helpers, generated scripts, localization files, and installable
  assets.
- `sudo make install`: install the configured build; use only on a disposable VM
  or test system when validating install behavior.
- `make clean`: remove generated build outputs, including compiled `.mo` files.
- `msgfmt -o po/NsCDE.zh.mo po/NsCDE.zh.po`: validate a changed translation file.

## Coding Style & Naming Conventions
Match the surrounding file style. Shell templates use `ksh` syntax, uppercase
environment variables such as `NSCDE_TOOLSDIR`, and PascalCase function names in
manager scripts. C files use tabs for block indentation and plain `snake_case`
locals. Python code currently follows compact legacy spacing; keep changes
minimal and avoid broad formatting-only edits. Preserve `.in` templates when
values are substituted by `configure`.

## Testing Guidelines
There is no standalone automated test suite in this repository. Treat
`./configure && make` as the baseline validation. For translations, run `msgfmt`
on touched `.po` files. For scripts, prefer targeted runtime checks in an X11/FVWM
session or VM, especially when changing files under `nscde_tools/`, `lib/scripts/`,
or `data/fvwm/`.

## Commit & Pull Request Guidelines
Recent history uses concise Conventional Commit prefixes such as `fix:` and
`chore:`, alongside short Chinese maintenance messages. Prefer
`type: imperative summary`, for example `fix: handle DefaultAppsMgr output`.
Keep commits focused on one concern. PRs should describe the changed component,
list validation commands, mention affected distributions or desktop sessions,
and include screenshots for visible UI/theme changes.

## Security & Configuration Tips
Do not commit generated local configuration, secrets, or machine-specific paths.
Be careful with install-related changes because the project writes into system
prefixes, XDG directories, and session files. Keep package metadata in `pkg/`
aligned with any dependency changes in `configure.ac` and `README*.md`.

## NsCDE Runtime Isolation
Do not write GTK, Qt, icon, MIME/default-application, or XDG search-path changes
to the user's shared desktop configuration by default. The X11/FVWM session
should route launched desktop applications through `nscde_xdg_run`, which scopes
NsCDE-specific settings under `$FVWM_USERDIR/xdg/`. Legacy writes to
`~/.config`, `~/.gtkrc-2.0`, `~/.local/share`, or global `XDG_*` variables are
allowed only when `NSCDE_ALLOW_SHARED_DESKTOP_CONFIG=1` is explicitly set.

## Wayland Runtime Isolation
Wayland theme and desktop scripts must not globally override `XDG_CONFIG_DIRS`
or `XDG_DATA_DIRS` from the session launcher. Keep other desktop environments,
especially Plasma, unaffected. If a Wayland component needs NsCDE-specific
config or icon paths, pass explicit config files or use `nscde-wayland-run` to
scope temporary XDG values to that component only. Ordinary applications launched
from the panel or launcher should run with the original XDG environment.
Theme, icon, MIME/default-application, Qt, GTK, KDE, and portal settings for
the Wayland edition must be written to NsCDE-specific extra config files, not to
the user's shared desktop files. Do not edit `~/.config/gtk-3.0/settings.ini`,
`~/.config/gtk-4.0/settings.ini`, `~/.gtkrc-2.0`, `~/.config/kdeglobals`,
`~/.config/mimeapps.list`, `~/.local/share/applications/mimeapps.list`,
`qt5ct.conf`, `qt6ct.conf`, or Kvantum globals unless the user explicitly asks.
Prefer paths under `~/.config/nscde-wayland/` and explicit component config
arguments.
