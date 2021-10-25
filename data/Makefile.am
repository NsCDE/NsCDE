#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

install-data-hook:
	$(mkinstalldirs) $(DESTDIR)$(NSCDE_DATADIR)
	-cp -r $(srcdir)/* $(DESTDIR)$(NSCDE_DATADIR)
	-rm -f $(DESTDIR)$(NSCDE_DATADIR)/fvwm/Main.fvwmconf.in
	-rm -f $(DESTDIR)$(NSCDE_DATADIR)/Makefile*
