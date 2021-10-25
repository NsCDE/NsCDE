#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

fvwmdatadir = $(FVWM_DATADIR)

DYNCONFS = Functions.fvwmconf Main.fvwmconf
CONFS = $(shell echo $(srcdir)/*.fvwmconf)

fvwmdata_DATA = $(CONFS)

EXTRA_DATA =

clean-local:
	-rm -f $(DYNCONFS)

