\NeedsTeXFormat{LaTeX2e} 
\ProvidesClass{cv}[2018/11/01 v0.2 Curriculum Vitae]

\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=CV,prefix=CV@}

% The option headingcolor sets the color of the headings.
% Accepts any xcolor "dvips" name (search the wiki :))
\DeclareStringOption[Black]{headingcolor}

% The option selection allows you to specify a label to be printed in the footer
% so you can identify later which version you gave to whom
% (I usually specify `education', `academia', `industry' or a specific company)
\DeclareStringOption[all]{selection}

% The option scale allows you to scale many inter-line spaces in the document.
% Larger than 1 enlarges the document, smaller than 1 shrinks it (and is not recommended)
\DeclareStringOption[1]{scale}

% The option headingbars prints bars before the headings, as wide as the date column,
% in the heading color.
\DeclareBoolOption{headingbars}

% The below command passes all unknown options (not processed above) to the article class
\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{article}}

\ProcessKeyvalOptions*
\LoadClass{article}

\RequirePackage{xifthen}
\RequirePackage{xparse}
\RequirePackage{etoolbox}
\RequirePackage{geometry}
\RequirePackage{graphicx}
\RequirePackage{multicol}
\RequirePackage{wrapfig}
\RequirePackage[dvipsnames]{xcolor}
\definecolor{gray}{gray}{0.2}

\RequirePackage{tikz} %usenames to prevent conflict with xcolor
\RequirePackage{hyperref}
\hypersetup{hidelinks,pdftitle=Curriculum vitae,pdfauthor=\@author}

\RequirePackage{hanging}

% FontAwesome has a bug when using xelatex unless you use fontspec and tell it to use the otf file.
% But fontspec cancels your build if you use pdflatex. (Why doesn't it just disable itself? :( )

\RequirePackage{ifxetex}
\ifxetex\RequirePackage{fontspec}\defaultfontfeatures{Extension = .otf}\fi
\RequirePackage{fontawesome} %for the icons

\RequirePackage{calc}% For photo positioning

\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\pagestyle{fancyplain}
\newcommand\CV@foottext{\today{}\ifthenelse{\equal{all}{\CV@selection}}{}{ \textbullet{} selection: \CV@selection}}
\lhead{}\chead{}\rhead{}
\lfoot{}\cfoot{\thepage~/~\pageref*{LastPage}}\rfoot{\tiny\CV@foottext}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}

\setlength\parskip{1em}
\setlength\parindent{0pt}
\setcounter{secnumdepth}{-1} 

%\microtypesetup{tracking=true,kerning=true,spacing=true}
\RequirePackage{titlesec}

\ifCV@headingbars
\titleformat{\subsection}[block]{\bf\Large\color{\CV@headingcolor}\rm}{\thesubsection}{0em}{\raisebox{0.13cm}{\colorbox{\CV@headingcolor}{\hspace{0.75\CV@indent}}\hspace{0.4cm}}}
\else
\titleformat{\subsection}[block]{\bf\Large\color{\CV@headingcolor}\rm}{\thesubsection}{0em}{}
\fi
\titlespacing*{\subsection}{0em}{0.5em plus 0.5em minus 0.2em}{-3ex}
\titleformat{\section}[block]{\filcenter\addtolength{\titlewidth}{2pc}\bf\LARGE\color{\CV@headingcolor}\rm}{\thesection}{0em}{}
\titlespacing*{\section}{0em}{1em}{2em}
\renewcommand*\familydefault{\sfdefault}

% Set up the tables
\newlength\CV@rule
\setlength\CV@rule{1.5pt}
\newlength\CV@@rule
\setlength\CV@@rule{\CV@scale\CV@rule}
\newcommand\CV@Toprule{\CV@rememberspace{\CV@@rule}}
\newcommand\CV@Doublerule{\CV@rememberspace{2\CV@@rule}}
\newcommand\CV@Quadrule{\CV@rememberspace{4\CV@@rule}}
\newlength{\CV@spacememory}
\newcommand\CV@rememberspace[1]{\global\CV@spacememory=#1\relax}
\newcommand\CV@insertsavedspace{\\[\CV@spacememory]\CV@rememberspace{0pt}}

% The activity command takes five parameters, detailed below.
% \activity*{2012}*{Coffee Drinker}[Acme]
% 1. Star. If present, the row is condensed (less high)
% 2. Date or timespan.
% 3. Star. If present, the job title is not bolded.
% 4. Job or activity title.
% 5. Employer or venue (optional).
\NewDocumentCommand \activity { s m s m o }{%
  \CV@insertsavedspace%
  {\small #2}\>% the date
  \IfBooleanTF{#3}{#4}{\textbf{#4}}% the title, bold or not
  \IfValueT{#5}{, \textsl{#5}}%
  \IfBooleanTF{#1}{\CV@Toprule}{\CV@Doublerule}% the space after
}
% The publication command takes six parameters, detailed below.
% \publication{2012}{Mary Doe}{Prevalence of sheep near power lines}{Acme Journal}[45][12--34]
% 1. Date (usually year)
% 2. Author(s)
% 3. Title
% 4. Venue
% 5. Journal issue (optional)
% 6. Journal pages (mandatory if 5 is given)
\NewDocumentCommand \publication { m m m m o o }{%
  \CV@insertsavedspace%
  \begin{minipage}{\linewidth}\hangpara{0.2\linewidth}{1}%
    {#2}. \textit{#3}. \small{#4} \IfValueT{#5}{{vol.~#5}, {pp.~#6} }(#1).
  \end{minipage}\CV@Quadrule
}

\newcommand{\explanation}[1]{\CV@insertsavedspace\nopagebreak\>\begin{minipage}{0.8\linewidth}\small #1\end{minipage}\CV@Quadrule}

\newlength\CV@indent
\setlength\CV@indent{0.2\linewidth}

\NewDocumentEnvironment{cvtable}{o}{%
  \IfValueT{#1}{\subsection{#1}}%
  \renewcommand\pagebreak{\CV@intablepagebreak}%
  \begin{tabbing}%
  \hspace{\CV@indent}\=a\kill%
}{%
  \CV@rememberspace{0pt}%
  \end{tabbing}%
}

\NewDocumentEnvironment{cvshorttable}{o}{%
  \IfValueT{#1}{\subsection{#1}}%
  \vspace{0.2ex}
  \begin{multicols}{2}
  \begin{tabbing}
  \hspace{\CV@indent}\=a\kill
}{%
  \end{tabbing}%
  \end{multicols}
}
\newcommand\colbreak{\\\vspace*{\fill}\columnbreak}

\newlength{\photowidth}%
\setlength{\photowidth}{.18\textwidth}
% Personal info to be printed at the top
% \author is recognized in the usual way (and may not be omitted)
\newlength{\CV@defaultfilewidth}
\setlength{\CV@defaultfilewidth}{.2\textwidth}
\newcommand{\photofile}[2][\CV@defaultfilewidth]{%
  \newcommand{\CV@photofile}{#2}%
  \newlength{\photocirclewidth}%
  \setlength{\photocirclewidth}{#1}
}
\newcommand{\CV@dob}{}
\newcommand{\dateofbirth}[1]{
  \renewcommand{\CV@dob}{\makebox[3ex]{\faCalendar}#1{ }}
}
\newcommand{\CV@address}{}
\newcommand{\address}[1]{
  \renewcommand{\CV@address}{\makebox[3ex]{\faHome}#1{ }}
}
\newcommand{\CV@phone}{}
\newcommand{\phonenumber}[1]{
  \renewcommand{\CV@phone}{\makebox[3ex]{\faPhone}#1{ }}
}
\newcommand{\CV@mail}{}
\NewDocumentCommand{\emailaddress}{m o}{
 \renewcommand{\CV@mail}{\makebox[3ex]{\faEnvelope}\href{mailto:\IfValueTF{#2}{#2}{#1}}{#1}}
}

\newcommand{\titlebefore}[1]{
  \newcommand{\CV@titlepre}{#1}
}
\newcommand{\titleafter}[1]{
  \newcommand{\CV@titlepost}{#1}
}

\newcommand\CV@insertphoto{\ifthenelse{\not\isundefined{\CV@photofile}}{
    \begin{wrapfigure}[2]{r}[-5pt]{\photowidth}\vspace{-0.5cm}
    \tikz\node[circle,minimum width=\photowidth,path picture={
                 \node at (path picture bounding box.center){
                     \includegraphics[width=\photocirclewidth]{\CV@photofile}
                 };
             }]{};
    \end{wrapfigure}
  }{}}
\newcommand\CV@maketitle{{
    \hspace{-0.6mm}\Huge{}%
    \ifthenelse{\not\isundefined{\CV@titlepre}}{\textcolor{Gray}{\CV@titlepre} }{}%
    \@author\ifthenelse{\not\isundefined{\CV@titlepost}}{\textcolor{Gray}{, \CV@titlepost}}{} \\
    { \vspace{-1em} \scriptsize \CV@dob \CV@address \CV@phone \CV@mail }\vspace{1.5cm}
  }}

\AtBeginDocument{%
  \CV@insertphoto%
  \CV@maketitle%
}
