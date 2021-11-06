#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

SUBDIRS = FvwmScripts

toolsdir = $(NSCDE_TOOLSDIR)

SCRIPTINS = \
	acpimgr \
	appfinder \
	backdropmgr \
	bootstrap \
	colorconv \
	colormgr \
	colorpicker \
	confget \
	confset \
	fontmgr \
	fp_manage_subpanel \
	fpclock \
	fpexec \
	fpseticon \
	generate_app_menus \
	generate_subpanels \
	get_logical_screens \
	getdpi \
	getfont \
	geticon \
	getla1 \
	ised \
	keymenu \
	mkpagemenu \
	migrate_nscde2x \
	palette_colorgen \
	strip_icon_path \
	subpanel_menuitem_props \
	sysinfo \
	themegen \
	usleep \
	var_append \
	xdowrapper \
	xrandr_backer

tools_SCRIPTS = $(SCRIPTINS) style_managers.shlib

EXTRA_SCRIPTS =

clean-local:
	-rm -f $(SCRIPTINS)

install-data-hook:
	NSCDE_DATADIR=$(DESTDIR)$(NSCDE_DATADIR) HAS_WINDOWNAME=0 SYSMODE=1 $(KSH) $(srcdir)/generate_subpanels > $(DESTDIR)$(FVWM_DATADIR)/Subpanels.fvwm2.fvwmconf
	NSCDE_DATADIR=$(DESTDIR)$(NSCDE_DATADIR) HAS_WINDOWNAME=1 SYSMODE=1 $(KSH) $(srcdir)/generate_subpanels > $(DESTDIR)$(FVWM_DATADIR)/Subpanels.fvwm3.fvwmconf

uninstall-hook:
	rmdir $(DESTDIR)$(NSCDE_TOOLSDIR)/$(OS_PLUS_MACHINE_ARCH) || :
	rmdir $(DESTDIR)$(NSCDE_TOOLSDIR) || :

