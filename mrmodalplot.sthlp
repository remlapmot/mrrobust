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
{cmd:mrmodalplot} plots the density of the IV estimates used in the mrmodal estimator

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

{marker examples}{...}
{title:Examples}

{pstd}Using the data provided by Do et al., Nat Gen, 2013 recreate Bowden et 
al., Gen Epi, 2016, Figure 4, LDL-c "All genetic variants" (plot in row 2, column 1).{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:.} {stata "use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear"}{p_end}

{pstd}Select observations ({it:p}-value with exposure < 10^-8){p_end}
{phang2}{cmd:.} {stata "gen byte sel1 = (ldlcp2 < 1e-8)"}{p_end}

{pstd}Densities with phi=.25, .5, 1{p_end}
{phang2}{cmd:.} {stata "mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1"}{p_end}

{pstd}Densities with phi=.4, .6, .8, 1{p_end}
{phang2}{cmd:.} {stata "mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, phi(.4(.2)1)"}{p_end}

{pstd}Lines in grayscale{p_end}
{phang2}{cmd:.} {stata "mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, lc(gs10 gs5 gs0)"}{p_end}


{marker references}{...}
{title:References}

{phang}
Do et al., 2013. Common variants associated with plasma triglycerides and risk
 for coronary artery disease. Nature Genetics. 45, 1345–1352. DOI: 
{browse "http://dx.doi.org/10.1038/ng.2795"}
{p_end}

{marker author}
{title:Author}

{phang}Tom Palmer
