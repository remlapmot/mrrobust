{smcl}
{* *! version 0.1.0 Tom Palmer 05jun2016}{...}
{vieweralsosee "mregger" "mregger"}{...}
{vieweralsosee "mrmedian" "mrmedian"}{...}
{vieweralsosee "mrmedianobs" "mrmedianobs"}{...}
{viewerjumpto "Commands" "mrrobust##commands"}{...}
{viewerjumpto "Description" "mrrobust##description"}{...}
{viewerjumpto "Author" "mrrobust##author"}{...}
{title:Title}

{phang}
{bf:mrrobust} {hline 2} Suite of commands implementing estimators robust to 
certain proportions of invalid instrumental variables which are 
becoming commonly applied in Mendelian randomization (MR) studies.


{title:Commands}{marker commands}

{col 7}{bf:{help mregger:mregger}}{...}
{col 20}MR-Egger and inverse-variance weighted (IVW) estimators.

{col 7}{bf:{help mrmedian:mrmedian}}{...}
{col 20}Unweighted, weighted, and penalized weighted median estimators for 
summary level data.

{col 7}{bf:{help mrmedianobs:mrmedianobs}}{...}
{col 20}Unweighted, weighted, and penalized weighted median estimators for 
individual level data.

{col 7}{bf:{help mreggerplot:mreggerplot}}{...}
{col 20}Scatter plot showing instrument specific estimates with IVW, 
MR-Egger, or median fitted line and confidence interval.


{marker description}{...}
{title:Description}

{pstd}
{cmd:mrrobust} is a suite of programs imlementing recently developed 
estimators which are robust to certain proportions of invalid instrumental 
variables. 

{pstd}
The estimators were developed in the context of MR studies but 
could be used in other studies using instrumental variables.


{title:Author}{marker author}

{p}Tom Palmer. Please report any bugs or issues you find.
