## Not so Common Desktop Environment (NsCDE) Manual

### Installation Dependencies
For `NsCDE` to work, essential software is `FVWM` Window Manager. Almost all is 
based on it. Since `NsCDE` is heavy user of infostore internal variables and 
other new features of `FVWM`, initial development has been done on `FVWM` 
versions from `2.6.7` to `2.6.9`. At this time, this are recommended, versions 
of `FVWM2` for `NsCDE`, while `FVWM3` should be used from the most recent 
version possible because it is still a bit beta, and bug fixes from fvwm.org 
are introduced often. 

Other software dependencies, used by `NsCDE` are:

- `AT&T original Korn Shell 93`. All shell script routines inside configuration, 
helper scripts and `FvwmScript` helpers are written in `Korn Shell (ksh)`. Clones 
such as pdksh, mksh and some other variants found by default on some *BSD core 
systems canot be drop in replacement. Korn Shell is available and it is free. 
Use you systems' package manager to install it, or fetch it from here: 
https://github.com/att/ast

- `Xorg utils` (Fedora/CentOS RPM xorg-x11-utils) - xdpyinfo, xprop ...

- `Util xdotool` - only if `FVWM` is not patched with WindowName patch for the 
FvwmButtons

- `ImageMagick` (display, convert, import) - really needed.

- `Xscreensaver` - optional, but Screen Style Manager will not exist without it. 
Something needs to be installed for locking the screen on the real workstation. 
Freely omitted in virtual machines.

- `cpp` - `C preprocessor for xrdb functionality` - for X resources integration. 
Used by xrdb(1).

- `xorg-x11-server-utils` (CentOS, Fedora name) - xrdb, xset, xrefresh mandatory 
for startup, some style managers and menus.

- `python-yaml` - needed for python part of the color theme management and for 
Gtk+Qt integration.

- `PyQt4`, `PyQt5` or possibly `python3-qt4`, `python-qt5` or `python3-qt5` 
or ... This is unfortunate dependency which is further dependent on `Qt` 
libraries. `NsCDE` tries to have as less as possible dependencies, specially 
indirect (dependencies of dependent dependencies of dependencies ...). 
`Gtk/Qt` integration is borrowed from CDEtheme Motif/CDE theme project and 
adapted for use with `FVWM` (instead of heavy Xfce dependency) or standalone 
engine. In part of the Theme.py code, some png pixmaps are cut and colored with 
functions from this API. With present job and lack of time, there was no time to 
do this without `PyQt5` or `PyQt4` for the first public release.

- `Gtk2`, `Gtk3`, `Qt4`, `Qt5`, `qtconfig-qt4`, `qt5ct`, 
`qt5-qtstyleplugins (optional)` There is a great chance this libraries and some 
usefull programs using them are already installed on user's system. If `Gtk` and 
`Qt` integration is activated in [70]Color Style Manager, there is no point not 
to have it installed. Notice about `Qt4` and `Qt5`: `qt4-config` (or `qt-config`) 
and `qt5ct`: Although colors will be applied, for font setting to take effect, 
`qtconfig-qt4` (or `qtconfig`) must be run, something changed back and forth, 
and then `applied/saved` - no matter that you will see fonts of your choice 
already selected. This can be considered a bug. Same goes for `Qt5`. 
Notice about `Qt5`: `QT_QPA_PLATFORMTHEME` environment variable must be set, 
and be set to `qt5ct` value in order to run `qt5ct` configurator.

- Recommended fonts for as close as possible `CDE look` are *DejaVu Serif* for 
variable, and *DejaVu Sans Mono* for monospaced fonts. Check should be made if 
this fonts are installed on the system. For `Solaris CDE look`, *Lucida Sans* 
and *monospaced Lucida Sans* Typewriter should be installed, selected and used 
instead. (optional)

- `xterm` (initial user setup is done with `xterm`)

- `gettext`

- `Stalonetray` for *tray* facility (optional, highly recommended)

- `Dunst` notification daemon (optional, highly recommended)

- `XSETTINGS` - xsettingsd daemon for theme and X settings dynamic management 
(optional, highly recommended)

- `gkrellm` - recommended optional addon

- `rofi` - recommended optional addon

- `xclip` - recommended optional addon

- `python3`

- `python34-pyxdg` or `python3-pyxdg` or `python36-pyxdg` or ... (`FVWM`)

--------------------------------------------------------------------------

### Known system specific package dependencies

- All systems

Installing `NsCDE` with autoconf/automake `make install` requires some
development packages:

- `autoconf` and `automake`
- X11 development headers (`libx11-dev` on Debian and friends)
- Xext development headers (`libxext-dev` on Debian and friends)
- XPM development headers (`libxpm-dev` on Debian and friends)
- ... and of course, C compiler (gcc, clang ...)
- `make` tool

On RPM based Linux distributions, this packages are often called
`libX11-devel`, `libXext-devel` and `libXpm-devel`.


- Arch / Artix / Manjaro
``` sh
# Use your AUR helper of choice (e. g. trizen) to install the package
trizen -S nscde
# Alternatively install the -git package to get the latest sources
trizen -S nscde-git
```

- Debian / Devuan / Ubuntu / Mint / MX Linux
``` sh
sudo apt update
sudo apt dist-upgrade
sudo apt install -y ksh xutils/x11-utils xdotool imagemagick \
    xscreensaver x11-xserver-utils python3-yaml python3-pyqt5 \
    qt5ct qt5-style-plugins stalonetray xterm python3 \
    python3-xdg libstroke0 xsettingsd fvwm fvwm-icons \
    libfile-mimeinfo-perl gkrellm rofi xclip
```

- Fedora / RHEL / CentOS / RockyLinux / openEuler
``` sh
sudo dnf update
sudo dnf install -y ksh xorg-x11-utils xdotool ImageMagick xscreensaver \
    python3-pyyaml python3-qt5 qt5ct qt5-styleplugins \
    stalonetray xterm pyhon3 pyhon3-pyxdg libstroke xsettingsd \
    fvwm perl-File-MimeInfo gkrellm rofi xclip
```

- FreeBSD/ DragonflyBSD/ GhostBSD/ MidnightBSD
``` sh
sudo pkg install ksh2020 xorg ImageMagic6/7 xscreensaver \ 
    py37-yaml py37-qt5 qt5ct qt5-style-plugins 
    stalonetray xterm pyhon3 py37-xdg libstroke xsettingsd \ 
    fvwm3 p5-File-MimeInfo gkrellm2 rofi
```

- Gentoo/ Funtoo / Calculate/ Sabayon/ Redcore
``` sh
echo "app-shells/ksh \n
    x11-base/xorg-x11 \n
    x11-misc/dunst \n
    x11-apps/xdpyinfo \n
    x11-apps/xprop \n
    x11-misc/xdotool \n
    media-gfx/imagemagick \n
    x11-misc/xscreensaver \n
    dev-python/pyyaml \n
    dev-python/PyQt5 \n
    x11-misc/qt5ct \n
    dev-qt/qtstyleplugins \n
    x11-misc/stalonetray \n
    x11-terms/xterm \n
    dev-lang/python \n
    dev-python/pyxdg \n
    dev-libs/libstroke \n
    x11-misc/xsettingsd \n
    x11-wm/fvwm \n
    dev-perl/File-MimeInfo \n
    app-admin/gkrellm \n
    x11-misc/xclip \n
    x11-misc/rofi" > /etc/portage/sets/nscde-desktop
emerge --sync
emerge -auvDN @world
emerge @nscde-desktop --autounmask-write
etc-update --automode -3
emerge @nscde-desktop

```

- OpenMandriva
``` sh
sudo dnf update
sudo dnf install -y xorg xdotool imagemagick xscreensaver \
    python-pyyaml python-qt5 qt5ct qt5-style-plugins \
    stalonetray xterm pyhon3 pyhon-xdg llib64stroke0 xsettingsd \
    fvwm2 perl-File-MimeInfo gkrellm rofi xclip
cd ~
git clone --depth 1 https://github.com/att/ast.git
./bin/package make
sudo ./bin/package install
```

- OpenSUSE Leaf /Tumbleweed / GeckoLinux
``` sh
sudo zypper ref
sudo zypper up
sudo zypper in ksh-93uv xorg xdotool ImageMagick xscreensaver \
    python3-pyyaml python3-PyQt5 qt5ct libqt5-styleplugins \ 
    stalonetray xterm pyhon3 libstroke xsettingsd fvwm2 \
    perl-File-MimeInfo gkrellm rofi xclip
```

- Void Linux
``` sh
xbps-install -Su
xbps-install -Sy xorg xdotool ImageMagick xscreensaver \
    python3-yaml python3-PyQt5 qt5ct qt5-styleplugins \ 
    stalonetray xterm pyhon3 pyhon3-xdg xsettingsd \
    fvwm3 perl-File-MimeInfo gkrellm rofi xclip
cd ~
git clone --depth 1 https://github.com/att/ast.git
./bin/package make
sudo ./bin/package install

cd ~
wget http://ftp.udc.es/debian/pool/main/libs/libstroke/libstroke_0.5.1.orig.tar.gz
tar -zxvf libstroke_0.5.1.orig.tar.gz
cd libstroke-0.5.1
./configure
make
sudo make install
```

- SparkyLinux
``` sh
sudo apt update && sudo apt dist-upgrade && sudo apt install nscde-desktop
```

--------------------------------------------------------------------------

### Installation

When `FVWM` and above mentioned dependencies are met, `NsCDE` can be installed and 
used. Present installation is very simple:

``` sh
# su - (or sudo -i)
umask 0022
cd /tmp

# Thein either:
wget https://github.com/NsCDE/NsCDE/archive/<version>.tar.gz
tar xpzf <version>.tar.gz
cd NsCDE-<version>

# or:
git clone --depth 1 https://github.com/NsCDE/NsCDE.git
cd NsCDE

# ... and then:
./configure
make
make install
```

That's it. `NsCDE` is installed. You may need to restart your X Display Manager 
(such as `lightdm`, `gdm`, `sddm` ...) for `NsCDE` entry to appear as an login 
option.
--------------------------------------------------------------------------

### NsCDE Startup

If not invoked from X Display Manager, `NsCDE` X session can be started from the 
`$HOME/.xsession` in last command line as `exec /opt/NsCDE/bin/nscde`, or 
`ssh-agent /opt/NsCDE/bin/nscde` or with `gpg-agent`, `lxsession` or `whatever`).

If supported by the X Display Manager which is in use, an xsession file 
`/opt/NsCDE/share/examples/xsession-integration/nscde.desktop` when put in 
`/usr/share/xsessions` by the installer or manually (or in whatever place your 
system and your X Display Manager reads this files) and then selected from the 
manager's menu or similar selector. See the rest of the X Session Manager 
integration examples are in directory `/opt/NsCDE/share/examples/` for 
`Cinnamon`, `MATE`, `KDE`, `LXDE` and similar DE integrations and play with this 
if you like.

--------------------------------------------------------------------------

### Initial Configuration

Upon the first (successful) start, `~/.NsCDE`, that is `$FVWM_USERDIR` is 
created, and only icons subdirectory is created as nscde-fvwm-menu-desktop is 
run. User will be presented with a default system setup and with default color 
theme Broica in 8 colors, and `f_FindTerm` function will try hard to find some 
usable terminal application and run it with setup. If Gkrellm, pnmixer and/or 
stalonetray programs are installed, on the system and found, they will be run 
too.

Initial setup is a simple script (`$NSCDE_TOOLSDIR/bootstrap`) from the 
terminal which will run automatically and will set up the following:

- X resources in ~/.NsCDE
- Default background color (pre-FvwmBacker) from default theme
- Default ~/.NsCDE/NsCDE.conf
- New ~/.NsCDE/GeoDB.ini with some sane defaults
- ~/.icons/default/index.theme (default X cursor scheme)
- ~/.gtkrc-2.0
- ~/.config/gtk-3.0/settings.ini
- ~/.themes/NsCDE
- ~/.config/Trolltech.conf
- ~/.config/qt5ct/qt5ct.conf

Note that no file from the above list will be overwritten if it already exists 
in it's place. It will be skipped, but `GTK` and `Qt` theme integration files 
can be still written with Color Style Manager. After `bootstrap` script 
finishes setup, Color Style Manager will be run and user asked to confirm 
default theme or change it. Do not avoid this step, since some program bits are 
not fully setup on bare defaults, (like a clock background) and must be 
generated in the `~/.NsCDE/icons/NsCDE directory`.

After Color Style Manager's OK button is pressed, theme will be regenerated. 
`Gtk` and `Qt` themes will be regenerated only if their checkboxes in Color 
Style Manager are checked in. Setup script after the finish will ask user to 
press `RETURN` to exit. This is for user's convenience to read output of the 
setup for informative and/or diagnostic reasons. It is advised after this setup 
to open `$FVWM_USERDIR/NsCDE.conf` and set up InfoStoreAdd internal `FVWM` 
variables for `terminal`, `filemgr` and `xeditor` to user's favorite programs for 
functions.

Layout of the `$FVWM_USERDIR` after the initial setup should look like this:

- app-defaults/
- backdrops/
- palettes/
- fontsets/
- config_templates/
- photos/
- backer/
- GeoDB.ini
- icons/
- icons/NsCDE/
- Backdrops.fvwmgen
- Colorset.fvwmgen
- NsCDE.conf
- tmp/
- Xdefaults
- Xdefaults.fontdefs
- Xdefaults.local
- Xdefaults.mouse
- Dunst.conf
- Stalonetray.conf
- NsCDE.rasi (`NsCDE` Rofi theme)
- Xsettingsd.conf

It is advised to logout and login from the X session after this, and check if 
everything looks ok. Also, it is a good idea to start using programs from the 
menu and examine environment around for a half an hour or so, before running 
Style Manager (2nd button right of the Workspace Manager on the Front Panel) 
to customize other aspects of the interface. `NsCDE` is now ready for usage.

