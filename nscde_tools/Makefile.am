#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

SUBDIRS = FvwmScripts
OS_PLUS_MACHINE_ARCH = $(shell uname -sm | tr ' ' '_')

toolsdir = $(NSCDE_TOOLSDIR)

SCRIPTINS = $(wildcard $(srcdir)/*.in)
SCRIPTOUTS = $(foreach s,$(SCRIPTINS),$(shell echo $(s) | $(SED) 's/\.in$$//g'))
SCRIPTCLEAN = $(shell echo $(SCRIPTOUTS) | $(SED) 's/Makefile //g')

tools_SCRIPTS = $(SCRIPTCLEAN) style_managers.shlib

EXTRA_SCRIPTS =

clean-local:
	-rm -f $(SCRIPTCLEAN)

uninstall-hook:
	rmdir $(DESTDIR)$(NSCDE_TOOLSDIR)/FvwmScripts || :
	rmdir $(DESTDIR)$(NSCDE_TOOLSDIR)/$(OS_PLUS_MACHINE_ARCH) || :
	rmdir $(DESTDIR)$(NSCDE_TOOLSDIR) || :

