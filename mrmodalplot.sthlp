{smcl}
{* *! version 0.1.0  2aug2017 Tom Palmer}{...}
{vieweralsosee "mrrobust" "mrrobust"}{...}
{viewerjumpto "Syntax" "mrmodalplot##syntax"}{...}
{viewerjumpto "Description" "mrmodalplot##description"}{...}
{viewerjumpto "Examples" "mrmodalplot##examples"}{...}
{viewerjumpto "References" "mrmodalplot##references"}{...}
{viewerjumpto "Author" "mrmodalplot##author"}{...}
{title:Title}

{p 5}
{bf:mrmodalplot} {hline 2} Density plot to investigate values of phi in mrmodal
{p_end}

{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt mrmodalplot} {var:_gd} {var:_gdse} {var:_gp} {var:_gpse} {ifin} 
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt :{opt lc:(optlist)}}list of line {help colorstyle:colors}{p_end}
{synopt :{opt lp:(optlist)}}list of line {help linepatternstyle:patterns}{p_end}
{synopt :{opt lw:(optlist)}}list of line {help linewidthstyle:widths}{p_end}
{synopt :{opt nome:}}NOME assumption{p_end}
{synopt :{opt phi:(numlist)}}value/s of phi (for bandwidth), default is .25 .5 1{p_end}
{synopt :{opt reps:(#)}}number of bootstrap replications to obtain standard error{p_end}
{synopt :{opt seed:(#)}}seed for random number generator for bootstrapping to 
obtain standard error{p_end}
{synopt :{opt weight:ed}}weighted IV estimates{p_end}
{p2col:{cmd:*}}Other options passed to the {cmd:twoway} plot{p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:mrmodalplot} plots the density of the IV estimates used in the {help mrmodal} estimator.

{pstd}
{var:_gd} is a variable containing the genotype-disease (SNP-outcome) association estimates.

{pstd}
{var:_gdse} is a variable containing the genotype-disease (SNP-outcome) association estimate 
standard errors.

{pstd}
{var:_gp} is a variable containing the genotype-phenotype (SNP-exposure) association 
estimates.

{pstd}
{var:_gpse} is a variable containing the genotype-phenotype (SNP-exposure) association 
estimate standard errors.

{marker examples}{...}
{title:Examples}

{pstd}Using the data provided by {help mrmodalplot##do:Do et al. (2013)} recreate 
{help mrmodalplot##bowden:Bowden et (2016)}, Figure 4, 
LDL-c "All genetic variants" (plot in row 2, column 1).{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:.} {stata "use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear"}{p_end}

{pstd}Select observations ({it:p}-value with exposure < 10^-8){p_end}
{phang2}{cmd:.} {stata "gen byte sel1 = (ldlcp2 < 1e-8)"}{p_end}

{pstd}Densities with phi=.25, .5, 1 and reproducible standard error{p_end}
{phang2}{cmd:.} {stata "mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345)"}{p_end}

{pstd}Densities with phi=.4, .6, .8, 1 and reproducible standard error{p_end}
{phang2}{cmd:.} {stata "mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, phi(.4(.2)1) seed(12345)"}{p_end}

{pstd}Lines in grayscale and reproducible standard error{p_end}
{phang2}{cmd:.} {stata "mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, lc(gs10 gs5 gs0) seed(12345)"}{p_end}


{marker references}{...}
{title:References}

{marker bowden}{...}
{phang}
Bowden J, Davey Smith G, Haycock PC, Burgess S. Consistent estimation in 
Mendelian randomization with some invalid instruments using a weighted median 
estimator. Genetic Epidemiology, 2016, 40, 4, 304-314. 
{browse "http:dx.doi.org/10.1002/gepi.21965":DOI}
{p_end}

{marker do}{...}
{phang}
Do et al. Common variants associated with plasma triglycerides and risk
 for coronary artery disease. Nature Genetics, 2013, 45, 1345–1352. 
{browse "http://dx.doi.org/10.1038/ng.2795":DOI}
{p_end}

{marker author}
{title:Author}

{phang}Tom Palmer, MRC Integrative Epidemiology Unit and Population Health Sciences, University of Bristol, UK. {browse "mailto:tom.palmer@bristol.ac.uk":tom.palmer@bristol.ac.uk}.{p_end}

{phang}If you find any bugs or have questions please send me an email or create an issue on the GitHub repo: {browse "https://github.com/remlapmot/mrrobust/issues"} {p_end}
