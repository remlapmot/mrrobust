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
{bf:mrmvivw}/{bf:mvivw}/{bf:mvmr} {hline 2} Multivariable inverse variance weighted regression (MVIVW)
{p_end}

{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt mrmvivw}/{opt mvivw}/{opt mvmr} {var:_gd} {var:_gp1} [{var:_gp2} ...] [{it:aweight}] {ifin} 
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt fe:}}Fixed effect standard errors (default is multiplicative)
{p_end}
{synopt:{opt gxse(varlist)}}varlist of genotype-phenotype standard errors{p_end}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:mrmvivw}/{cmd:mvivw}/{cmd:mvmr} performs multivariable inverse-variance weighted (IVW) regression using summary level data. 
See {help mrmvivw##burgess: Burgess et al. (2015)} for more information.

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
{opt gxse(varlist)} specifies a varlist of genotype-phenotype standard errors. 
These should be in the same order as the genotype-phenotype variables in the main varlist. 
When this option is specified various Q and F statistics are calculated, 
see {help mrmvivw##sanderson:Sanderson et al. (2019)} for more information.

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

{phang2}{cmd:.} {stata "mvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1"}{p_end}

{phang2}{cmd:.} {stata "mvmr chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1"}{p_end}

{pstd}Report Q_A statistic{p_end}
{phang2}{cmd:.} {stata "mrmvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, gxse(ldlcse hdlcse tgse)"}{p_end}

{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mrmvivw}/{cmd:mvivw}/{cmd:mvmr} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}Number of genotypes{p_end}
{synopt:{cmd:e(Np)}}Number of phenotypes{p_end}
{p2col 5 20 24 2: If {cmd:gxse()} specified}{p_end}
{synopt:{cmd:e(Qa)}}Q_A statistic{p_end}
{synopt:{cmd:e(Qadf)}}Degrees of freedom of Q_A statistic{p_end}
{synopt:{cmd:e(Qap)}}P-value for Q_A chi-squared test{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}Command name{p_end}
{synopt:{cmd:e(cmdline)}}Command issued{p_end}
{synopt:{cmd:e(setype)}}Standard error type{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimates{p_end}

{pstd}
{cmd:mrmvivw}/{cmd:mvivw}/{cmd:mvmr} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(table)}}Coefficient table with rownames: b, se, z, pvalue, ll, ul, df, crit, eform{p_end}

{marker references}{...}
{title:References}

{marker burgess}{...}
{phang}
Burgess S, Dudbridge F, Thompson SG. Multivariable Mendelian randomization: 
the use of pleiotropic genetic variants to estimate causal effects. 
American Journal of Epidemiology, 2015, 181, 4, 251–260.
{browse "http://dx.doi.org/10.1093/aje/kwu283":DOI}
{p_end}
{marker sanderson}{...}
{phang}
Sanderson E, Davey Smith G, Windmeijer F, Bowden J. An examination of multivariable Mendelian 
randomization in the single-sample and two-sample summary data settings. International 
Journal of Epidemiology, 2019, 48, 3, 713-727. 
{browse "http://dx.doi.org/10.1093/ije/dyy262":DOI}
{p_end}

{marker author}
{title:Author}

{phang}Tom Palmer, MRC Integrative Epidemiology Unit and Population Health Sciences, University of Bristol, UK. {browse "mailto:tom.palmer@bristol.ac.uk":tom.palmer@bristol.ac.uk}.{p_end}

{phang}If you find any bugs or have questions please send me an email or create an issue on the GitHub repo: {browse "https://github.com/remlapmot/mrrobust/issues"} {p_end}
