bin_PROGRAMS = XOverrideFontCursor.so
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

