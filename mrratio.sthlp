{smcl}
{* *! version 0.1.0  6jun2017 Tom Palmer}{...}
{vieweralsosee "mrrobust" "help mrrobust"}{...}
{viewerjumpto "Syntax" "mrratio##syntax"}{...}
{viewerjumpto "Description" "mrratio##description"}{...}
{viewerjumpto "Options" "mrratio##options"}{...}
{viewerjumpto "Examples" "mrratio##examples"}{...}
{viewerjumpto "Stored results" "mrratio##results"}{...}
{viewerjumpto "Author" "mrratio##author"}{...}
{title:Title}

{p 5}
{bf:mrratio} {hline 2} Instrumental variable ratio (Wald) estimator
{p_end}

{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt mrratio} {it:#gd} {it:#gdse} {it:#gp} [{it:#gpse} {it:#cov}]
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt :{opt eform:}}exp() estimate and CI limits{p_end}
{synopt :{opt fieller:}}CI using Fieller's Theorem{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nome:}}NOME assumption{p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:mrratio} implements the standard instrumental variable ratio (Wald) 
estimator. 

{pstd}
{cmd:mrratio} can generate confidence interval limits using either a standard 
error from a Taylor series expansion (the default), a standard error using 
the NOME (no measurement error) in the genotype-phenotype (SNP-exposure) association 
assumption, or using Fieller's Theorem.

{pstd}
The user needs to have summary level genotype-disease (SNP-outcome) and genotype-phenotype (SNP-exposure) 
association estimates and their standard errors. If assuming NOME the 
standard error of the genotype-phenotype (SNP-exposure) association is not required.

{pstd}
It is also optional to provide the covariance between the genotype-disease (SNP-outcome)
and genotype-phenotype (SNP-exposure) estimates. If these are from independent samples then 
this covariance is zero.

{pstd}
{it:#gd} genotype-disease (SNP-outcome) association estimate.

{pstd}
{it:#gdse} standard error of the genotype-disease (SNP-outcome) association estimate.

{pstd}
{it:#gp} genotype-phenotype (SNP-exposure) association estimate.

{pstd}
{it:#gpse} standard error of the genotype-phenotype (SNP-exposure) association estimate.

{pstd}
{it:#cov} covariance between the genotype-disease (SNP-outcome) and the genotype-phenotype (SNP-exposure) estimates.

{marker options}{...}
{title:Options}

{phang}
{opt eform} specifies reporting the exponentiated ratio estimate and 
confidence interval limits.

{phang}
{opt fieller} specifies deriving the confidence interval using Fieller's 
Theorem.

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] estimation options}.

{phang}
{opt nome} specifies the NOME (no measurement error in the genotype-phenotype [SNP-exposure] 
association) assumption.

{marker examples}{...}
{title:Examples}

{pstd}Hypothetical example{p_end}
{phang2}{cmd:.} {stata "mrratio 1 .5 1 .25"}{p_end}

{pstd}With NOME assumption{p_end}
{phang2}{cmd:.} {stata "mrratio 1 .5 1 .25, nome"}{p_end}

{pstd}With NOME assumption{p_end}
{phang2}{cmd:.} {stata "mrratio 1 .5 1, nome"}{p_end}

{pstd}Exponentiate estimate and CI limits{p_end}
{phang2}{cmd:.} {stata "mrratio 1 .5 1 .25, eform"}{p_end}

{pstd}CI using Fieller's Theorem{p_end}
{phang2}{cmd:.} {stata "mrratio 1 .5 1 .25, fieller"}{p_end}

{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mrratio} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(fiellerres)}}Result code from the Fieller CI: . {opt fieller} 
not specified; 1 closed CI; 2 union of two intervals; 
3 CI is whole real line{p_end}
{synopt:{cmd:e(level)}}level specified in first call to {cmd:mrratio}.{p_end}

{p2col 5 20 24 2: When {opt fieller} specified additional scalars:}{p_end}
{synopt:{cmd:e(lowerci)}}lower CI limit{p_end}
{synopt:{cmd:e(upperci)}}upper CI limit{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:mrratio}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimate{p_end}

{marker author}{...}
{title:Author}

INCLUDE help mrrobust-author
