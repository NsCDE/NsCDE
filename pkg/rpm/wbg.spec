%global debug_package %{nil}

Name:       wbg
Version:    1.3.0
Release:    1%{?dist}
Summary:    Super simple wallpaper application for Wayland compositors implementing the layer-shell protocol.

License:    MIT
URL:        https://codeberg.org/dnkl/wbg
Source0:    %{url}/archive/%{version}.tar.gz

BuildRequires: pixman-devel
BuildRequires: nanosvg-devel
BuildRequires: wayland-protocols-devel
BuildRequires: libpng-devel
BuildRequires: libjpeg-turbo-devel
BuildRequires: libjxl-devel
BuildRequires: cmake
BuildRequires: gcc
BuildRequires: meson
BuildRequires: ninja-build
BuildRequires: wayland-devel
BuildRequires: python3
BuildRequires: tllist-devel
BuildRequires: libwebp-devel

Requires: pixman
Requires: libpng
Requires: libwayland-cursor
Requires: libwayland-client
Requires: libjpeg-turbo
Requires: libwebp
Requires: libjxl
Requires: nanosvg

%description
Super simple wallpaper application for Wayland compositors implementing the layer-shell protocol. Wbg takes a single command line argument: a path to an image file. This image is displayed scaled-to-fit on all monitors.

%prep
%autosetup -n wbg

%build
export CFLAGS="%{optflags}"
%meson
%meson_build

%install
%meson_install

strip --strip-all %{buildroot}%{_bindir}/*

%files
%license LICENSE
%doc README.md
%{_bindir}/wbg

%changelog
