Name:		NsCDE
Version:	2.0
Release:	2%{?dist}
Summary:	Not so Common Desktop Environment

License:	GPLv3
URL:		https://github.com/NsCDE
Source0:	https://github.com/NsCDE/NsCDE/releases/download/2.0/NsCDE-2.0.tar.gz

BuildRequires:  gcc
BuildRequires:	autoconf
BuildRequires:	automake
BuildRequires:	make
BuildRequires:	gettext libX11-devel libXt-devel libXext-devel libXpm-devel
%if 0%{?fedora} || 0%{?rhel_version} || 0%{?centos_version}
BuildRequires:  glibc-headers
%endif
%if 0%{?suse_version}
BuildRequires:  glibc-devel
%endif
Requires:	xterm ksh sed fvwm cpp xsettingsd stalonetray dunst xclip xdotool
Requires:	python3-pyxdg python3-psutil qt5ct
%if 0%{?fedora} || 0%{?rhel_version} || 0%{?centos_version}
Requires: python3-yaml PyQt5 qt5-qtstyleplugins dex-autostart
%endif
%if 0%{?suse_version}
Requires: python3-qt5 python3-pyaml libqt5-qtstyleplugins-platformtheme-gtk2 dex
%endif
Requires:	%{_bindir}/convert
Requires:	%{_bindir}/import
Requires:	%{_bindir}/xrdb
Requires:	%{_bindir}/xset
Requires:	%{_bindir}/xprop
Requires:	%{_bindir}/xdpyinfo
Requires:	%{_bindir}/xrandr
Requires:	xdg-utils

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
%autosetup -p1


%build
autoreconf -ivf
%configure --prefix=/usr --sysconfdir=/etc
%make_build


%install
%make_install

%files
%{_bindir}/*
%{_libexecdir}/%{name}/
%{_libdir}/%{name}/
%{_datadir}/applications/
%{_datadir}/desktop-directories/
%{_datadir}/xsessions/nscde.desktop
%{_datadir}/icons/
%{_datadir}/doc/nscde/
%{_datadir}/locale/*
%{_datadir}/%{name}/
%{_sysconfdir}/xdg/menus/nscde-applications.menu


%changelog
* Tue Nov 9 2021 Hegel3DReloaded <nscde@protonmail.com> - 2.0
- First RPM package, working example

