#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

DEFAULT_XPM = Fpclock.xpm

Default.xpm:
	ln -s ../XPM/$(DEFAULT_XPM) $@

machdepdir = $(NSCDE_TOOLSDIR)/$(OS_PLUS_MACHINE_ARCH)

machdep_PROGRAMS = fpclock
BUILT_SOURCES = Default.xpm
fpclock_SOURCES = Defaults.h getopt1.c getopt.c  \
	getopt.h Graphics.c Main.c PClock.h Version.h Default.xpm

AM_CFLAGS = $(CFLAGS)

LDADD = $(X_LIB) $(XEXT_LIB) $(XPM_LIB) $(MATH_LIB)

clean-local:
	-rm -f Default.xpm

uninstall-hook:
	rmdir $(machdepdir) || true
