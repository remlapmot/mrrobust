{smcl}
{* *! version 0.1.0  10jun2016 Tom Palmer}{...}
{viewerjumpto "Syntax" "mreggerplot##syntax"}{...}
{viewerjumpto "Description" "mreggerplot##description"}{...}
{viewerjumpto "Examples" "mreggerplot##examples"}{...}
{viewerjumpto "References" "mreggerplot##references"}{...}
{viewerjumpto "Author" "mreggerplot##author"}{...}
{title:Title}

{p 5}
{bf:mreggerplot} {hline 2} Scatter plot for MR-Egger type models
{p_end}

{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:mreggerplot} {var:_gd} {var:_gdse} {var:_gp} {var:_gpse} {ifin} 
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt :{opt egger:}}MR-Egger estimator for fitted line{p_end}
{synopt :{opt ellipses:}}Marker confidence intervals as ellipses{p_end}
{synopt :{opt errorbars:}}Marker confidence intervals as capped lines{p_end}
{synopt :{opt fe:}}fixed effect standard errors for fitted line{p_end}
{synopt :{opt ivw:}}IVW line (default is MR-Egger){p_end}
{p2col:{cmd:legend(}{it:string}{cmd:)}}legend options{p_end}
{p2col:{cmd:level(}{it:#}{cmd:)}}set confidence level; default is
       {cmd:level(95)}{p_end}
{synopt :{opt median:}}median estimator for fitted line{p_end}
{synopt :{opt mlabel:(string)}}variable containing marker labels{p_end}
{synopt :{opt nolci:}}Do not confidence interval around fitted line{p_end}
{synopt :{opt noline:}}Do not plot fitted line{p_end}
{synopt :{opt nomcis:}}Do not confidence intervals around markers{p_end}
{synopt :{opt penweighted:}}Penalised weights for median estimator{p_end}
{synopt :{opt penw:eighted}}penalized weighted estimator{p_end}
{synopt :{opt re:}}random effect estimator for fitted line{p_end}
{synopt :{opt recons:}}random intercept for fitted line{p_end}
{synopt :{opt reslope:}}random slope for fitted line{p_end}
{synopt :{opt reps:(#)}}number of bootstrap replications to obtain standard error{p_end}
{synopt :{opt seed:(#)}}seed for random number generator for bootstrapping to 
obtain standard error{p_end}
{synopt :{opt w:eighted}}weighted median estimator{p_end}
{synopt :{opt wmarkers:}}Weighted markers{p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:mreggerplot} plots a scatter plot for MR-Egger type models

{pstd}
{var:_gd} is a variable containing the genotype-disease association estimates.

{pstd}
{var:_gdse} is a variable containing the genotype-disease association estimate 
standard errors.

{pstd}
{var:_gp} is a variable containing the phenotype-disease association 
estimates.

{pstd}
{var:_gpse} is a variable containing the phenotype-disease association 
estimate standard errors.


{marker examples}{...}
{title:Examples}

{pstd}Using the data provided by Do et al., Nat Gen, 2013 recreate Bowden et 
al., Gen Epi, 2016, Figure 4, LDL-c "All genetic variants" (plot in row 2, column 1).{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:.} {stata "use https://raw.github.com/remlapmot/mrmedian/master/dodata, clear"}{p_end}

{pstd}Select observations ({it:p}-value with exposure < 10^-8){p_end}
{phang2}{cmd:.} {stata "gen byte sel1 = (ldlcp2 < 1e-8)"}{p_end}

{pstd}Scatter plot of MR-Egger model{p_end}
{phang2}{cmd:.} {stata "mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, legend(off)"}{p_end}

{pstd}Scatter plot of IVW model{p_end}
{phang2}{cmd:.} {stata "mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ivw legend(off)"}{p_end}

{pstd}Scatter plot of unweighted median model{p_end}
{phang2}{cmd:.} {stata "mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, median legend(off)"}{p_end}

{pstd}Scatter plot of MR-Egger model using ellipses around points{p_end}
{phang2}{cmd:.} {stata "mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ellipses legend(off)"}{p_end}

{pstd}Scatter plot of MR-Egger model adding an IVW line for comparison{p_end}
{phang2}{cmd:.} {stata "mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, legend(off)"}{p_end}
{phang2}{cmd:.} {stata "mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw"}{p_end}
{phang2}{cmd:.} {stata "addplot : function _b[ldlcbeta]*x if sel1==1, range(0 0.5) lc(gs0) lp(longdash)"}{p_end}
{phang2}{cmd:.} {stata "mrmedian chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted"}{p_end}
{phang2}{cmd:.} {stata "addplot : function _b[beta]*x if sel1==1, range(0 0.5) lc(gs0) lp(shortdash)"}{p_end}


{marker references}{...}
{title:References}

{marker bowden}{...}
{phang}
Bowden J, Davey Smith G, Haycock PC, Burgess S. 2016. 
Consistent estimation in Mendelian randomization with some invalid instruments
 using a weighted median estimator. Genetic Epidemiology. 
DOI: {browse "http://dx.doi.org/10.1002/gepi.21965"}
{p_end}

{phang}
Do et al., 2013. Common variants associated with plasma triglycerides and risk
 for coronary artery disease. Nature Genetics. 45, 1345–1352. DOI: 
{browse "http://dx.doi.org/10.1038/ng.2795"}
{p_end}


{marker author}
{title:Author}

{phang}Tom Palmer
