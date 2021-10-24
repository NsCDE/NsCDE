DEFAULT_XPM = Fpclock.xpm

Default.xpm:
	ln -s ../XPM/$(DEFAULT_XPM) $@

bin_PROGRAMS = fpclock
BUILT_SOURCES = Default.xpm
fpclock_SOURCES = Defaults.h getopt1.c getopt.c  \
	getopt.h Graphics.c Main.c PClock.h Version.h Default.xpm

AM_CPPFLAGS = \
	-I/usr/X11R6/include -I/usr/X11R7/include -I/usr/include \
	-I/usr/local/include -I.

AM_CFLAGS = \
	-O2 -g \
	$(CFLAGS)

AM_LDFLAGS = \
	-L/usr/X11R6/lib -L/usr/X11R7/lib \
	-L/usr/lib64 -L/usr/local/lib
	$(LDFLAGS)

LDADD = $(X_LIB) $(XEXT_LIB) $(XPM_LIB) $(MATH_LIB)

clean-local:
	-rm -f Default.xpm

