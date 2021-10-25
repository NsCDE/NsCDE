#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

SUBDIRS = fvwm

install-data-hook:
	$(mkinstalldirs) $(DESTDIR)$(NSCDE_DATADIR)
	-cp -r $(srcdir)/backdrops $(DESTDIR)$(NSCDE_DATADIR)/
	-cp -r $(srcdir)/config_templates $(DESTDIR)$(NSCDE_DATADIR)/
	-cp -r $(srcdir)/defaults $(DESTDIR)$(NSCDE_DATADIR)/
	-cp -r $(srcdir)/examples $(DESTDIR)$(NSCDE_DATADIR)/
	-cp -r $(srcdir)/fallback $(DESTDIR)$(NSCDE_DATADIR)/
	-cp -r $(srcdir)/fontsets $(DESTDIR)$(NSCDE_DATADIR)/
	-cp -r $(srcdir)/help $(DESTDIR)$(NSCDE_DATADIR)/
	-cp -r $(srcdir)/icons $(DESTDIR)$(NSCDE_DATADIR)/
	-cp -r $(srcdir)/integration $(DESTDIR)$(NSCDE_DATADIR)/
	-cp -r $(srcdir)/palettes $(DESTDIR)$(NSCDE_DATADIR)/
	-cp -r $(srcdir)/photos $(DESTDIR)$(NSCDE_DATADIR)/
