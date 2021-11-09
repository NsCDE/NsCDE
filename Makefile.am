#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

AUTOMAKE_OPTIONS = 1.4

SUBDIRS = src po doc bin data lib nscde_tools xdg

install-data-hook:
	$(mkinstalldirs) $(DESTDIR)$(docdir)
	-cp $(srcdir)/README.md $(DESTDIR)$(docdir)/
	-cp $(srcdir)/INSTALL.md $(DESTDIR)$(docdir)/
	-cp $(srcdir)/ChangeLog $(DESTDIR)$(docdir)/
	-cp $(srcdir)/COPYING $(DESTDIR)$(docdir)/LICENSE
	-cp $(srcdir)/ReleaseNotes.txt $(DESTDIR)$(docdir)/
	-cp $(srcdir)/README.localization $(DESTDIR)$(docdir)/

uninstall-hook:
	test -d $(DESTDIR)$(docdir) && \
	(cd $(DESTDIR)$(docdir) && rm -f README.md INSTALL.md \
	ChangeLog LICENSE ReleaseNotes.txt README.localization); \
	test -d $(DESTDIR)$(docdir) && rmdir $(DESTDIR)$(docdir) || :
