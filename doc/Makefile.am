#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

SUBDIRS = docbook

install-data-hook:
	$(mkinstalldirs) $(DESTDIR)$(docdir)
	-cp -r $(srcdir)/examples $(DESTDIR)$(docdir)/

uninstall-hook:
	test -d $(DESTDIR)$(docdir) && (cd $(DESTDIR)$(docdir) && rm -rf examples) ; \
	test -d $(DESTDIR)$(docdir) && rmdir $(DESTDIR)$(docdir) || :
