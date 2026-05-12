Name:           fnott
Version:        1.8.0
Release:        1%{?dist}
Summary:        Keyboard driven and lightweight Wayland notification daemon

License:        MIT
URL:            https://codeberg.org/dnkl/fnott
Source0:        https://codeberg.org/dnkl/fnott/archive/%{version}.tar.gz#/%{name}-%{version}.tar.gz

BuildRequires:  gcc
BuildRequires:  meson
BuildRequires:  scdoc
BuildRequires:  systemd-rpm-macros
BuildRequires:  pkgconfig(dbus-1)
BuildRequires:  pkgconfig(fcft) >= 3.0.0
BuildRequires:  pkgconfig(fontconfig)
BuildRequires:  pkgconfig(libpng)
BuildRequires:  pkgconfig(pixman-1)
BuildRequires:  pkgconfig(tllist) >= 1.0.1
BuildRequires:  pkgconfig(wayland-client)
BuildRequires:  pkgconfig(wayland-cursor)
BuildRequires:  pkgconfig(wayland-protocols) >= 1.32
BuildRequires:  pkgconfig(wayland-scanner)

Requires:       dbus

%description
fnott is a lightweight notification daemon for wlroots-based Wayland
compositors. It implements parts of the Desktop Notification Specification and
can be controlled with fnottctl.

%prep
%autosetup -n fnott

%build
%meson \
  -Dwerror=false \
  -Ddocs=enabled \
  -Dsystem-nanosvg=disabled \
  -Dsystemd-units-dir=%{_userunitdir}
%meson_build

%install
%meson_install
rm -f %{buildroot}%{_docdir}/%{name}/LICENSE
rm -f %{buildroot}%{_docdir}/%{name}/README.md

%files
%license LICENSE
%doc README.md CHANGELOG.md
%{_bindir}/fnott
%{_bindir}/fnottctl
%config(noreplace) %{_sysconfdir}/xdg/fnott/fnott.ini
%{_datadir}/applications/fnott.desktop
%{_datadir}/dbus-1/services/fnott.service
%{_userunitdir}/fnott.service
%{_datadir}/fish/vendor_completions.d/fnott.fish
%{_datadir}/fish/vendor_completions.d/fnottctl.fish
%{_datadir}/zsh/site-functions/_fnott
%{_datadir}/zsh/site-functions/_fnottctl
%{_mandir}/man1/fnott.1*
%{_mandir}/man1/fnottctl.1*
%{_mandir}/man5/fnott.ini.5*

%changelog
* Tue May 12 2026 wenyinos <admin@wenyinos.com> - 1.8.0-1
- Initial Fedora RPM spec for fnott 1.8.0
