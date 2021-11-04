#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

machlibdepdir = $(NSCDE_LIBDIR)/$(OS_PLUS_MACHINE_ARCH)

machlibdep_PROGRAMS = XOverrideFontCursor.so
XOverrideFontCursor.so_SOURCE = XOverrideFontCursor.c

AM_CPPFLAGS = -fPIC $(CPPFLAGS)
AM_CFLAGS = $(CFLAGS)
AM_LDFLAGS = -fPIC -shared $(LDFLAGS)

LDADD = $(X_LIB)

uninstall-hook:
	rmdir $(machlibdepdir) || true

