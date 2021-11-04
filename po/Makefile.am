#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

MSGFMT = msgfmt

.po.mo:
	$(MSGFMT) -o $@ $<

MOFILES = NsCDE-BackdropMgr.hr.mo \
	NsCDE-BeepMgr.hr.mo \
	NsCDE-ColorMgr.hr.mo \
	NsCDE-ExecDialog.hr.mo \
	NsCDE-FilePicker.hr.mo \
	NsCDE-FontMgr.hr.mo \
	NsCDE-GWM.hr.mo \
	NsCDE-GeometryMgr.hr.mo \
	NsCDE-KeyboardMgr.hr.mo \
	NsCDE-NProcMgr.hr.mo \
	NsCDE-Occupy.hr.mo \
	NsCDE-PointerMgr.hr.mo \
	NsCDE-PowerSaveMgr.hr.mo \
	NsCDE-StyleMgr.hr.mo \
	NsCDE-Subpanel.hr.mo \
	NsCDE-Subpanels.hr.mo \
	NsCDE-SysActionDialog.hr.mo \
	NsCDE-Sysinfo.hr.mo \
	NsCDE-WSM.hr.mo \
	NsCDE-WindowMgr.hr.mo \
	NsCDE-WsPgMgr.hr.mo \
	NsCDE.hr.mo \
	nscde-bootstrap.hr.mo

all: $(MOFILES)

install-data-am:
	for l in $(LOCALES); \
	do \
	   $(mkinstalldirs) $(DESTDIR)$(localedir)/$$l/LC_MESSAGES/ ; \
	   for f in $(MOFILES); \
	   do \
	      if `echo $$f | egrep -q ".*\.$$l\.mo"` ; then \
	         install -m 644 $$f $(DESTDIR)$(localedir)/$$l/LC_MESSAGES/`echo $$f | $(SED) "s/\.$$l\.mo/.mo/g"` ; \
	      fi \
	   done ; \
	done

clean-local:
	-rm -f $(MOFILES)

uninstall-am:
	for l in $(LOCALES); \
	do \
	   for f in $(MOFILES); \
	   do \
	      if `echo $$f | egrep -q ".*\.$$l\.mo"` ; then \
	         rm -f $(DESTDIR)$(localedir)/$$l/LC_MESSAGES/`echo $$f | $(SED) "s/\.$$l\.mo/.mo/g"` ; \
	      fi \
	   done ; \
	done
	for l in $(LOCALES); \
	do \
	   rmdir $(DESTDIR)$(localedir)/$$l/LC_MESSAGES || true ; \
	   rmdir $(DESTDIR)$(localedir)/$$l || true ; \
	done
	rmdir $(DESTDIR)$(localedir) || true

