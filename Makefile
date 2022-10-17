CONTRIBUTION  = texdef
NAME          = Martin Scharrer
EMAIL         = martin.scharrer@web.de
DIRECTORY     = /support/${CONTRIBUTION}
LICENSE       = free
FREEVERSION   = gpl
CTAN_FILE     = ${CONTRIBUTION}.zip
export CONTRIBUTION VERSION NAME EMAIL SUMMARY DIRECTORY DONOTANNOUNCE ANNOUNCE NOTES LICENSE FREEVERSION CTAN_FILE CTAN_SERVER

README        = README.txt
SCRIPTFILES   = ${CONTRIBUTION}.pl
SCRDOCFILES   = ${CONTRIBUTION}.pdf ${README} INSTALL.txt CHANGELOG.txt
SCRSRCFILES   = ${CONTRIBUTION}.tex
CTANFILES     = ${SCRIPTFILES} ${SCRDOCFILES} ${SCRSRCFILES} DEPENDS.txt

TDSZIP      = ${CONTRIBUTION}.tds.zip

TEXMF       = ${HOME}/texmf
SCRIPTDIR   = ${TEXMF}/scripts/${CONTRIBUTION}/
SCRDOCDIR   = ${TEXMF}/doc/support/${CONTRIBUTION}/
SCRSRCDIR   = ${TEXMF}/source/support/${CONTRIBUTION}/

TDSDIR   = tds
TDSFILES = ${SCRIPTFILES} ${SCRDOCFILES}

BUILDDIR = .

LATEXMK  = latexmk -pdf -quiet
ZIP      = zip -r
CP = cp
MKDIR = mkdir
RMDIR = rm -rf 
WEBBROWSER = firefox
GETVERSION = $(strip $(shell grep 'my \$$VERSION' texdef.pl | sed 's/my \$$VERSION = '\''Version \(.*\) -- .*'\'';/v\1/') )

AUXEXTS  = .aux .bbl .blg .cod .exa .fdb_latexmk .glo .gls .lof .log .lot .out .pdf .que .run.xml .sta .stp .svn .svt .toc
CLEANFILES = $(addprefix ${CONTRIBUTION}, ${AUXEXTS})

.PHONY: all doc clean distclean build

all: doc

doc: ${SCRDOCFILES}

build: doc

%.pdf: %.tex
	latexmk -pdf $<
	touch $@

${README}: texdef.pl
	./texdef.pl --help > ${README}

clean:
	latexmk -C ${SCRSRCFILES}
	${RM} ${CLEANFILES}
	${RM} -r ${TDSDIR} ${TDSZIP} ${CTAN_FILE}


distclean:
	latexmk -C ${SCRSRCFILES}
	${RM} ${CLEANFILES}
	${RM} -r ${TDSDIR}

CPORLN=cp

installtds: ${TDSFILES}
ifneq ($(strip $(SCRIPTFILES)),)
	test -d "${SCRIPTDIR}" || mkdir -p "${SCRIPTDIR}"
	${CPORLN} ${SCRIPTFILES} "$(abspath ${SCRIPTDIR})"
endif
ifneq ($(strip $(SCRDOCFILES)),)
	test -d "${SCRDOCDIR}" || mkdir -p "${SCRDOCDIR}"
	${CPORLN} ${SCRDOCFILES} "$(abspath ${SCRDOCDIR})"
endif
ifneq ($(strip $(SCRSRCFILES)),)
	test -d "${SCRSRCDIR}" || mkdir -p "${SCRSRCDIR}"
	${CPORLN} ${SCRSRCFILES} "$(abspath ${SCRSRCDIR})"
endif
	touch ${TEXMF}
	-test -f ${TEXMF}/ls-R && texhash ${TEXMF} || true


ifeq ($(shell id -u),0) 
INSTALLDIR=/usr/local/bin
else 
INSTALLDIR=${HOME}/bin
endif
FLAVOURS=tex latex pdftex pdflatex xetex xelatex luatex lualatex context
LINKS=$(addsuffix def,${FLAVOURS})

install: texdef.pl ${LINKS}
	install -t ${INSTALLDIR} $^

uninstall: 
	cd ${INSTALLDIR} && ${RM} texdef.pl ${LINKS}

.PHONY: links
links:  ${LINKS}

${LINKS}:
	ln -s texdef.pl $@


installsymlinks: CPORLN=ln -sf
installsymlinks: install

uninstalltds:
	${RM} -rf ${SCRIPTDIR} ${SCRDOCDIR}
	-test -f ${TEXMF}/ls-R && texhash ${TEXMF} || true

ifneq (${TDSDIR},tdsdir)
tdsdir: ${TDSDIR}
endif
${TDSDIR}: ${TDSFILES}
	${MAKE} --no-print-directory installtds TEXMF=${TDSDIR}

tdszip: ${TDSZIP}

${TDSZIP}: ${TDSDIR}
	-${RM} $@
	cd ${TDSDIR} && ${ZIP} $(abspath $@) *

zip: ${CTAN_FILE}

${CTAN_FILE}: ${CTANFILES} ${TDSZIP}
	-${RM} $@
	-${RMDIR} ${CONTRIBUTION}/
	${MKDIR} ${CONTRIBUTION}/
	${CP} ${CTANFILES} ${CONTRIBUTION}/
	${ZIP} $@ ${TDSZIP} ${CONTRIBUTION}/
	-${RMDIR} ${CONTRIBUTION}/

upload: VERSION = ${GETVERSION}

upload: ${CTAN_FILE}
	ctanupload -p

webupload: VERSION = ${GETVERSION}
webupload: ${CTAN_FILE}
	${WEBBROWSER} 'http://dante.ctan.org/upload.html?contribution=${CONTRIBUTION}&version=${VERSION}&name=${NAME}&email=${EMAIL}&summary=${SUMMARY}&directory=${DIRECTORY}&DoNotAnnounce=${DONOTANNOUNCE}&announce=${ANNOUNCEMENT}&notes=${NOTES}&license=${LICENSE}&freeversion=${FREEVERSION}' &


