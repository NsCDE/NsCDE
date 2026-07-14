#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

MSGFMT = msgfmt

.po.mo:
	$(MSGFMT) -o $@ $<

MOFILES = NsCDE-BackdropMgr.hr.mo \
	NsCDE-BackdropMgr.zh_CN.mo \
	NsCDE-BeepMgr.hr.mo \
	NsCDE-BeepMgr.zh_CN.mo \
	NsCDE-ColorMgr.hr.mo \
	NsCDE-ColorMgr.zh_CN.mo \
	NsCDE-ExecDialog.hr.mo \
	NsCDE-ExecDialog.zh_CN.mo \
	NsCDE-FilePicker.hr.mo \
	NsCDE-FilePicker.zh_CN.mo \
	NsCDE-FontMgr.hr.mo \
	NsCDE-FontMgr.zh_CN.mo \
	NsCDE-GWM.hr.mo \
	NsCDE-GWM.zh_CN.mo \
	NsCDE-GeometryMgr.hr.mo \
	NsCDE-GeometryMgr.zh_CN.mo \
	NsCDE-KeyboardMgr.hr.mo \
	NsCDE-KeyboardMgr.zh_CN.mo \
	nscde-migrate-1x_to_2x.hr.mo \
	nscde-migrate-1x_to_2x.zh_CN.mo \
	NsCDE-NProcMgr.hr.mo \
	NsCDE-NProcMgr.zh_CN.mo \
	NsCDE-Occupy.hr.mo \
	NsCDE-Occupy.zh_CN.mo \
	NsCDE-PointerMgr.hr.mo \
	NsCDE-PointerMgr.zh_CN.mo \
	NsCDE-PowerSaveMgr.hr.mo \
	NsCDE-PowerSaveMgr.zh_CN.mo \
	NsCDE-StyleMgr.hr.mo \
	NsCDE-StyleMgr.zh_CN.mo \
	NsCDE-Subpanel.hr.mo \
	NsCDE-Subpanel.zh_CN.mo \
	NsCDE-Subpanels.hr.mo \
	NsCDE-Subpanels.zh_CN.mo \
	NsCDE-SysActionDialog.hr.mo \
	NsCDE-SysActionDialog.zh_CN.mo \
	NsCDE-Sysinfo.hr.mo \
	NsCDE-Sysinfo.zh_CN.mo \
	NsCDE-WSM.hr.mo \
	NsCDE-WSM.zh_CN.mo \
	NsCDE-WindowMgr.hr.mo \
	NsCDE-WindowMgr.zh_CN.mo \
	NsCDE-WsPgMgr.hr.mo \
	NsCDE-WsPgMgr.zh_CN.mo \
	NsCDE-FpIconMgr.hr.mo \
	NsCDE-FpIconMgr.zh_CN.mo \
	NsCDE.hr.mo \
	NsCDE.zh_CN.mo \
	nscde-bootstrap.hr.mo \
	nscde-bootstrap.zh_CN.mo

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

