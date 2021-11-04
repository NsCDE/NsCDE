#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

machdepdir = $(NSCDE_TOOLSDIR)/$(OS_PLUS_MACHINE_ARCH)
machdep_PROGRAMS = colorpicker
colorpicker_SOURCE = colorpicker.c

LDADD = $(X_LIB)

uninstall-hook:
	rmdir $(machdepdir) || true

