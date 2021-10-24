
DOCBOOK2PDF = docbook2pdf
DOCBOOK2TXT = docbook2txt
XSLTPROC = xsltproc

all: NsCDE.pdf NsCDE.txt docs-html

NsCDE.pdf:
	${DOCBOOK2PDF} NsCDE.xml

NsCDE.txt:
	${DOCBOOK2TXT} NsCDE.xml

docs-html:
	-@mkdir -p html
	-@cp NsCDE.css html/
	${XSLTPROC} -o html/ NsCDE.xsl NsCDE.xml

clean-local:
	-rm -f NsCDE.pdf NsCDE.txt NsCDe.aux NsCDE.log NsCDE.out
	-rm -rf html
