texdef -- Show definitions of TeX commands
Version 1.10 -- 2025/02/17
Copyright (c) 2011-2025  Martin Scharrer <martin.scharrer@web.de>
This program comes with ABSOLUTELY NO WARRANTY;
This is free software, and you are welcome to redistribute it under certain conditions;

Usage:
  texdef   [options] commandname [commandname ...]
  latexdef [options] commandname [commandname ...]

Other program names are possible. See the 'tex' option.  Command names do not need to start with `\`.

Options:
  --tex <format>, -t <format>   : Use given format of TeX: 'tex', 'latex', 'context'.
                                  Variations of 'tex' and 'latex', like 'luatex', 'lualatex', 'xetex', 'xelatex' are supported.
                                  The postfix '-dev' for develop versions of the format is also supported (e.g. 'latex-dev').
                                  The default is given by the used program name: 'texdef' -> 'tex', 'latexdef' -> 'latex', etc.
  --texoptions <options>        : Call (La)TeX with the given options.
  --source, -s                  : Try to show the original source code of the command definition (L).
  --value, -v                   : Show value of command instead (i.e. \the\command).
  --Environment, -E             : Every command name is taken as an environment name. This will show the definition of
                                  both \Macro\foo and \Macro\endfoo if \texttt{foo} is used as command name (L).
  --preamble, -P                : Show definition of the command inside the preamble.
  --beforeclass, -B             : Show definition of the command before \documentclass.
  --package <pkg>, -p <pkg>     : (M) Load given tex-file, package or module depending on whether '*tex', '*latex'
                                  or 'context' is used. For LaTeX the <pkg> can start with `[<options>]` and end 
                                  with `<pkgname>` or `{<pkgname>}`.
  --class <class>, -c <class>   : (LaTeX only) Load given class instead of default ('article').
                                  The <class> can start with `[<class options>]` and end 
                                  with `<classname>` or `{<classname>}`.
  --environment <env>, -e <env> : (M) Show definition inside the given environment <env>.
  --othercode <code>, -o <code> : (M) Add other code into the preamble before the definition is shown.
                                  This can be used to e.g. load PGF/TikZ libraries.
  --before <code>, -b <code>    : (M) Place <code> before definition is shown.
                                  The <code> can be arbitray TeX code and doesn't need be be balanced.
  --after  <code>, -a <code>    : (M) Place <code> after definition is shown.
                                  The <code> can be arbitray TeX code and doesn't need be be balanced.
  --find, -f                    : Find file where the command sequence was defined (L).
  --Find, -F                    : Show full filepath of the file where the command sequence was defined (L).
  --list, -l                    : List user level command sequences of the given packages (L).
  --list-defs, -L               : List user level command sequences and their shorten definitions of the given packages (L).
  --list-all, -ll               : List all command sequences of the given packages (L).
  --list-defs-all, -LL          : List all command sequences and their shorten definitions of the given packages (L).
  --ignore-cmds <cs,cs,..>,  -i : Ignore the following command sequence(s) in the above lists. (M)
  --ignore-regex <regex,..>, -I : Ignore all command sequences in the above lists which match the given Perl regular expression(s). (M)
  --pgf-keys, -k                : Takes commands as pgfkeys and displays their definitions. Keys must use the full path but the common '.\@cmd' prefix is applied.
  --pgf-Keys, -K                : Takes commands as pgfkeys and displays their definitions. Keys must use the full path.
  --version, -V                 : If used alone prints version of this script.
                                  (L) Together with -p or -c prints version of LaTeX package(s) or class, respectively.
  --edit                        : Opens the file holding the macro definition. Uses --Find and --source. (L)
                                  If the source definition can not be found the definition is printed as normal instead.
  --editor <editor>             : Can be used to set the used editor. If not used the environment variables TEXDEF_EDITOR, EDITOR and
                                  SELECTED_EDITOR are read in this order. If none of these are set a list of default
                                  editors are tried.  The <editor> string can include '%f' for the filename, '%n' for
                                  the line number and '%%' for a literal '%'.  If no '%' is used '+%n %f' is added to
                                  the given command.
  --tempdir <directory>         : Use given existing directory for temporary files.
  --help, -h                    : Print this help and quit.

 Long option can be shorten as long the are still unique.  Short options can be combined.
 If the option 'environment', 'before' and 'after' are used toegether the
 produced code will be inserted in the given order (reversed order for 'after').
 (M) = This option can be given multiple times.
 (L) = LaTeX only. Requires the packages 'filehook' and 'currfile'.

Examples:
Show the definition of '\chapter' with different classes ('article' (default), 'book' and 'scrbook'):

    latexdef chapter
    latexdef -c book chapter
    latexdef -c scrbook chapter

Show value of `\textwidth` with different class options:

    latexdef -c [a4paper]{book} -v paperwidth
    latexdef -c [letter]{book}  -v paperwidth

Show definition of TikZ's '\draw' outside and inside a 'tikzpicture' environment:

    latexdef -p tikz draw
    latexdef -p tikz --env tikzpicture draw

Show definition of TikZ's '\draw' inside a node, inside a 'beamer' frame in 'handout' mode:

    latexdef -c [handout]beamer -p tikz --env frame --env tikzpicture -b '\node {' -a '};' draw

List all user level command sequences (macros) defined by the 'xspace' LaTeX package:

    latexdef -l -p xspace

