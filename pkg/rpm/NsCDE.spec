Name:		NsCDE-zh
Version:	2.3.10
Release:	1%{?dist}
Summary:	Not so Common Desktop Environment - Chinese Localization
AutoReqProv:	no

License:	GPLv3
URL:		https://github.com/wenyinos/NsCDE-zh
Source0:	%{url}/archive/refs/tags/v%{version}_zh/%{name}-%{version}_zh.tar.gz

BuildRequires:  ksh
BuildRequires:  gcc
BuildRequires:	autoconf
BuildRequires:	automake
BuildRequires:	make
BuildRequires:	gettext libX11-devel libXext-devel libXpm-devel
%if 0%{?fedora} || 0%{?rhel_version} || 0%{?centos_version}
BuildRequires:  glibc-headers
%endif
%if 0%{?suse_version}
BuildRequires:  glibc-devel
%endif
Requires:	xterm ksh sed fvwm3 cpp xsettingsd stalonetray dunst xclip xdotool
Requires:	python3-pyxdg python3-psutil python3-yaml
Requires:	qt5ct qt6ct
%if 0%{?fedora} || 0%{?rhel_version} || 0%{?centos_version}
Requires: PyQt5 qt5-qtstyleplugins dex-autostart groff-base dejavu-serif-fonts
Requires: google-noto-sans-cjk-fonts google-noto-sans-cjk-vf-fonts google-noto-sans-mono-cjk-vf-fonts google-noto-sans-mono-fonts
%endif
%if 0%{?suse_version}
Requires: python3-pyqt5 libqt5-qtstyleplugins-platformtheme-gtk2 dex groff-full dejavu-fonts-ttf
Requires: noto-sans-cjk-fonts
%endif
Suggests:	qt5-qtstyleplugins
Requires:	%{_bindir}/convert
Requires:	%{_bindir}/import
Requires:	%{_bindir}/xrdb
Requires:	%{_bindir}/xset
Requires:	%{_bindir}/xprop
Requires:	%{_bindir}/xdpyinfo
Requires:	%{_bindir}/xrandr
Requires:	xdg-utils gettext

%description
NsCDE is a retro but powerful UNIX desktop environment which resembles
CDE look (and partially feel) but with a more powerful and flexible
framework beneath-the-surface, more suited for 21st century unix-like
and Linux systems and user requirements than original CDE.

NsCDE can be considered as a heavyweight FVWM theme on steroids, but
combined with a couple other free software components and custom FVWM
applications and a lot of configuration, NsCDE can be considered a
lightweight hybrid desktop environment.


%prep
%autosetup -p1 -n %{name}-%{version}_zh


%build
autoreconf -ivf
%configure --prefix=/usr --sysconfdir=/etc --libexecdir=%{_libexecdir}/NsCDE
%make_build

%install
%make_install

%files
%{_bindir}/nscde
%{_bindir}/nscde_fvwmclnt
%{_libexecdir}/NsCDE/
%{_libdir}/NsCDE/
%{_datadir}/applications/
%{_datadir}/desktop-directories/
%{_datadir}/xsessions/nscde.desktop
%{_datadir}/icons/NsCDE/
%{_datadir}/doc/nscde/
%{_datadir}/locale/*
%{_datadir}/NsCDE/
%{_sysconfdir}/xdg/menus/nscde-applications.menu

%changelog
* Thu May 01 2026 wenyinos <admin@wenyinos.com>  - 2.3.10-1
- Update to 2.3.10 release
- Add DefaultAppsMgr FvwmScript GUI dialog
- Integrate pcmanfm-qt Application Manager mode
- Fix FontMgr fontset deletion selection
- Implement syslastbooted in sysinfo
- Fix Calendar text color in GTK3 CSS
- Update packaging dependencies

* Thu May 01 2026 wenyinos <admin@wenyinos.com>  - 2.3.5-1
- Update to 2.3.5 release
- Add DefaultAppsMgr FvwmScript GUI dialog
- Integrate pcmanfm-qt Application Manager mode
- Fix FontMgr fontset deletion selection
- Implement syslastbooted in sysinfo
- Fix Calendar text color in GTK3 CSS
- Update packaging dependencies

* Tue Apr 28 2026 wenyinos <admin@wenyinos.com>  - 2.3.4-1
- Update to 2.3.4 release
- Move desktop helper apps from hard Requires to Recommends

* Wed Apr 15 2026 wenyinos <admin@wenyinos.com>  - 2.3.2-1
- Update to 2.3.2 release

* Wed Apr 15 2026 wenyinos <admin@wenyinos.com>  - 2.3.1-1
- Chinese localization version
- Add full Chinese (zh) translation support
- Fix build system to compile and install Chinese locales
- 25 translation files for Chinese language
- Add NotoSansCJK.fontset for Chinese character support
- Add google-noto-sans-cjk-fonts google-noto-sans-cjk-vf-fonts
  google-noto-sans-mono-cjk-vf-fonts google-noto-sans-mono-fonts dependencies
- Based on NsCDE 2.3.1 release

* Fri Jun 16 2023 Hegel3DReloaded <nscde@protonmail.com>  - 2.3-3
- Portability and bug fixes
- Misc small fixes
- Release 2.3

* Mon Jun 5 2023 Hegel3DReloaded <nscde@protonmail.com>  - 2.3-2
- Font and Color Style Manager: reload new themes without FVWM restart
- Qt6 integration support
- Optional Picom X Compositor internal support
- Thunderbird 102+ CSS theme integration support
- Firefox up to 113+ CSS theme integration support
- Font and Color Style Manager reshape, add integrations as separate dialog
- (De)Iconify X11 freeze glitch fvwm workaround
- Front Panel initial placement fix instead of workaround
- Fix GWM FvwmScript segfault on exit
- More missing icons in XDG icon theme
- Handle gsettings org.gnome.desktop.interface color-scheme
- Xscreensaver 6.X support
- Add detailed X resources for xcalc and some old Athena based apps
- Tuning X resources for more old apps
- Font and Color Style Manager: remember widget integration options
- GTK3 theme fixes: treat nasty header bar as toolbar
- Initial setup: add detailed integration questions, Qt6 support
- Front Panel clock: triangle hour and minute hands to match original
- GWMPager as popup on workspace change in no-page mode
- Fixed some easy-to-make keyboard shortcuts accidental calls
- Firefox and Thunderbird user.js additions for nice initial look & feel
- Thunderbird HTML compose window toolbar fix
- Docs update, many portability fixes, misc fixes, some typo fixes

* Mon Oct 31 2022 Hegel3DReloaded <nscde@protonmail.com> - 2.3-1
- Start with 2.3
- Add groff-full / groff-base as dependency for panel and subpanel help

* Sun Jul 24 2022 Hegel3DReloaded <nscde@protonmail.com> - 2.2.6
- Add kcalc colors tom match dtcalc (colormgr.local)
- Fix rofi and dunst themes to work with new versions of programs
- NsCDE .desktop files renamed to conform to standards
- Front Panel on top of the screen possibility implemented. This
  can be achieved with "InfoStoreAdd frontpanel.on.top 1" in
  ~/.NsCDE/NsCDE.conf.
- Icon theme updates
- CSS: support firefox 100+
- Consolidate GTK2 and GTK3 engine css files, add some fixes
  and match colors more correctly
- Added Common User Access (CUA) key bindings. This is now
  default key binding set in NsCDE. Old key bindings scheme
  now called "nscde1x" can be used in ~/.NsCDE/NsCDE.conf
  with the "InfoStoreAdd kbd_bind_set nscde1x" - this can also
  be configured now with Keyboard Style Manager
- Keyboard Style Manager addons, Mouse Style Manager fixes
- Building: add --with-python-shebang="STRING" in configure
  to allow user to override strange alternatives managers on
  some systems
- Reorganize f_PolkitAgent to be more portable and stable
- Kvantum: Reshape in more Motif style Qt5 Combo Box
- More Firefox CSS updates
- Documentation updates for all of the above

* Thu Jul 14 2022 Hegel3DReloaded <nscde@protonmail.com> - 2.2.5
- Works on keybindings continued

* Mon Jul 11 2022 Hegel3DReloaded <nscde@protonmail.com> - 2.2.4
- Works on CUA keybinding set

* Tue Mar 22 2022 Hegel3DReloaded <nscde@protonmail.com> - 2.1-4
- New colormgr.local / colormgr.addons scheme
- Introduce key binding sets
- Backup old gtk and qt configs during bootstrap
- Optionally specify alternative root setter for fvwm3 non-global monitors
- Inject new NSCDE_VERSION on restart after upgrade
- Various fixes
- Qt5 Kvantum engine support
- Update docs

* Thu Jan 6 2022 Hegel3DReloaded <nscde@protonmail.com> - 2.0-6
- Fix system Subpanels.actions S10 help backspaces
- Fix move first item to the end double copy on the subpanels

* Wed Jan 5 2022 Hegel3DReloaded <nscde@protonmail.com> - 2.0-5
- Fix generate_subpanels backslash and quoting

* Tue Dec 21 2021 Hegel3DReloaded <nscde@protonmail.com> - 2.0-4
- Release NsCDE 2.0
- Fix Qt5 qt5ct.conf new fonts handling
- Update fontsets for higher resolutions
- Add more handy key bindings into style managers
- Documentation now has descriptions of XDG subsystems in NsCDE
- Support for more terminal emulators in colormgr.local and fontmgr.local
- Illustrated documentation
- Smart XDG paths from configure.ac
- Front Panel and Subpanels smart contextual Help
- Correct screen calculation for GWM under FVWM3 with multiple monitors
- Misc minor fixes

* Fri Dec 3 2021 Hegel3DReloaded <nscde@protonmail.com> - 2.0-3
- Introduce Front Panel Icon Manager
- Update docs and locales
- Misc minor fixes
- Move Front Panel icons feature
- Rename Subpanel Items feature
- Input checking

* Tue Nov 9 2021 Hegel3DReloaded <nscde@protonmail.com> - 2.0
- First RPM package, working example
