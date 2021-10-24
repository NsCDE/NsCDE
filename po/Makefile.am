MSGFMT = msgfmt
POFILES = $(wildcard $(srcdir)/*.po)
MOFILES = $(foreach s,$(POFILES),$(shell echo $(s) | sed 's/\.po$$/\.mo/g'))

.po.mo:
	$(MSGFMT) -o $@ $<

all:	$(MOFILES)

clean-local:
	-rm -f $(MOFILES)
