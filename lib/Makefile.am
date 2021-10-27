#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

SUBDIRS = fvwm-modules python scripts
OS_PLUS_MACHINE_ARCH = $(shell uname -sm | tr ' ' '_')

uninstall-hook:
	rmdir $(DESTDIR)$(NSCDE_LIBDIR)/python || :
	rmdir $(DESTDIR)$(NSCDE_LIBDIR)/scripts || :
	rmdir $(DESTDIR)$(NSCDE_LIBDIR)/fvwm-modules || :
	rmdir $(DESTDIR)$(NSCDE_LIBDIR)/$(OS_PLUS_MACHINE_ARCH) || :
	rmdir $(DESTDIR)$(NSCDE_LIBDIR) || :

