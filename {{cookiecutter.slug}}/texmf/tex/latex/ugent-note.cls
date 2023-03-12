% Class for notes that are similar in style to the UGent letter heading.
% Based on the LaTeX UGent Letter Template by DF Benoit.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ugent-note}
\LoadClass[a4paper]{article}

\RequirePackage{kvoptions}
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{calc}
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc} % suggested by helvet
\RequirePackage[scaled=.85]{helvet}
\RequirePackage{lastpage}
\renewcommand{\familydefault}{\sfdefault}

\SetupKeyvalOptions{family=ugn,prefix=ugn@}
\DeclareStringOption[.25]{rightcolwidth}
\ProcessKeyvalOptions*

% define colors
\definecolor{ugentblue}{RGB}{30,100,200}

% define page layout lengths
\setlength{\oddsidemargin}{0mm}
\setlength{\evensidemargin}{\oddsidemargin}
\setlength{\topmargin}{-10mm} %2.54cm + \topmargin
\setlength{\textheight}{210mm} %firstpage only
\setlength{\headheight}{10mm} %height of header
\setlength{\headsep}{15mm} %distance between header and text
\setlength{\textwidth}{\paperwidth-2in}
\setlength{\footskip}{30mm}
\setlength{\parskip}{1em}
\setlength{\parindent}{0.0em}
\newlength{\rightcol}
\setlength{\rightcol}{\ugn@rightcolwidth\textwidth}
\newlength{\leftcol}
\setlength{\leftcol}{\textwidth-\rightcol}

% Normal pages
\renewcommand{\ps@headings}{%
    \renewcommand{\@oddhead}{%
        \begin{minipage}[b][\headheight]{\textwidth}
            \begin{minipage}[c]{\leftcol}
                \hspace*{-1cm}
            \end{minipage}%
            \begin{minipage}[c]{\rightcol}
                \color{ugentblue}
                \scshape
                %\fromdept%
            \end{minipage}%
        \end{minipage}
    }%
    \renewcommand{\@oddfoot}{%
        \parbox[t][22.5mm]{\textwidth}{%
            \hspace*{-1cm}\includegraphics[height=40mm]{ugent-en}
            \hfill\thepage/\pageref*{LastPage}
        }%
    }%
    \renewcommand{\@evenhead}{\@oddhead}
    \renewcommand{\@evenfoot}{\@oddfoot}
}

% set standard layout
\pagestyle{headings}
