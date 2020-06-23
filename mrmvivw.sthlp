{smcl}
{* *! version 0.1.0  21jun2020 Tom Palmer}{...}
{vieweralsosee "mrrobust" "help mrrobust"}{...}
{viewerjumpto "Syntax" "mrmvivw##syntax"}{...}
{viewerjumpto "Description" "mrmvivw##description"}{...}
{viewerjumpto "Options" "mrmvivw##options"}{...}
{viewerjumpto "Examples" "mrmvivw##examples"}{...}
{viewerjumpto "Stored results" "mrmvivw##results"}{...}
{viewerjumpto "References" "mrmvivw##references"}{...}
{viewerjumpto "Author" "mrmvivw##author"}{...}
{title:Title}

{p 5}
{bf:mrmvivw} {hline 2} Multivariable inverse variance weighted regression (MVIVW)
{p_end}

{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt mrmvivw} {var:_gd} {var:_gp1} [{var:_gp2} ...] [{it:aweight}] {ifin} 
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt fe:}}Fixed effect standard errors (default is multiplicative)
{p_end}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:mrmvivw} performs multivariable inverse-variance weighted (IVW) regression using summary level data.

{pstd}
{var:_gd} variable containing the genotype-disease association estimates.

{pstd}
{var:_gp#} variable containing the #th genotype-phenotype association estimates.

{pstd}
For the analytic weights you need to specify the inverse of the genotype-disease standard errors squared, i.e. aw=1/(gdse^2).

{marker options}{...}
{title:Options}

{phang}
{opt fe} specifies fixed effect standard errors (i.e. variance of residuals constrained to 1 as in fixed effect meta-analysis models). The default is to use multiplicative standard errors (i.e. variance of residuals unconstrained as in standard linear regression).

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] estimation options}.

{marker examples}{...}
{title:Examples}

{pstd}Using the data provided by Do et al., Nat Gen, 2013.{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:.} {stata "use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear"}{p_end}

{pstd}Select observations ({it:p}-value with LDL-C < 10^-8){p_end}
{phang2}{cmd:.} {stata "gen byte sel1 = (ldlcp2 < 1e-8)"}{p_end}

{pstd}MVIVW{p_end}
{phang2}{cmd:.} {stata "mrmvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1"}{p_end}

{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mrmvivw} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimates{p_end}

{pstd}
{cmd:mrmvivw} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(table)}}Coefficient table with rownames: b, se, z, pvalue, ll, ul, df, crit, eform{p_end}

{marker references}{...}
{title:References}

{marker burgess}{...}
{phang}
Burgess S, Dudbridge F, Thompson SG. Re: "Multivariable
Mendelian randomization: the use of pleiotropic genetic variants to estimate causal effects". American Journal of Epidemiology, 2015, 181, 4, 251–260.
{browse "http://dx.doi.org/10.1093/aje/kwu283":DOI}
{p_end}

{marker author}
{title:Author}

{phang}Tom Palmer, MRC Integrative Epidemiology Unit and Population Health Sciences, University of Bristol, UK. {browse "mailto:tom.palmer@bristol.ac.uk":tom.palmer@bristol.ac.uk}.{p_end}

{phang}If you find any bugs or have questions please send me an email or create an issue on the GitHub repo: {browse "https://github.com/remlapmot/mrrobust/issues"} {p_end}
