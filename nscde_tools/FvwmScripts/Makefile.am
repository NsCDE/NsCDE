#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

toolsdir = $(NSCDE_TOOLSDIR)/FvwmScripts

tools_SCRIPTS = GWM Splash Notifier

EXTRA_SCRIPTS =

clean-local:
	-rm -f $(tools_SCRIPTS)

uninstall-hook:
	rmdir $(toolsdir) || true

