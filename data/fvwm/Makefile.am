#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

fvwmdatadir = $(FVWM_DATADIR)

DYNCONFS = Functions.fvwmconf \
	Main.fvwmconf

CONFS = NsCDE.conf \
	Animate.fvwmconf \
	Backdrops.fvwmconf \
	Backer.fvwmconf \
	Colorset.fvwmconf \
	Event.fvwmconf \
	FinishInit.fvwmconf \
	Font-120dpi.fvwmconf \
	Font-144dpi.fvwmconf \
	Font-192dpi.fvwmconf \
	Font-75dpi.fvwmconf \
	Font-96dpi.fvwmconf \
	Form.fvwmconf \
	FrontPanel.fvwm2.fvwmconf \
	FrontPanel.fvwm3.fvwmconf \
	FrontPanel.fvwmconf \
	IconMan.fvwmconf \
	Ident.fvwmconf \
	Init.fvwmconf \
	Keybindings.fvwmconf \
	LocalPager.fvwmconf \
	Menus.fvwmconf \
	Monitors.fvwmconf \
	Mousebindings.fvwmconf \
	Sandbox.fvwmconf \
	Script.fvwmconf \
	Style.fvwmconf \
	Subpanels.fvwmconf \
	WspLocPager.fvwmconf

fvwmdata_DATA = $(CONFS) $(DYNCONFS)

EXTRA_DATA =

clean-local:
	-rm -f $(DYNCONFS)

uninstall-hook:
	rmdir $(fvwmdatadir) || true

