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
	sh -n bin/nscde-wayland-run
	sh -n bin/nscde-output-scale
	sh -n bin/nscde-wayland-screenshot
	sh -n bin/nscde-wayland-doctor
	sh -n labwc/autostart
	fuzzel --check-config --config=fuzzel/fuzzel.ini
	foot --check-config --config=foot/foot.ini
	test -s sfwbar/sfwbar.config
	xmllint --noout labwc/rc.xml labwc/menu.xml

install:
	$(INSTALL) -d "$(DESTDIR)$(BINDIR)"
	$(INSTALL) -m 0755 bin/nscde-labwc "$(DESTDIR)$(BINDIR)/nscde-labwc"
	$(INSTALL) -m 0755 bin/nscde-wayland-run "$(DESTDIR)$(BINDIR)/nscde-wayland-run"
	$(INSTALL) -m 0755 bin/nscde-output-scale "$(DESTDIR)$(BINDIR)/nscde-output-scale"
	$(INSTALL) -m 0755 bin/nscde-wayland-screenshot "$(DESTDIR)$(BINDIR)/nscde-wayland-screenshot"
	$(INSTALL) -m 0755 bin/nscde-wayland-doctor "$(DESTDIR)$(BINDIR)/nscde-wayland-doctor"
	$(INSTALL) -d "$(DESTDIR)$(SESSIONDIR)"
	$(INSTALL) -m 0644 session/nscde-labwc.desktop "$(DESTDIR)$(SESSIONDIR)/nscde-labwc.desktop"
	$(INSTALL) -d "$(DESTDIR)$(PROJECTDATADIR)"
	cp -R labwc themes assets sfwbar fuzzel foot fnott "$(DESTDIR)$(PROJECTDATADIR)/"
	$(INSTALL) -d "$(DESTDIR)$(DATADIR)/themes" "$(DESTDIR)$(DATADIR)/icons"
	cp -R themes/NsCDE-Wayland "$(DESTDIR)$(DATADIR)/themes/"
	cp -R assets/xdg/icons/NsCDE "$(DESTDIR)$(DATADIR)/icons/"

uninstall:
	rm -f "$(DESTDIR)$(BINDIR)/nscde-labwc"
	rm -f "$(DESTDIR)$(BINDIR)/nscde-wayland-run"
	rm -f "$(DESTDIR)$(BINDIR)/nscde-output-scale"
	rm -f "$(DESTDIR)$(BINDIR)/nscde-wayland-screenshot"
	rm -f "$(DESTDIR)$(BINDIR)/nscde-wayland-doctor"
	rm -f "$(DESTDIR)$(SESSIONDIR)/nscde-labwc.desktop"
	rm -rf "$(DESTDIR)$(PROJECTDATADIR)"
	rm -rf "$(DESTDIR)$(DATADIR)/themes/NsCDE-Wayland"
	rm -rf "$(DESTDIR)$(DATADIR)/icons/NsCDE"
