Name:           NsCDE-zh-Wayland
Version:        0.1.0
Release:        1%{?dist}
Summary:        CDE-style native Wayland session for NsCDE-zh

License:        GPLv3
URL:            https://github.com/wenyinos/NsCDE-zh
Source0:        %{url}/archive/refs/tags/v%{version}.tar.gz#/%{name}-%{version}.tar.gz

BuildArch:      noarch
BuildRequires:  make
BuildRequires:  /usr/bin/xmllint

Requires:       labwc
Requires:       foot
Requires:       fuzzel
Requires:       fnott
Requires:       sfwbar
Requires:       lavalauncher
Requires:       (wbg or swaybg)
Requires:       wl-clipboard
Requires:       grim
Requires:       slurp
Requires:       wlr-randr
Requires:       kanshi
Requires:       pcmanfm-qt
Requires:       nwg-look
Requires:       qt5ct
Requires:       qt6ct
Recommends:     kvantum
Recommends:     xcur2png
Provides:       nscde-wayland = %{version}-%{release}

%description
NsCDE-zh-Wayland provides a standalone NsCDE-style Wayland desktop session
built around labwc. It installs the native Wayland launcher, labwc session
configuration, CDE-style assets, and theme resources under the system install
prefix. It does not require systemd user services; labwc autostart is the
default component startup path.

%prep
%autosetup -p1 -n NsCDE-zh-%{version}

%build

%install
make -C wayland install PREFIX=%{_prefix} DESTDIR=%{buildroot}

%check
make -C wayland check

%files
%license COPYING
%doc wayland/README.md WAYLAND_LABWC_PORT_PLAN.md
%{_bindir}/nscde-labwc
%{_bindir}/nscde-wayland-run
%{_bindir}/nscde-output-scale
%{_bindir}/nscde-wayland-screenshot
%{_bindir}/nscde-wayland-doctor
%{_datadir}/wayland-sessions/nscde-labwc.desktop
%{_datadir}/nscde-wayland/
%{_datadir}/themes/NsCDE-Wayland/
%{_datadir}/icons/NsCDE/

%changelog
* Tue May 12 2026 wenyinos <admin@wenyinos.com> - 0.1.0-1
- Initial NsCDE-zh Wayland labwc session package
