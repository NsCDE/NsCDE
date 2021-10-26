#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

MSGFMT = msgfmt
POFILES = $(wildcard $(srcdir)/*.po)
MOFILES = $(foreach s,$(POFILES),$(shell echo $(s) | $(SED) 's/\.po$$/\.mo/g'))

.po.mo:
	$(MSGFMT) -o $@ $<

all:	$(MOFILES)

# Ugly ... I know.
INSTDIRS = $(foreach l,$(LOCALES),$(mkinstalldirs) $(DESTDIR)$(localedir)/$(l)/LC_MESSAGES/;)
INSTFILES = $(foreach f,$(MOFILES),\
	install -m 644 $(f) \
	$(DESTDIR)$(localedir)/$(shell \
	echo $(f) | $(SED) 's/\(.*\)\.\(..\)\.\(mo$$\)/\2/g')/LC_MESSAGES/$(shell \
	echo $(f) | $(SED) 's/\(\.\/\)\(.*\)\.\(..\)\.\(mo$$\)/\2.\4/g');)

DELFILES = $(foreach f,$(MOFILES),\
	rm $(DESTDIR)$(localedir)/$(shell \
	echo $(f) | $(SED) 's/\(.*\)\.\(..\)\.\(mo$$\)/\2/g')/LC_MESSAGES/$(shell \
	echo $(f) | $(SED) 's/\(\.\/\)\(.*\)\.\(..\)\.\(mo$$\)/\2.\4/g');)

install-data-am:
	$(INSTDIRS)
	$(INSTFILES)

clean-local:
	-rm -f $(MOFILES)

uninstall-am:
	$(DELFILES)
