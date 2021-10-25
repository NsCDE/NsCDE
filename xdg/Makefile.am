#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

install-data-hook:
	$(mkinstalldirs) $(DESTDIR)$(datarootdir)/applications
	-cp -r $(srcdir)/applications/NsCDE-*.desktop $(DESTDIR)$(datarootdir)/applications/
	$(mkinstalldirs) $(DESTDIR)$(datarootdir)/desktop-directories
	-cp -r $(srcdir)/desktop-directories/nscde-*.directory $(DESTDIR)$(datarootdir)/desktop-directories/
	$(mkinstalldirs) $(DESTDIR)$(datarootdir)/icons
	-cp -r $(srcdir)/icons/NsCDE $(DESTDIR)$(datarootdir)/icons/
	$(mkinstalldirs) $(DESTDIR)$(sysconfdir)/xdg/menus
	-cp -r $(srcdir)/menus/nscde-applications.menu $(DESTDIR)$(sysconfdir)/xdg/menus/
	$(mkinstalldirs) $(DESTDIR)$(XSESSDIR)
	-cp -r $(srcdir)/xsessions/nscde.desktop $(DESTDIR)$(XSESSDIR)/

