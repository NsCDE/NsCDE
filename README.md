# **Not so Common Desktop Environment (NsCDE) - Chinese Localization**

[![Github commits](https://img.shields.io/github/last-commit/wenyinos/NsCDE-zh)](https://github.com/wenyinos/NsCDE-zh)
[![GitHub release](https://img.shields.io/github/v/release/wenyinos/NsCDE-zh)](https://github.com/wenyinos/NsCDE-zh/releases)
[![PR's Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/wenyinos/NsCDE-zh/pull/new)

**Languages: [English](README.md) | [中文](README.zh.md)**

![ScreenShot](NsCDE.png)

**NsCDE-zh** is a Chinese localization of NsCDE, providing full Simplified Chinese support for the NsCDE desktop environment.

## Features

- 🌏 Full Chinese (Simplified) translation with 25+ language files
- 🎨 Default Noto Sans CJK SC font for proper Chinese character display
- 🎯 Retro CDE look and feel with modern functionality
- 💻 FVWM-based lightweight desktop environment
- ⚙️ GTK2/GTK3/Qt4/Qt5 theme integration
- 🎭 Color and Font Style Managers with GUI configuration
- 📱 **Default Applications Manager** - GUI dialog for setting default terminal, editor, file manager, browser, etc.
- 🗂️ **pcmanfm-qt Integration** - Application Manager mode accessible from NsCDE menu, root menu, and subpanels
- 🌐 **System Info Enhancement** - Last boot time display in Workstation Info dialog

## Installation

### From DEB Package

#### Debian
[![Debian](https://img.shields.io/badge/Debian-Package-blue?logo=debian)](https://github.com/wenyinos/NsCDE-zh/releases)

```bash
# Download and install Debian package (replace VERSION with actual version, e.g. 2.3.5)
wget https://github.com/wenyinos/NsCDE-zh/releases/download/vVERSION+zh/nscde-zh_VERSION+zh-1_amd64.deb
sudo apt install ./nscde-zh_VERSION+zh-1_amd64.deb
```

#### Ubuntu
[![Ubuntu](https://img.shields.io/badge/Ubuntu-Package-orange?logo=ubuntu)](https://github.com/wenyinos/NsCDE-zh/releases)

```bash
# Download and install Ubuntu package (replace VERSION with actual version, e.g. 2.3.5)
wget https://github.com/wenyinos/NsCDE-zh/releases/download/vVERSION+zh/nscde-zh_VERSION+zh-1ubuntu1_amd64.deb
sudo apt install ./nscde-zh_VERSION+zh-1ubuntu1_amd64.deb
```

### From RPM Package

[![RPM](https://img.shields.io/github/v/release/wenyinos/NsCDE-zh?label=RPM)](https://github.com/wenyinos/NsCDE-zh/releases)

```bash
# Download latest RPM from releases page
# https://github.com/wenyinos/NsCDE-zh/releases

# Or install directly (replace VERSION with actual version)
sudo dnf install https://github.com/wenyinos/NsCDE-zh/releases/download/vVERSION/NsCDE-VERSION-1.zh.fc43.x86_64.rpm
```

### From Arch Linux (AUR)

```bash
# Using AUR helper
paru -S nscde-zh

# Or build from source (pkg/pacman/PKGBUILD)
makepkg -si
```

### From Source

```bash
./autogen.sh
./configure --prefix=/usr
make
sudo make install
```

## Dependencies

```
ksh xterm sed fvwm cpp xsettingsd stalonetray dunst xclip xdotool
python3-pyxdg python3-psutil qt5ct
python3-yaml PyQt5 qt5-qtstyleplugins dex-autostart groff-base
dejavu-serif-fonts google-noto-sans-cjk-fonts google-noto-sans-mono-cjk-vf-fonts
google-noto-sans-mono-fonts convert import xrdb xset xprop xdpyinfo xrandr
xdg-utils gettext
```

## Usage

1. Start NsCDE session from your display manager
2. Use **Font Style Manager** to configure fonts
3. Use **Color Style Manager** to configure colors and themes

## Font Configuration

Default fonts are **Noto Sans CJK SC** and **Noto Sans Mono CJK SC** for Chinese display.

### Installing Fonts

```bash
# Debian/Ubuntu
sudo apt install fonts-noto-cjk fonts-noto-cjk-extra

# Fedora/RHEL
sudo dnf install google-noto-sans-cjk-fonts google-noto-sans-mono-cjk-vf-fonts
```

### Manual DPI Configuration

If Chinese characters display as boxes, the DPI may not match:

```bash
# Check current DPI
xrdb -query | grep Xft.dpi

# Edit configuration file (adjust DPI value as needed)
sed -i 's/Xft.dpi: 96/Xft.dpi: 120/' ~/.NsCDE/Xdefaults.fontdefs
xrdb -merge ~/.NsCDE/Xdefaults.fontdefs
```

### Configuration File Locations

| File | Description |
|------|-------------|
| `~/.NsCDE/Xdefaults.fontdefs` | Xft font definitions |
| `~/.NsCDE/Font-*.fvwmconf` | FVWM window manager fonts |
| `~/.NsCDE/Xsettingsd.conf` | GTK/Qt application fonts |

## Screenshots

See the [NsCDE Gallery](https://imgur.com/gallery/nHkw35X)

## Documentation

- Wiki: https://github.com/wenyinos/NsCDE-zh/wiki
- FAQ: https://github.com/wenyinos/NsCDE-zh/wiki/NsCDE---Frequently-Asked-Questions-(FAQ)
- Videos: https://github.com/wenyinos/NsCDE-zh/wiki/NsCDE---Video-presentations-and-tutorials
- Full offline docs are available in `share/doc/NsCDE/` after installation.

## License

GPLv3 - See [COPYING](COPYING) file for details.

## Links

- GitHub: https://github.com/wenyinos/NsCDE-zh
- Original NsCDE: https://github.com/NsCDE/NsCDE
- Wiki: https://github.com/wenyinos/NsCDE-zh/wiki
- FAQ: https://github.com/wenyinos/NsCDE-zh/wiki/NsCDE---Frequently-Asked-Questions-(FAQ)

---

# **Introduction**

### What is **NsCDE**?

**NsCDE** is a retro but powerful UNIX desktop environment which resembles the CDE look (and partially feel) but with a more powerful and flexible framework beneath the surface, more suited for 21st century Unix-like and Linux systems and user requirements than the original CDE.

**NsCDE** can be considered as a heavyweight FVWM theme on steroids, but combined with a couple of other free software components and custom FVWM applications and a lot of configuration, **NsCDE** can be considered a lightweight hybrid desktop environment.

In other words, **NsCDE** is a heavy FVWM (ab)user. It consists of a set of FVWM applications and configurations, enriched with Python and Shell background drivers, and a couple of additional free software tools and applications. FVWM3 is also supported.

Visually, **NsCDE** mimics CDE, the well known Common Desktop Environment of many commercial UNIX systems of the nineties. It supports CDE backdrops and palettes with FVWM colorsets and has a theme generator for Xt, Xaw, Motif, GTK2, GTK3, Qt4 and Qt5. Integrating all these bits and pieces, the user gets a retro visual experience across almost all X11 applications. Enriched with a bunch of powerful FVWM concepts and functions, modern applications and font rendering, **NsCDE** acts as a link between classic CDE look and a fast and extensible environment, well suited for modern day computing.

**NsCDE** can even be integrated into existing desktop environments as a FVWM window manager wrapper for session handling and additional desktop environment functionality.

Nevertheless, **NsCDE** is designed for UNIX oriented users, and generally technical people, and not as something for general public use or for introducing beginners to Linux or some other Unix-like system.

As previously said, NsCDE's main goal is to revive the look and feel of the Common Desktop Environment found on many UNIX and Unix-like systems during the nineties and the first decade of the 21st century, but with a slightly more polished interface (XFT, unicode, dynamic changes, rich keyboard and mouse bindings, desk pages, rich menus etc.). The goal is a comfortable retro environment which is not just an eye candy toy, but a real working environment for users who, contrary to mainstream trends, really like CDE, thus making a semi-optimal blend of usability and compatibility with modern tools with a look and feel which mainstream abandoned for some new fashion, and in a nutshell, giving the best of both worlds to the user.

The excellent FVWM window manager is the main driver behind **NsCDE** with its endless options for customization, GUI Script engine, Colorsets, and modules. **NsCDE** is largely a wrapper around FVWM -- sort of like a heavyweight theme.

Other main components are GTK2, GTK3, Qt4 and Qt5 themes for unifying the look and feel of most Unix/Linux applications, custom scripts which are helpers and backend workers for GUI parts and some data from the original CDE, such as icons, palettes, and backdrops.

---

### Why **NsCDE**?

Since the nineties, I have always liked this environment and its somewhat crude socrealistic look in contrast to the "modern" Windows and GNOME approach which is going in the opposite direction from what I always liked to see on my screen. I have created this environment for my own usage 8-10 years ago and it was a patchwork, chaotic and not well suited for sharing with someone. While it looked ok on the surface, behind it was years of ad-hoc hacks and senseless configurations and scripts, dysfunctional menus, etc. Couple of months in a row I had the time and chance to rewrite this as a more consistent environment, first for myself, and during this process, the idea came to do it even better, and put it on the web for everyone else who may like this idea of a modern CDE.

**NsCDE** is intended for people who don't like "modern" hypes, interfaces that try to mimic Mac and Windows and reimplement their ideas for non-technical user's desktops, and reimplement them poorly. Older and mature system administrators, programmers and generally people with a Unix background are more likely to have attraction to **NsCDE**. It is probably not well suited for beginners.

Of course, the question arises: why not simply use the original CDE now that it is open source?

Apart from its desirable look, because it has its own problems: It is a product from the 90s, based on Motif and a long time has passed since then. In CDE there is really no XFT font rendering, no immediate dynamic application changes. Besides that, I have found dtwm, CDE's window manager, inferior to FVWM and some 3rd party solutions which can be paired with it. So I wanted the best of both worlds: good old retro look and feel from original CDE, but more flexible, modern and maintained "driver" behind it, which will allow for individual customizations as one finds them fit for their own amusement and usage. As it will be seen later, there are some intentional differences between CDE and **NsCDE** - a middle ground between trying to stay as close as possible to the look of CDE, but with more flexibility and functionality on the second and third look.

---

### Components of **NsCDE**

#### Components Overview

**NsCDE** consists of 7 main facilities:

* extensive FVWM configuration and customization
* FvwmScript GUI programs
* GTK2 and GTK3 theme based on pixmap engine
* Icon theme
* Python programs and Korn Shell scripts
* Miscellaneous pieces for integration, like CSS for Firefox and Thunderbird, etc.
* Integrated free software components for desktop environment tasks

The central "driver" or framework is FVWM Window Manager. FVWM is in my opinion a model of free choice for people who like to have things set up as they wish and who are aware of what real freedom of choice is. A stunning contrast to policies forced on Linux users in the last decade by the most mainstream desktop players.

**NsCDE** is by default installed in `/usr/local` (`$NSCDE_ROOT`), but it can be relocated to any other installation path during pre-installation configuration.

It does not use the default configuration directory `$HOME/.fvwm` but sets its own `$FVWM_USERDIR` to `$HOME/.NsCDE`, and uses **NsCDE** private `$[FVWM_DATADIR]` as a source of configuration.
