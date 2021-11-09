#
# This file is a part of the NsCDE - Not so Common Desktop Environment
# Author: Hegel3DReloaded
# Licence: GPLv3
#

DOCBOOK2PDF = docbook2pdf
DOCBOOK2TXT = docbook2txt
XSLTPROC = xsltproc

docs: NsCDE.pdf NsCDE.txt docs-html

NsCDE.pdf:
	${DOCBOOK2PDF} NsCDE.xml

NsCDE.txt:
	${DOCBOOK2TXT} NsCDE.xml

docs-html:
	-@mkdir -p html
	-@cp NsCDE.css html/
	${XSLTPROC} -o html/ NsCDE.xsl NsCDE.xml

realclean:
	-rm -f NsCDE.pdf NsCDE.txt NsCDe.aux NsCDE.log NsCDE.out
	-rm -rf html

install-data-local:
	install -d -m 755 $(DESTDIR)$(docdir)/
	install -m 644 NsCDE.pdf $(DESTDIR)$(docdir)/
	install -m 644 NsCDE.txt $(DESTDIR)$(docdir)/
	install -d -m 755 $(DESTDIR)$(docdir)/html/
	@for hh in $(srcdir)/html/*; do \
                echo "Installing $$hh in $(DESTDIR)$(docdir)/html" ; \
		install -m 644 $$hh $(DESTDIR)$(docdir)/$$hh ; \
	done

uninstall-local:
	test -d $(DESTDIR)$(docdir) && (cd $(DESTDIR)$(docdir) && rm -rf html)
	test -d $(DESTDIR)$(docdir) && (cd $(DESTDIR)$(docdir) && rm -f NsCDE.pdf NsCDE.txt)
	test -d $(DESTDIR)$(docdir) && rmdir $(DESTDIR)$(docdir) || :
