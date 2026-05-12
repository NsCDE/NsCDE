PREFIX ?= /usr/local
DESTDIR ?=

BINDIR ?= $(PREFIX)/bin
DATADIR ?= $(PREFIX)/share
SESSIONDIR ?= $(DATADIR)/wayland-sessions
PROJECT := nscde-wayland
PROJECTDATADIR := $(DATADIR)/$(PROJECT)
INSTALL ?= install

.PHONY: all install uninstall check

all:

check:
	sh -n bin/nscde-labwc
	sh -n labwc/autostart
	test -s sfwbar/sfwbar.config
	xmllint --noout labwc/rc.xml labwc/menu.xml

install:
	$(INSTALL) -d "$(DESTDIR)$(BINDIR)"
	$(INSTALL) -m 0755 bin/nscde-labwc "$(DESTDIR)$(BINDIR)/nscde-labwc"
	$(INSTALL) -d "$(DESTDIR)$(SESSIONDIR)"
	$(INSTALL) -m 0644 session/nscde-labwc.desktop "$(DESTDIR)$(SESSIONDIR)/nscde-labwc.desktop"
	$(INSTALL) -d "$(DESTDIR)$(PROJECTDATADIR)"
	cp -R labwc themes assets sfwbar "$(DESTDIR)$(PROJECTDATADIR)/"

uninstall:
	rm -f "$(DESTDIR)$(BINDIR)/nscde-labwc"
	rm -f "$(DESTDIR)$(SESSIONDIR)/nscde-labwc.desktop"
	rm -rf "$(DESTDIR)$(PROJECTDATADIR)"
