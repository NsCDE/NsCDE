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

uninstall-hook:
	test -d $(DESTDIR)$(datarootdir)/applications && \
	(cd $(DESTDIR)$(datarootdir)/applications && rm -f NsCDE-*.desktop)
	test -d $(DESTDIR)$(datarootdir)/desktop-directories && \
	(cd $(DESTDIR)$(datarootdir)/desktop-directories && rm -f nscde-*.directory)
	test -d $(DESTDIR)$(datarootdir)/icons && \
	(cd $(DESTDIR)$(datarootdir)/icons && rm -rf NsCDE)
	test -d $(DESTDIR)$(XSESSDIR) && \
	(cd $(DESTDIR)$(XSESSDIR) && rm -f nscde.desktop)
	test -d $(DESTDIR)$(sysconfdir)/xdg/menus && \
	(cd $(DESTDIR)$(sysconfdir)/xdg/menus && rm -f nscde-applications.menu)
	rmdir $(DESTDIR)$(sysconfdir)/xdg/menus || :
	rmdir $(DESTDIR)$(sysconfdir)/xdg || :

