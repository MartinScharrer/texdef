INSTALLDIR=/usr/local/bin

FLAVOURS=tex latex pdftex pdflatex xetex xelatex luatex lualatex context
LINKS=$(addsuffix def,${FLAVOURS})

install: texdef.pl ${LINKS}
	install -t ${INSTALLDIR} $^

.PHONY: links

links:  ${LINKS}

${LINKS}:
	ln -s texdef.pl $@

release: zip

zip: texdef.zip

texdef.zip: texdef.pl README INSTALL texdef.pdf texdef.tex
	zip $@ $^

%.pdf: %.tex
	latexmk -pdf $<
