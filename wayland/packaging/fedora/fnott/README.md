# Fedora RPM Packaging For fnott

This package definition builds `fnott` from upstream source for Fedora. Do not
repackage the Arch Linux binary package directly; it is built against Arch
library versions and may pull dependencies that do not match Fedora.

The Arch package at:

```text
https://ftp5.gwdg.de/pub/linux/archlinux/extra/os/x86_64/fnott-1.8.0-1-x86_64.pkg.tar.zst
```

was used only as a reference for metadata, installed file layout, and dependency
names.

## Build Dependencies

```sh
sudo dnf install \
  rpm-build curl meson gcc pkgconf-pkg-config scdoc \
  tllist-devel fcft-devel wayland-devel wayland-protocols-devel \
  dbus-devel pixman-devel libpng-devel fontconfig-devel \
  systemd-rpm-macros
```

## Build

```sh
mkdir -p ~/rpmbuild/SOURCES
curl -L \
  -o ~/rpmbuild/SOURCES/fnott-1.8.0.tar.gz \
  https://codeberg.org/dnkl/fnott/archive/1.8.0.tar.gz

rpmbuild -ba wayland/packaging/fedora/fnott/fnott.spec
```

The resulting RPMs will be under:

```text
~/rpmbuild/RPMS/
~/rpmbuild/SRPMS/
```

The spec installs both the D-Bus activation service and the systemd user unit.
The systemd unit is integration support for Fedora; fnott can still be launched
from a compositor autostart file without requiring `systemctl --user`.
