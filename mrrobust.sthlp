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
{bf:mrrobust} {hline 2} Suite of commands implementing estimators robust to certain proportions of invalid instrumental variables commonly applied in 
Mendelian randomization (MR) studies


{title:Commands}{marker commands}

{col 7}{bf:{help mregger:mregger}}{...}
{col 30}MR-Egger and inverse-variance weighted (IVW) estimators

{col 7}{bf:{help mrmedian:mrmedian}}{...}
{col 30}Unweighted, weighted, and penalized weighted median estimators for 
summary level data

{col 7}{bf:{help mrmedianobs:mrmedianobs}}{...}
{col 30}Unweighted, weighted, and penalized weighted median estimators for 
individual level data

{marker description}{...}
{title:Description}

{pstd}
{cmd:mrrobust} is a suite of programs imlementing recently developed 
estimators which are robust to certain proportions of invalid instruments.


{title:Author}{marker author}

{p}Tom Palmer. Please report any bugs or issues you find.


{title:See Also}

{help metabias} (if installed)

{help metan} (if installed)

{help metareg} (if installed)
