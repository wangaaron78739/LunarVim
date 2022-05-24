local preamble = [[
\documentclass[12pt]{article}
\usepackage[usenames,svgnames,dvipsnames]{xcolor}
\usepackage{tikz}
\usepackage{pgfplots}
\usepackage[utf8]{inputenc}
\usepackage[english]{babel}
\usepackage{textcomp}
\usepackage[hyphens,spaces,obeyspaces]{url}
\usepackage{listings}
\usepackage[no-math]{fontspec}
\setmonofont{Source Code Pro}
\lstset{language=C++,
	basicstyle=\ttfamily,
	keywordstyle=\color{blue}\ttfamily,
	stringstyle=\color{red}\ttfamily,
	commentstyle=\color{green}\ttfamily,
	morecomment=[l][\color{magenta}]{\#}
}

\usepackage{bm}
\usepackage{amsmath,amsthm,amssymb,amsfonts}
\usepackage{mathtools}
\usepackage[color=green!10,
	colorinlistoftodos,
	linecolor=lightgray,
	bordercolor=green!10,
	textsize=footnotesize]{todonotes} % add [disable] to hide notes

\usepackage{booktabs}
\usepackage{array}
\usepackage{fancyhdr}
\usepackage[a4paper, margin=1in]{geometry}
\usepackage{multicol}
\usepackage{enumerate}
\usepackage{enumitem}
\setlist{nolistsep}
\usepackage{graphicx}
\usepackage{gensymb}
\usepackage{subcaption}
\usepackage{algorithm}
\usepackage{algpseudocode}
% \usepackage[noend]{algpseudocode}
\graphicspath{ {../images/} }
\usepackage[super]{nth}
\usepackage{subfiles}
\providecommand{\main}{..}

\usepackage{hyperref}
\hypersetup{
	colorlinks=blue,
	linkbordercolor=blue,
	citecolor=black,
	filecolor=black,
	linkcolor=black,
	urlcolor=black
}

\usepackage{makeidx}
\makeindex

\usepackage{thmtools}
\usepackage[framemethod=TikZ]{mdframed}

\theoremstyle{definition}
\mdfdefinestyle{mdbluebox}{%
	roundcorner = 10pt,
	linewidth=1pt,
	skipabove=12pt,
	innerbottommargin=9pt,
	skipbelow=2pt,
	nobreak=true,
	linecolor=blue,
	backgroundcolor=TealBlue!5,
}
\declaretheoremstyle[
	headfont=\sffamily\bfseries\color{MidnightBlue},
	mdframed={style=mdbluebox},
	headpunct={\\\\[3pt]},
	postheadspace={0pt}
]{thmbluebox}

\mdfdefinestyle{mdredbox}{%
	linewidth=0.5pt,
	skipabove=12pt,
	frametitleaboveskip=5pt,
	frametitlebelowskip=0pt,
	skipbelow=2pt,
	frametitlefont=\bfseries,
	innertopmargin=4pt,
	innerbottommargin=8pt,
	nobreak=true,
	linecolor=RawSienna,
	backgroundcolor=Salmon!5,
}
\declaretheoremstyle[
	headfont=\bfseries\color{RawSienna},
	mdframed={style=mdredbox},
	headpunct={\\\\[3pt]},
	postheadspace={0pt},
]{thmredbox}

\mdfdefinestyle{mdblackbox}{%
	linewidth=0.5pt,
	skipabove=12pt,
	frametitleaboveskip=5pt,
	frametitlebelowskip=0pt,
	skipbelow=2pt,
	frametitlefont=\bfseries,
	innertopmargin=4pt,
	innerbottommargin=8pt,
	nobreak=true,
	linecolor=black,
	backgroundcolor=RedViolet!5!gray!5,
}
\declaretheoremstyle[
	mdframed={style=mdblackbox},
	headpunct={\\\\[3pt]},
	postheadspace={0pt},
]{thmblackbox}
\declaretheorem[%
style=thmbluebox,name=Theorem,numberwithin=section]{theorem}
\declaretheorem[style=thmbluebox,name=Lemma,sibling=theorem]{lemma}
\declaretheorem[style=thmbluebox,name=Proposition,sibling=theorem]{proposition}
\declaretheorem[style=thmbluebox,name=Corollary,sibling=theorem]{corollary}
\declaretheorem[style=thmredbox,name=Example,sibling=theorem]{example}
\declaretheorem[style=thmblackbox,name=Algorithm,sibling=theorem]{algo}

\mdfdefinestyle{mdgreenbox}{%
	skipabove=8pt,
	linewidth=2pt,
	rightline=false,
	leftline=true,
	topline=false,
	bottomline=false,
	linecolor=ForestGreen,
	backgroundcolor=ForestGreen!5,
}
\declaretheoremstyle[
	headfont=\bfseries\sffamily\color{ForestGreen!70!black},
	bodyfont=\normalfont,
	spaceabove=2pt,
	spacebelow=1pt,
	mdframed={style=mdgreenbox},
	headpunct={ --- },
]{thmgreenbox}

%\mdfdefinestyle{mdblackbox}{%
%	skipabove=8pt,
%	linewidth=3pt,
%	rightline=false,
%	leftline=true,
%	topline=false,
%	bottomline=false,
%	linecolor=black,
%	backgroundcolor=RedViolet!5!gray!5,
%}
%\declaretheoremstyle[
%	headfont=\bfseries,
%	bodyfont=\normalfont\small,
%	spaceabove=0pt,
%	spacebelow=0pt,
%	mdframed={style=mdblackbox}
%]{thmblackbox}

\theoremstyle{theorem}
\declaretheorem[name=Remark,sibling=theorem,style=thmgreenbox]{remark}

\theoremstyle{definition}
\newtheorem{claim}[theorem]{Claim}
\newtheorem{definition}[theorem]{Definition}
\newtheorem{fact}[theorem]{Fact}

\newcommand{\vocab}[1]{\textbf{\color{blue} #1}}

\newcommand{\N}{\mathbb{N}}
\newcommand{\Z}{\mathbb{Z}}
\newcommand{\R}{\mathbb{R}}
\renewcommand{\C}{\mathbb{C}}
\newcommand{\Q}{\mathbb{Q}}
\newcommand\Ccancel[2][black]{\renewcommand\CancelColor{\color{#1}}\cancel{#2}}
\newcommand{\x}{\bm{x}}
\newcommand{\y}{\bm{y}}
\newcommand{\mat}[1]{\mathbf{#1}}
\newcommand{\norm}[1]{\left\lVert#1\right\rVert}
\newcommand{\sspan}{\operatorname{span}}
\DeclareMathOperator*{\argmax}{arg\,max}
\DeclareMathOperator*{\argmin}{arg\,min}
\DeclareMathOperator*{\arccosh}{arccosh}
\newcommand{\iprod}[2]{\left\langle{#1},{#2}\right\rangle }
\newcommand{\E}{\text{\textbf{E}}}
\newcommand{\Var}{\text{\textbf{Var}}}
%\newcommand{\Pr}{\text{Pr}}

\newcommand{\PreserveBackslash}[1]{\let\temp=\#1\let\=\temp}
\newcolumntype{C}[1]{>{\PreserveBackslash\centering}p{#1}}
\newcolumntype{R}[1]{>{\PreserveBackslash\raggedleft}p{#1}}
\newcolumntype{L}[1]{>{\PreserveBackslash\raggedright}p{#1}}

\newcommand{\bful}[1]{\underline{\textbf{#1}}}
]]

return {

  tex = {
    ["\\tab "] = [[
\begin{table}[${1:htpb}]
	\centering
	\caption{${2:caption}}
	\label{tab:${3:label}}
	\begin{tabular}{${5:c}}
	$0${5/((?<=.)c|l|r)|./(?1: & )/g}
	\end{tabular}
\end{table}
    ]],
    ["\\fig "] = [[
\begin{figure}[${1:htpb}]
	\centering
	${2:\includegraphics[width=0.8\textwidth]{$3}}
	\caption{${4:$3}}
	\label{fig:${5:${3/\W+/-/g}}}
\end{figure}
    ]],
    ["hwtemplate"] = [[
\documentclass[12pt]{article}
\usepackage[usenames,svgnames,dvipsnames]{xcolor}
\usepackage{tikz}
\usepackage{pgfplots}
\usepackage[utf8]{inputenc}
\usepackage[english]{babel}
\usepackage{textcomp}
\usepackage[hyphens,spaces,obeyspaces]{url}
\usepackage{listings}
\usepackage[no-math]{fontspec}
\setmonofont{Source Code Pro}
\lstset{language=C++,
	basicstyle=\ttfamily,
	keywordstyle=\color{blue}\ttfamily,
	stringstyle=\color{red}\ttfamily,
	commentstyle=\color{green}\ttfamily,
	morecomment=[l][\color{magenta}]{\#}
}
\lstset{language=R,
    frame = single,
    commentstyle=\color{ForestGreen}\ttfamily,
}

\usepackage{bm}
\usepackage{amsmath,amsthm,amssymb,amsfonts}
\usepackage{mathtools}
\usepackage{hyperref}
\usepackage[color=green!10,
	colorinlistoftodos,
	linecolor=lightgray,
	bordercolor=green!10,
	textsize=footnotesize]{todonotes} % add [disable] to hide notes

\usepackage{blkarray}
\usepackage{booktabs}
\usepackage{array}
\usepackage{fancyhdr}
\usepackage[a4paper, margin=1in]{geometry}
\usepackage{multicol}
\usepackage{enumerate}
\usepackage{enumitem}
% \setlist{nolistsep}
\usepackage{graphicx}
\usepackage{gensymb}
\usepackage{subcaption}
\usepackage{algorithm}
\usepackage{algpseudocode}
% \usepackage[noend]{algpseudocode}
\graphicspath{ {./images/} }
\usepackage[super]{nth}

\newtheorem{theorem}{Theorem}
\newtheorem{corollary}{Corollary}[theorem]
\newtheorem{definition}{Definition}
\newtheorem{lemma}{Lemma}
\theoremstyle{remark}
\newtheorem*{remark}{Remark}
\newtheorem*{answer}{Answer}

\newcommand{\N}{\mathbb{N}}
\newcommand{\Z}{\mathbb{Z}}
\newcommand{\R}{\mathbb{R}}
\renewcommand{\C}{\mathbb{C}}
\newcommand{\Q}{\mathbb{Q}}
\newcommand{\E}{\text{\textbf{E}}}
\newcommand{\Var}{\text{\textbf{Var}}}
\renewcommand{\Pr}{\text{Pr}}

\newcommand{\x}{\bm{x}}
\newcommand{\y}{\bm{y}}
\newcommand{\mat}[1]{\mathbf{#1}}
\newcommand{\norm}[1]{\left\lVert#1\right\rVert}
\newcommand{\PreserveBackslash}[1]{\let\temp=\\\\#1\let\\\\=\temp}
\newcolumntype{C}[1]{>{\PreserveBackslash\centering}p{#1}}
\newcolumntype{R}[1]{>{\PreserveBackslash\raggedleft}p{#1}}
\newcolumntype{L}[1]{>{\PreserveBackslash\raggedright}p{#1}}

\algdef{SE}[SUBALG]{Indent}{EndIndent}{}{\algorithmicend\ }%
\algtext*{Indent}
\algtext*{EndIndent}

\pagestyle{fancy}
% \fancyhf{}
\rhead{SID: 20477053}
\chead{Name: Aaron Si-yuan Wang}
\lhead{${1:CourseCode} - ${3:ShortTitle}}
\cfoot{\thepage}
\title{
{\LARGE $1 - ${2:CourseName}} \\\\
\textbf{\LARGE ${4:LongTitle}} \\\\
% \textbf{}
}
\author{ 
\begin{tabular}{R{0.3\textwidth}L{0.4\textwidth}}
\normalsize\textbf{Name:} & \normalsize WANG, Aaron Si-yuan \\\\
\normalsize\textbf{Student ID:} & \normalsize20477053 \\\\
\end{tabular}
}

\date{}

\begin{document}
\maketitle\thispagestyle{fancy}
$5
\end{document}
    ]],
    ["mainnotestemplate"] = preamble .. [[
\pagestyle{fancy}
\renewcommand{\sectionmark}[1]{\markright{#1}}
\fancyhf{}
\rhead{\fancyplain{}{${1:CourseCode} Notes}}
\lhead{\fancyplain{}{\rightmark }} 
\cfoot{\fancyplain{}{\thepage}}

\title{
{\LARGE $1 - ${2:CourseName}} \\\\
\textbf{\large Taught by ${4:InstructorName}}\\\\
\textbf{\large Notes by Aaron Wang}
}

\date{}

\begin{document}
\maketitle\thispagestyle{fancy}
\tableofcontents
\newpage
$5
\appendix
\newpage
\addcontentsline{toc}{section}{Index}
\printindex
\end{document}
]],
    ["subnotestemplate"] = [[
    \documentclass[../main/main.tex]{subfiles}

    \begin{document}

    \section{${1:Date}}
    \subsection{${2:Topic}}
    $0
    \end{document}
        ]],
  },
}
