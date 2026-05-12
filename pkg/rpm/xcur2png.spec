Name:           xcur2png
Version:        0.7.1
Release:        3.2
Summary:        Take PNG images from Xcursor and generate xcursorgen config-file
Group:          User Interface/X
License:        GPLv3
URL:            https://github.com/eworm-de/xcur2png
Source0:        https://github.com/eworm-de/%{name}/releases/download/%{version}/%{name}-%{version}.tar.gz
BuildRequires:  pkgconfig libpng-devel libXcursor-devel

%description
xcur2png is a program which let you take PNG image from X cursor,
and generate config-file which is reusable by xcursorgen.

%prep
%setup -q

%build
%configure
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

%files
%doc COPYING ChangeLog README AUTHORS NEWS
%{_bindir}/xcur2png
%{_mandir}/man1/xcur2png.1*

%changelog
* Tue May 12 2026 NsCDE COPR <ruojiner@users.noreply.github.com> - 0.7.1-3.2
- Use GitHub release source because the original upstream host no longer resolves in COPR

* Mon Oct 17 2016 Wei-Lun Chao <bluebat@member.fsf.org> - 0.7.1
- Rebuilt for Fedora
* Thu Jan 01 2009 tks - 0.7.1-1%{?dist}
- Version 0.7.1
* Thu Oct 09 2008 tks - 0.7.0-1%{?dist}
- Version 0.7.0
* Tue Sep 23 2008 tks - 0.6.3-1%{?dist}
- Version 0.6.3
* Mon Sep 22 2008 tks - 0.6.2-1%{?dist}
- Version 0.6.2
* Thu Sep 18 2008 tks - 0.6.1-1%{?dist}
- Version 0.6.1
* Tue Sep 16 2008 tks - 0.6-1%{?dist}
- Version 0.6
* Sat Aug 08 2008 tks - 0.5.1-1%{?dist}
- Version 0.5.1
* Sat Aug 01 2008 tks - 0.5-1%{?dist}
- Version 0.5
* Sat Jul 26 2008 tks - 0.4.1-1%{?dist}
- Version 0.4.1
* Sat Jul 26 2008 tks - 0.4-1%{?dist}
- Inicial release.
