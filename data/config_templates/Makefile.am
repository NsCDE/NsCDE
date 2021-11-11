#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

localscriptsdir = $(NSCDE_DATADIR)/config_templates/

localscripts_SCRIPTS = fontmgr.local colormgr.local

localdatadir = $(NSCDE_DATADIR)/config_templates/
localdata = Dunst.conf

clean-local:
	-rm -f colormgr.local fontmgr.local

clean-data:
	-rm -f Dunst.conf

install-data-hook:
	$(mkinstalldirs) $(DESTDIR)$(NSCDE_DATADIR)/config_templates/
	-cp -r $(srcdir)/app-defaults $(DESTDIR)$(NSCDE_DATADIR)/config_templates/
	-cp -r $(srcdir)/fvwm $(DESTDIR)$(NSCDE_DATADIR)/config_templates/
	-cp -r $(srcdir)/Gkrellm $(DESTDIR)$(NSCDE_DATADIR)/config_templates/
	-cp -r $(srcdir)/progbits $(DESTDIR)$(NSCDE_DATADIR)/config_templates/
	-cp -r $(srcdir)/BGdefault $(DESTDIR)$(NSCDE_DATADIR)/config_templates/
	-cp -r $(srcdir)/Dunst.conf $(DESTDIR)$(NSCDE_DATADIR)/config_templates/
	-cp -r $(srcdir)/GeoDB.ini $(DESTDIR)$(NSCDE_DATADIR)/config_templates/
	-cp -r $(srcdir)/Stalonetray.conf $(DESTDIR)$(NSCDE_DATADIR)/config_templates/
	-cp -r $(srcdir)/Xdefaults $(DESTDIR)$(NSCDE_DATADIR)/config_templates/
	-cp -r $(srcdir)/Xdefaults.fontdefs $(DESTDIR)$(NSCDE_DATADIR)/config_templates/
	-cp -r $(srcdir)/Xdefaults.mouse $(DESTDIR)$(NSCDE_DATADIR)/config_templates/
	-cp -r $(srcdir)/Xsettingsd.conf $(DESTDIR)$(NSCDE_DATADIR)/config_templates/
