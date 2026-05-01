#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

MSGFMT = msgfmt

.po.mo:
	$(MSGFMT) -o $@ $<

MOFILES = NsCDE-BackdropMgr.hr.mo \
	NsCDE-BackdropMgr.zh.mo \
	NsCDE-BeepMgr.hr.mo \
	NsCDE-BeepMgr.zh.mo \
	NsCDE-ColorMgr.hr.mo \
	NsCDE-ColorMgr.zh.mo \
	NsCDE-DefaultAppsMgr.hr.mo \
	NsCDE-DefaultAppsMgr.zh.mo \
	NsCDE-ExecDialog.hr.mo \
	NsCDE-ExecDialog.zh.mo \
	NsCDE-FilePicker.hr.mo \
	NsCDE-FilePicker.zh.mo \
	NsCDE-FontMgr.hr.mo \
	NsCDE-FontMgr.zh.mo \
	NsCDE-GWM.hr.mo \
	NsCDE-GWM.zh.mo \
	NsCDE-GeometryMgr.hr.mo \
	NsCDE-GeometryMgr.zh.mo \
	NsCDE-KeyboardMgr.hr.mo \
	NsCDE-KeyboardMgr.zh.mo \
	nscde-migrate-1x_to_2x.hr.mo \
	nscde-migrate-1x_to_2x.zh.mo \
	NsCDE-NProcMgr.hr.mo \
	NsCDE-NProcMgr.zh.mo \
	NsCDE-Occupy.hr.mo \
	NsCDE-Occupy.zh.mo \
	NsCDE-PointerMgr.hr.mo \
	NsCDE-PointerMgr.zh.mo \
	NsCDE-PowerSaveMgr.hr.mo \
	NsCDE-PowerSaveMgr.zh.mo \
	NsCDE-StyleMgr.hr.mo \
	NsCDE-StyleMgr.zh.mo \
	NsCDE-Subpanel.hr.mo \
	NsCDE-Subpanel.zh.mo \
	NsCDE-Subpanels.hr.mo \
	NsCDE-Subpanels.zh.mo \
	NsCDE-SysActionDialog.hr.mo \
	NsCDE-SysActionDialog.zh.mo \
	NsCDE-Sysinfo.hr.mo \
	NsCDE-Sysinfo.zh.mo \
	NsCDE-WSM.hr.mo \
	NsCDE-WSM.zh.mo \
	NsCDE-WindowMgr.hr.mo \
	NsCDE-WindowMgr.zh.mo \
	NsCDE-WsPgMgr.hr.mo \
	NsCDE-WsPgMgr.zh.mo \
	NsCDE-FpIconMgr.hr.mo \
	NsCDE-FpIconMgr.zh.mo \
	NsCDE.hr.mo \
	NsCDE.zh.mo \
	nscde-bootstrap.hr.mo \
	nscde-bootstrap.zh.mo

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

