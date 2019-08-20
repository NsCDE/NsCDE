# **Not so Common Desktop Environment (NsCDE)**

![ScreenShot](NsCDE.png)

Notice: for a full documentation, see NsCDE/share/doc/*

Notice: for a set of photos, also download
https://github.com/NsCDE/NsCDE-photos/archive/photos-0.9.b86.tar.gz

Notice: for a set of old VUE palettes and backdrops, also download
https://github.com/NsCDE/NsCDE-VUE/archive/VUE-0.9.b99.tar.gz

See here for screenshots: https://imgur.com/gallery/nHkw35X

Author will like to apologize for bad english in docs. A rand() function putting
articles (the, a, an) will probably be more accurate.

# **Introduction**

  ## What is **NsCDE**?

   **NsCDE** is a retro but powerful (kind of) UNIX desktop environment
   which resembles CDE look and (partially feel) but with a more
   powerful and flexible beneath-the-surface framework, more suited
   for a 21st century unix-like and Linux systems and user requirements
   then original CDE.

   **NsCDE** can be considered as something between heavyweight FVWM
   theme on steroids, but combined with a couple other free software
   components and custom FVWM applications and heavy configurations,
   **NsCDE** can be considered as lightweight hybrid desktop environment.

   In other words, **NsCDE** is a heavy FVWM (ab)user. It consists of a
   set of FVWM applications and configurations, enriched with Python
   and Shell background drivers, couple of the additional free software
   tools and applications.

   Visually, **NsCDE** mimics CDE (well known old Common Desktop Environment
   of many comercial UNIX systems of nineties. It supports CDE backdrops
   and palettes with FVWM colorsets and theme generator for Xt, Xaw,
   Motif, GTK2, GTK3, Qt4 and Qt5. Integrating all this bits and pieces,
   user gets retro visual experience across almost all X11 applications,
   but enriched with a bunch of powerful FVWM concepts and functions,
   modern applications and font rendering, **NsCDE** acts as a link between
   CDE look, but here similarities are ending, because **NsCDE** aims to
   provide modern functionality, fast and extensible environment, well
   suited for a modern day computing.

   **NsCDE** can even be integrated into existing desktop environments as a
   FVWM window manager wrapper for session handling and additional DE
   functionality.

   Nevertheless, **NsCDE** is designed for a UNIX oriented users, and
   generally tehnical persons, and not as something for general public
   use or for introducing beginners to a Linux or some other unix-like
   system.

   As said, NsCDE's main goal is to revive look and feel of the Common Desktop
   Environment found on many UNIX and unix-like systems during nineties and
   first decade of the 21 century, but with a slightly polished interface
   (XFT, unicode, dynamic changes, rich key and mouse bindings, desk pages,
   rich menus etc) and a goal to produce comfortable "retro" environment
   which is not just a eye candy toy, but a real working environment for
   users who contrary to mainstream trends really like CDE, thus making
   semi-optimal blend of usability and compatibility with modern tools with
   look and feel which mainstream abadoned for some new fashion, and ... in a
   nutshell, giving to user the best of the both worlds.

   Main driver behind **NsCDE** is the excellent FVWM window manager with it's
   endless options for customization, GUI Script engine, Colorsets, and
   modules. **NsCDE** is largely a wrapper around FVWM - something like a
   heavyweight theme, sort of.

   Other main components are GTK2, GTK3, Qt4 and Qt5 theme for unifying look
   and feel for the most Unix/Linux applications, custom scripts which are
   helpers and backend workers for GUI parts and some data from the original
   CDE, as icons, palettes, and backdrops.

   --------------------------------------------------------------------------

  ## Why **NsCDE**?

   Since the nineties, I have always liked this environment and it's somewhat
   crude socrealistic look in a contrast to "modern" Windows and GNOME
   approach which is going in the opposite taste from what I always liked to
   see on my screen. I have created this environment for my own usage 8-10
   years ago and it was a patchwork, chaotic and not well suited for sharing
   with someone. While it looked ok on the surface, behind it was a years of
   ad hoc hacks and senseless configurations and scripts, dysfunctional menus
   etc. Couple of months in a row I had a time and chance to rewrite this as
   a more consistent environment, first for myself, and during this process,
   idea came to do it even better, and put on the web for everyone else who
   may like this idea of modern CDE.

   **NsCDE** is intended for a people which doesn't like "modern" hypes,
   interfaces that try to mimic Mac and Windows and reimplementing their
   ideas for non-technical user's desktops, and reimplementing them poorly.
   Older and mature system administrators, programmers and generally people
   from the Unix background are more likely to have attraction to **NsCDE**. It
   is probably not well suited for beginners.

   Of course, question arises: why not simply use original original CDE now
   when it is open sourced?

   Apart from desirable look, because it has it's own problems: it is a
   product from 90-ties, based on Motif and time has passed since then. In
   CDE there is no really XFT font rendering, no immediate application
   dynamic changes. Beside that, I have found dtwm, CDE's window manager
   inferior to FVWM and some 3rd party solutions which can be paired with it.
   So I wanted the best of the two worlds: good old retro look and feel from
   original CDE, but more flexible, modern and maintained "driver" behind it,
   which will allow for individual customizations as one find's them fit for
   it's own amusement and usage. As it will be seen later, there are some
   intentional differences between CDE and **NsCDE** - a middle line between
   trying to stay as close as possible to look of the CDE, but with more
   flexibility and functionality on the second and third look.

   --------------------------------------------------------------------------

## Components of the **NsCDE**

  ### Components overview

   **NsCDE** is a wrapper and a bunch of configurations, scripts and apps around
   FVWM. FVWM is in my opinion a model of free choice for people who like to
   have things set up by their own wishes and who are aware what real freedom
   of choice is. A stunning contrast to policies forced on Linux users in the
   last decade from the mainstream desktop players.

   **NsCDE** is by default rooted in /opt/NsCDE ($NSCDE_ROOT), but it can be
   relocated with only one variable changed in main wrapper bin/nscde and
   NsCDE-Main.conf.

   It is not using your existing $HOME/.fvwm but sets $FVWM_USERDIR to
   $HOME/.NsCDE, and uses /opt/NsCDE/config as a sources of configuration.

   Configuration model is a bit complex, but very flexible: configuration
   options are grouped in logical order. Configuration files are names
   NsCDE-<group>.conf. For example, NsCDE-Functions.conf for FVWM functions.
   Each configuration file can have two exclusive sources, and one
   additional. For example, if user doesn't have
   $FVWM_USERDIR/NsCDE-Functions.conf, then
   $NSCDE_ROOT/config/NsCDE-Functions.conf is read as default. Additionally,
   if $FVWM_USERDIR/NsCDE-Functions.local exists, it will be read in addition
   to conf file, from wherever it was read. This is intended as a primary
   mechanism for customization: If user doesn't need to override and change a
   lot of "system" configuration, but just add it's own in addition to
   existing, local file is place for such customization (of course, most
   parts of the existing FVWM configuration can be overridden or destroyed
   and recreated even in local files.

