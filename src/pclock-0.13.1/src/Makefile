BINDIR = /usr/X11R6/bin

PROG = pclock
OBJS = Main.o Graphics.o getopt.o getopt1.o

DEFAULT_XPM = Fpclock.xpm

INCDIR = -I/usr/X11R6/include -I/usr/X11R7/include -I/usr/include -I/usr/local/include -I.
LIBDIR = -L/usr/X11R6/lib -L/usr/X11R7/lib -L/usr/lib64 -L/usr/local/lib
CC ?= gcc
CFLAGS ?= -O2 -g -Wall
LDFLAGS ?=
LIBS = -lXpm -lXext -lX11 -lm

###############################################################################

all: $(PROG)

install: all
	install -s -m 111 -o bin -g bin $(PROG) $(BINDIR)

clean:
	rm -f *.o Makefile.bak Default.xpm *~ #*

clobber: clean
	rm -f $(PROG)

###############################################################################

Default.xpm:
	ln -s ../XPM/$(DEFAULT_XPM) $@

Graphics.o: PClock.h Default.xpm

Main.o: PClock.h Defaults.h Version.h

$(PROG): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LIBDIR) $(LDFLAGS) $(LIBS)

###############################################################################

.c.o:
	$(CC) $(CFLAGS) $(INCDIR) -c $< -o $@

