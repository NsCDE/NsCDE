# Notice to all:

I have been busy past 3 years, and many asked if project is alive.
I have a plan to return in autumn. Firefox and Thunderbird CSS
are too much forward and themes for them (which were in mess anyway)
doesn't match cleanly anymore. Also, there are things to fix, commit
and so on. After the vacations and hot summer. September. Thanks to
all who care. I'll be back. :-)

# **Not so Common Desktop Environment (NsCDE)**

## 简体中文汉化版（NsCDE-zh）

本项目是 [NsCDE](https://github.com/NsCDE/NsCDE) 的**简体中文汉化分支**，在保留原版 CDE 复古风格与完整功能的基础上，对界面进行了全面简体中文本地化。本仓库由旧开发仓库 [wenyinos/NsCDE-zh](https://github.com/wenyinos/NsCDE-zh)（已归档）迁移而来，为**当前正式维护仓库**。

**汉化范围**：
- 全部 26 个 gettext 翻译域（FVWM 菜单、FvwmScript 对话框、样式管理器、启动/迁移脚本、Python 工具）**100% 简体中文化**
- 中文字体支持：内置文泉驿点阵宋体（WenQuanYi Bitmap Song）回退，缺字时自动回退 Noto Sans CJK SC，小字号下依然清晰锐利
- 软件包命名 `nscde-zh`（Debian/Arch）/ `NsCDE-zh`（RPM），与上游区分

**安装**：
- **Debian/Ubuntu**：从 [Releases](https://github.com/WenYin-Community/NsCDE/releases) 下载 `.deb` 安装
- **Fedora/RHEL**：`sudo dnf copr enable ruojiner/NsCDE-zh && sudo dnf install NsCDE-zh`
- **Arch Linux**：AUR 包 [nscde-zh](https://aur.archlinux.org/packages/nscde-zh)

**使用**：以 `LANG=zh_CN.UTF-8`（或 `LC_MESSAGES=zh_CN.UTF-8`）登录，启动 NsCDE 即为中文界面。

---

[![Github commits](https://img.shields.io/github/last-commit/NsCDE/NsCDE)](https://github.com/NsCDE/NsCDE/commits/master)
[![GitHub contributors](https://img.shields.io/github/contributors/NsCDE/NsCDE)](https://github.com/NsCDE/NsCDE/graphs/contributors)
[![PR's Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat)](https://github.com/NsCDE/NsCDE/pull/new)

![ScreenShot](NsCDE.png)

Notices:
- For a full documentation, see share/doc/NsCDE/*
- FAQ: https://github.com/NsCDE/NsCDE/wiki/NsCDE---Frequently-Asked-Questions-(FAQ)

Screenshots:
- https://imgur.com/gallery/nHkw35X
- https://imgur.com/gallery/RroGvLH

Video Presentations and guides:
- https://www.youtube.com/watch?v=BwuTOghS3ac&list=PLpVwwj0aIJjeHbA38F1z693-fKIC8IHS5
Set of 12 NsCDE video presentations (commented and titled screen captures) on
NsCDE Youtube channel.

- https://www.youtube.com/playlist?list=PLpVwwj0aIJjcaTFrZ5FLokl-kAMwmBxux
Set of newer 7 NsCDE video presentations, describing features implemented in
the last two years and for NsCDE 2.X

The author would like to apologize for bad English in the docs. A rand() function putting
(the, a, an) in articles would probably be more accurate.

# **Introduction**

### What is **NsCDE**?

   **NsCDE** is a retro but powerful `UNIX desktop environment` which
   resembles the `CDE` look (and partially feel) but with a more powerful
   and flexible framework beneath-the-surface, more suited for 21st
   century `unix-like` and `Linux` systems and user requirements than
   original `CDE`.

   **NsCDE** can be considered as a heavyweight `FVWM`
   theme on steroids, but combined with a couple other free software
   components and custom `FVWM` applications and a lot of configuration,
   **NsCDE** can be considered a lightweight hybrid desktop environment.

   In other words, **NsCDE** is a heavy `FVWM` (ab)user. It consists of a
   set of `FVWM` applications and configurations, enriched with Python
   and Shell background drivers, couple of the additional free software
   tools and applications. `FVWM3` is also supported.

   Visually, **NsCDE** mimics `CDE`, the well known `Common Desktop Environment`
   of many commercial UNIX systems of the nineties. It supports `CDE` backdrops
   and palettes with `FVWM` colorsets and has a theme generator for `Xt`, `Xaw`,
   `Motif`, `GTK2`, `GTK3`, `Qt4` and `Qt5`. Integrating all these bits and 
   pieces, the user gets a retro visual experience across almost all `X11` 
   applications. Enriched with a bunch of powerful `FVWM` concepts and functions,
   modern applications and font rendering, **NsCDE** acts as a link between
   classic `CDE` look and a fast and extensible environment, well suited for 
   modern day computing.

   **NsCDE** can even be integrated into existing desktop environments as a
   `FVWM` window manager wrapper for session handling and additional `DE`
   functionality.

   Nevertheless, **NsCDE** is designed for UNIX oriented users, and
   generally technical people, and not as something for general public
   use or for introducing beginners to Linux or some other `unix-like`
   system.

   As previously said, NsCDE's main goal is to revive the look and feel of the `Common 
   Desktop Environment` found on many `UNIX` and `unix-like` systems during 
   nineties and the first decade of the 21st century, but with a slightly 
   more polished interface (XFT, unicode, dynamic changes, rich keyboard and mouse 
   bindings, desk pages, rich menus etc.). The goal is a comfortable `retro` 
   environment which is not just eye candy toy, but a real working environment 
   for users who contrary to mainstream trends really like `CDE`, thus making
   a semi-optimal blend of usability and compatibility with modern tools with
   a look and feel which mainstream abandoned for some new fashion, and ... in a
   nutshell, giving the best of both worlds to the user.

   The excellent `FVWM` window manager is the main driver behind **NsCDE** with its
   endless options for customization, GUI Script engine, Colorsets, and
   modules. **NsCDE** is largely a wrapper around `FVWM` -- sort of like a
   heavyweight theme.

   Other main components are `GTK2`, `GTK3`, `Qt4` and `Qt5` themes for unifying 
   the look and feel of most Unix/Linux applications, custom scripts which are
   helpers and backend workers for GUI parts and some data from the original
   `CDE`, such as icons, palettes, and backdrops.

   --------------------------------------------------------------------------

### Why **NsCDE**?

   Since the nineties, I have always liked this environment and its somewhat
   crude socrealistic look in a contrast to the "modern" Windows and `GNOME`
   approach which is going in the opposite direction from what I always liked to
   see on my screen. I have created this environment for my own usage 8-10
   years ago and it was a patchwork, chaotic and not well suited for sharing
   with someone. While it looked ok on the surface, behind it was years of
   ad-hoc hacks and senseless configurations and scripts, dysfunctional menus,
   etc. Couple of months in a row I had the time and chance to rewrite this as
   a more consistent environment, first for myself, and during this process,
   idea came to do it even better, and put it on the web for everyone else who
   may like this idea of a modern `CDE`.

   **NsCDE** is intended for people who don't like "modern" hypes,
   interfaces that try to mimic Mac and Windows and reimplement their
   ideas for non-technical user's desktops, and reimplement them poorly.
   Older and mature system administrators, programmers and generally people
   with a Unix background are more likely to have attraction to **NsCDE**. It
   is probably not well suited for beginners.

   Of course, the question arises: why not simply use the original `CDE` now
   that it is open source?

   Apart from its desirable look, because it has its own problems: It is a
   product from the 90s, based on Motif and a long time has passed since then. In
   `CDE` there is really no XFT font rendering, no immediate dynamic application changes.
   Besides that, I have found `dtwm`, CDE's window manager,
   inferior to `FVWM` and some 3rd party solutions which can be paired with it.
   So I wanted the best of both worlds: good old retro look and feel from
   original `CDE`, but more flexible, modern and maintained "driver" behind it,
   which will allow for individual customizations as one find's them fit for
   their own amusement and usage. As it will be seen later, there are some
   intentional differences between `CDE` and **NsCDE** - a middle ground between
   trying to stay as close as possible to look of the `CDE`, but with more
   flexibility and functionality on the second and third look.

   --------------------------------------------------------------------------

### Components of the **NsCDE**

#### Components overview

   **NsCDE** consists of 7 main facilities

   * extensive `FVWM` configuration and customization
   * FvwmScript GUI programs
   * GTK2 and GTK3 theme based on pixmap engine
   * Icon theme
   * Python programs and Korn Shell scripts
   * Miscellaneous pieces for integration, like CSS for `Firefox` and `Thunderbird`, etc...
   * Integrated free software components for desktop environment tasks

   Central "driver" or framework is FVWM Window Manager. `FVWM` is in my opinion
   a model of free choice for people who like to have things set up as they
   wish and and who are aware of what real freedom of choice is. A stunning
   contrast to policies forced on Linux users in the last decade by the
   most mainstream desktop players.

   **NsCDE** is by default installed in `/usr/local` (`$NSCDE_ROOT`), but it can
   be relocated to any other installation path during pre-installation
   configuration.

   It is not using the default configuration directory `$HOME/.fvwm` but sets it's
   own `$FVWM_USERDIR` to `$HOME/.NsCDE`, and uses **NsCDE** private
   `$[FVWM_DATADIR]` as a source of configuration.

