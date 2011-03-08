INSTALLDIR=/usr/local/bin

FLAVOURS=tex latex pdftex pdflatex xetex xelatex luatex lualatex context
LINKS=$(addsuffix def,${FLAVOURS})

install: texdef.pl ${LINKS}
	install -t ${INSTALLDIR} $^

.PHONY: links

links:  ${LINKS}

${LINKS}:
	ln -s texdef.pl $@


