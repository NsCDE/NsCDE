#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

OS_PLUS_MACHINE_ARCH = $(shell uname -sm | tr ' ' '_')
machlibdepdir = $(NSCDE_LIBDIR)/$(OS_PLUS_MACHINE_ARCH)

machlibdep_PROGRAMS = XOverrideFontCursor.so
XOverrideFontCursor.so_SOURCE = XOverrideFontCursor.c

AM_CPPFLAGS = \
	-I/usr/include/X11 -I/usr/local/include/X11 -I/usr/local/include \
	-I/usr/X11R6/include -I/usr/X11R7/include -I/usr/X11R6/include/X11 \
	-I/usr/X11R7/include/X11 \
	-fPIC

AM_CFLAGS = \
	$(CFLAGS)

AM_LDFLAGS = \
	-fPIC -shared \
	$(LDFLAGS)

LDADD = -L/usr/X11R6/lib -L/usr/X11R7/lib -L/usr/local/lib $(X_LIB)

