{smcl}
{* *! version 0.1.0 Tom Palmer 05jun2017}{...}
{vieweralsosee "mrdeps" "mrdeps"}{...}
{vieweralsosee "mregger" "mregger"}{...}
{vieweralsosee "mreggersimex" "mreggersimex"}{...}
{vieweralsosee "mreggerplot" "mreggerplot"}{...}
{vieweralsosee "mrmedian" "mrmedian"}{...}
{vieweralsosee "mrmedianobs" "mrmedianobs"}{...}
{vieweralsosee "mrmodal" "mrmodal"}{...}
{vieweralsosee "mrmodalplot" "mrmodalplot"}{...}
{vieweralsosee "mrratio" "mrratio"}{...}
{vieweralsosee "mrivests" "mrivests"}{...}
{vieweralsosee "mrforest" "mrforest"}{...}
{vieweralsosee "mrfunnel" "mrfunnel"}{...}
{vieweralsosee "mr" "help mr"}{...}
{viewerjumpto "Commands" "mrrobust##commands"}{...}
{viewerjumpto "Description" "mrrobust##description"}{...}
{viewerjumpto "Author" "mrrobust##author"}{...}
{title:Title}

{phang}
{bf:mrrobust} {hline 2} commands for two-sample Mendelian randomization (MR) analyses.

{phang}
{browse "https://remlapmot.github.io/mrrobust/"}{p_end}

{title:Commands}{marker commands}

{synoptset 14 tabbed}{...}
{synopt :{opt {help mrdeps}:}}Install dependencies for the package.

{synopt :{opt {help mregger}:}}MR-Egger and inverse-variance weighted (IVW) estimators.

{synopt :{opt {help mreggersimex}:}}Simulation extrapolation algorithm for the MR-Egger model.

{synopt :{opt {help mreggerplot}:}}Scatter plot showing instrument specific estimates with IVW, MR-Egger, or median fitted line and confidence interval.

{synopt :{opt {help mrmedian}:}}Unweighted, weighted, and penalized weighted median estimators for summary level data.

{synopt :{opt {help mrmedianobs}:}}Unweighted, weighted, and penalized weighted median estimators for individual level data.

{synopt :{opt {help mrmodal}:}}Modal estimator for summary level data.

{synopt :{opt {help mrmodalplot}:}}Plot of density used in Modal estimator.

{synopt :{opt {help mrratio}:}}Ratio (Wald) estimator for summary level data for a single genotype.

{synopt :{opt {help mrivests}:}}Generate ratio (Wald) estimates for summary level data in dataset.

{synopt :{opt {help mrforest}:}}Forest plot of genotype specific and model (IVW, MR-Egger, Median, Modal) IV estimates.

{synopt :{opt {help mrfunnel}:}}Funnel plot of the genotype specific IV estimates.

{synopt :{opt {help mr}:}}Primary command syntax, e.g. call programs as {cmd:mr egger ...} as well as {cmd:mregger ...}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:mrrobust} is a suite of programs implementing recently developed 
estimators which are robust to certain proportions of invalid instrumental 
variables. 

{pstd}
Most of the commands are designed to use summary level data as provided by 
repositories such as {browse "http://www.mrbase.org":MR-Base}.

{pstd}
The estimators were developed in the context of MR studies but 
could be used for other applications of instrumental variables.

{pstd}
There is a website showing the examples from the helpfiles here: {browse "https://remlapmot.github.io/mrrobust/"}{p_end}

{title:Author}{marker author}

{pstd}
Tom Palmer, Department of Mathematics and Statistics, Lancaster University, UK. {browse "mailto:tom.palmer@lancaster.ac.uk":tom.palmer@lancaster.ac.uk}. 

{pstd}
Development takes place on GitHub here {browse "https://github.com/remlapmot/mrrobust"}.

{pstd}
Please report any bugs or issues you find, either by email or by creating an issue on the GitHub repository here {browse "https://github.com/remlapmot/mrrobust/issues"}.

{pstd}
I welcome additions to the code, either by email or pull request on GitHub.