#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

SUBDIRS = fvwm config_templates

install-data-hook:
	$(mkinstalldirs) $(DESTDIR)$(NSCDE_DATADIR)
	-cp -r $(srcdir)/backdrops $(DESTDIR)$(NSCDE_DATADIR)/
	-cp -r $(srcdir)/defaults $(DESTDIR)$(NSCDE_DATADIR)/
	-cp -r $(srcdir)/examples $(DESTDIR)$(NSCDE_DATADIR)/
	-cp -r $(srcdir)/fallback $(DESTDIR)$(NSCDE_DATADIR)/
	-cp -r $(srcdir)/fontsets $(DESTDIR)$(NSCDE_DATADIR)/
	-cp -r $(srcdir)/help $(DESTDIR)$(NSCDE_DATADIR)/
	-cp -r $(srcdir)/icons $(DESTDIR)$(NSCDE_DATADIR)/
	-cp -r $(srcdir)/integration $(DESTDIR)$(NSCDE_DATADIR)/
	-cp -r $(srcdir)/palettes $(DESTDIR)$(NSCDE_DATADIR)/
	-cp -r $(srcdir)/photos $(DESTDIR)$(NSCDE_DATADIR)/

uninstall-hook:
	test -d $(DESTDIR)$(NSCDE_DATADIR) && \
	(cd $(DESTDIR)$(NSCDE_DATADIR) && \
	rm -rf backdrops defaults examples fallback \
	fontsets help icons integration palettes \
	config_templates fvwm photos)
	test -d $(DESTDIR)$(NSCDE_DATADIR) && \
	rmdir $(DESTDIR)$(NSCDE_DATADIR) || :
