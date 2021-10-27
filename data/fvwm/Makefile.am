#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

fvwmdatadir = $(FVWM_DATADIR)

DYNCONFS = Functions.fvwmconf Main.fvwmconf Subpanels.fvwm2.fvwmconf Subpanels.fvwm3.fvwmconf
CONFS = $(shell echo $(srcdir)/*.fvwmconf) NsCDE.conf FrontPanel.fvwm2 FrontPanel.fvwm3

fvwmdata_DATA = $(CONFS)

EXTRA_DATA =

clean-local:
	-rm -f $(DYNCONFS)

