{smcl}
{* *! version 0.1.0  30aug2017 Tom Palmer}{...}
{vieweralsosee "mrrobust" "mrrobust"}{...}
{viewerjumpto "Syntax" "mrfunnel##syntax"}{...}
{viewerjumpto "Description" "mrfunnel##description"}{...}
{viewerjumpto "Options" "mrfunnel##options"}{...}
{viewerjumpto "Examples" "mrfunnel##examples"}{...}
{viewerjumpto "References" "mrfunnel##references"}{...}
{viewerjumpto "Author" "mrfunnel##author"}{...}
{title:Title}

{p 5}
{bf:mrmodalplot} {hline 2} Funnel plot for two-sample MR analysis
{p_end}

{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt mrfunnel} {var:_gd} {var:_gdse} {var:_gp} {var:_gpse} {ifin} 
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt :{opt m:etric(metric)}}scale of {it:y}-axis{p_end}
{synopt :{opt noivw:}}do not plot IVW line{p_end}
{synopt :{opt nomregger:}}do not plot MR-Egger line{p_end}
{synopt :{opt mrivests:opts(opts)}}options passed to {help mrivests}{p_end}
{p2col:{cmd:*}}Other {help twoway_options:options} passed to the plot{p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:mrfunnel} provides a funnel plot for a two-sample Mendelian randomization
 analysis. 

{pstd} 
There are 3 choices of measures of instrument strength to plot on 
the {it:y}-axis, which are described below.
{p_end}
 
{pstd}
On the plot the MR-Egger estimate is the line with the longer dashes, 
the IVW estimate is shown with the shorter dashes.

{pstd}
{var:_gd} is a variable containing the genotype-disease association estimates.

{pstd}
{var:_gdse} is a variable containing the genotype-disease association estimate 
standard errors.

{pstd}
{var:_gp} is a variable containing the genotype-phenotype association 
estimates.

{pstd}
{var:_gpse} is a variable containing the genotype-phenotype association 
estimate standard errors.

{marker options}{...}
{title:Options}

{phang}
{opt m:etric(gpbeta|gpbetastd|invse)} specifies the metric for the 
{it:y}-axis. Can be one of:
{p_end}
{pstd}
 - {cmd:gpbeta}: the absolute value of the genotype-phenotype estimates,
{p_end}
{pstd}
 - {cmd:gpbetastd}: gpbeta standardised by the genotype-disease standard errors (the default),
{p_end}
{pstd}
 - {cmd:invse}: the inverse of the standard errors on the genotype specific IV ratio estimates.
{p_end}

{marker examples}{...}
{title:Examples}

{pstd}Using the data provided by Do et al., Nat Gen, 2013 recreate Bowden et 
al., Gen Epi, 2016, Web Figure A2 (top-right plot, LDL-C with 73 
genotypes).{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:.} {stata "use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear"}{p_end}

{pstd}Select observations ({it:p}-value with exposure < 10^-8){p_end}
{phang2}{cmd:.} {stata "gen byte sel1 = (ldlcp2 < 1e-8)"}{p_end}

{pstd}Funnel plot{p_end}
{phang2}{cmd:.} {stata "mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1"}{p_end}

{pstd}Without adding the IVW and MR-Egger estimates{p_end}
{phang2}{cmd:.} {stata "mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, noivw nomregger"}{p_end}

{pstd}Using a standardised {it:y}-axis{p_end}
{phang2}{cmd:.} {stata "mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, metric(gpbetastd)"}{p_end}

{pstd}Using inverse IV SEs on the {it:y}-axis{p_end}
{phang2}{cmd:.} {stata "mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, metric(invse)"}{p_end}


{marker references}{...}
{title:References}

{phang}
Do et al., 2013. Common variants associated with plasma triglycerides and risk
 for coronary artery disease. Nature Genetics. 45, 1345–1352. DOI: 
{browse "http://dx.doi.org/10.1038/ng.2795"}
{p_end}

{phang}
Bowden J, Davey Smith G, Haycock PC, Burgess S. Consistent estimation in 
Mendelian randomization with some invalid instruments using a weighted median 
estimator. Genetic Epidemiology, 2016, 40, 4, 304-314. DOI: 
{browse "http:dx.doi.org/10.1002/gepi.21965"}
{p_end}

{marker author}
{title:Author}

{phang}Tom Palmer
