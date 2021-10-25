#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

toolsdir = $(NSCDE_TOOLSDIR)/FvwmScripts

SCRIPTINS = $(wildcard $(srcdir)/*.in)
SCRIPTOUTS = $(foreach s,$(SCRIPTINS),$(shell echo $(s) | $(SED) 's/\.in$$//g'))
SCRIPTCLEAN = $(shell echo $(SCRIPTOUTS) | $(SED) 's/Makefile //g')

tools_SCRIPTS = $(SCRIPTCLEAN)

EXTRA_SCRIPTS =

clean-local:
	-rm -f $(SCRIPTCLEAN)

