{smcl}
{* *! version 0.1.0  10jun2016 Tom Palmer}{...}
{vieweralsosee "mrrobust" "help mrrobust"}{...}
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
{synopt :{opt ellipses:}}marker confidence intervals as ellipses{p_end}
{synopt :{opt errorbars:}}marker confidence intervals as capped lines{p_end}
{synopt :{opt fe:}}fixed effect standard errors for fitted line{p_end}
{synopt :{opt gpci:}}CIs around G-P associations{p_end}
{synopt :{opt ivw:}}IVW line (default is MR-Egger){p_end}
{p2col:{cmd:legend(}{it:string}{cmd:)}}legend options{p_end}
{p2col:{cmd:level(}{it:#}{cmd:)}}set confidence level; default is
       {cmd:level(95)}{p_end}
{synopt :{opt linetop:}}draw fitted line (and CI) on top of points{p_end}
{p2col:{cmd:mleglabel(}{it:string}{cmd:)}}Label for data points in legend; default is Instruments{p_end}
{synopt :{opt median:}}median estimator for fitted line{p_end}
{synopt :{opt mlabel:(string)}}variable containing marker labels{p_end}
{synopt :{opt nolci:}}do not plot confidence interval around fitted line{p_end}
{synopt :{opt noline:}}do not plot fitted line{p_end}
{synopt :{opt nomcis:}}do not plot confidence intervals around markers{p_end}
{synopt :{opt penw:eighted}}penalized weighted estimator{p_end}
{synopt :{opt re:}}random effect estimator for fitted line{p_end}
{synopt :{opt recons:}}random intercept for fitted line{p_end}
{synopt :{opt reslope:}}random slope for fitted line{p_end}
{synopt :{opt reps:(#)}}number of bootstrap replications to obtain standard error{p_end}
{synopt :{opt seed:(#)}}seed for random number generator for bootstrapping to 
obtain standard error{p_end}
{synopt :{opt w:eighted}}weighted median estimator{p_end}
{synopt :{opt wmarkers:}}weighted markers{p_end}
{p2col:{cmd:*}}Other options passed to the {cmd:twoway} plot{p_end}

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
{var:_gp} is a variable containing the genotype-phenotype association 
estimates.

{pstd}
{var:_gpse} is a variable containing the genotype-phenotype association 
estimate standard errors.

{marker examples}{...}
{title:Examples}

{pstd}Using the data provided by {help mreggerplot##do:Do et al. (2013)} recreate 
{help mreggerplot##bowden:Bowden et al. (2016)}, Figure 4, 
LDL-c "All genetic variants" (plot in row 2, column 1).{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:.} {stata "use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear"}{p_end}

{pstd}Select observations ({it:p}-value with exposure < 10^-8){p_end}
{phang2}{cmd:.} {stata "gen byte sel1 = (ldlcp2 < 1e-8)"}{p_end}

{pstd}Scatter plot of MR-Egger model{p_end}
{phang2}{cmd:.} {stata "mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1"}{p_end}

{pstd}Scatter plot of MR-Egger model labelling outlying genotypes{p_end}
{phang2}{cmd:.} {stata "gen mlabvar = rsid if abs(ldlcbeta) > .3"}{p_end}
{phang2}{cmd:.} {stata "mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, mlab(mlabvar) mlabsize(vsmall) mlabp(7) mlabc(gs0)"}{p_end}

{pstd}Scatter plot of MR-Egger model with genotype-phenotype CIs{p_end}
{phang2}{cmd:.} {stata "mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, gpci"}{p_end}

{pstd}Scatter plot of MR-Egger model specifying own titles and legend label{p_end}
{phang2}{cmd:.} {stata "mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, title(Investigating pleiotropy: MR-Egger model fit) xtitle(Genotype-LDLC associations) ytitle(Genotype-CHD associations) mleglabel(Genotypes)"}{p_end}

{pstd}Scatter plot of IVW model{p_end}
{phang2}{cmd:.} {stata "mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ivw"}{p_end}

{pstd}Scatter plot of unweighted median model{p_end}
{phang2}{cmd:.} {stata "mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, median"}{p_end}

{pstd}Scatter plot of MR-Egger model using ellipses around points{p_end}
{phang2}{cmd:.} {stata "mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ellipses"}{p_end}

{pstd}Scatter plot of MR-Egger model adding an IVW line (with legend entry) for comparison{p_end}
{phang2}{cmd:.} {stata "mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1"}{p_end}
{phang2}{cmd:.} {stata "mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw"}{p_end}
{phang2}{cmd:.} {stata `"addplot : function _b[ldlcbeta]*x if sel1==1, range(0 0.5) lc(gs0) lp(longdash) lw(vthin) legend(order(5 "Instruments" 4 "95% CIs" 3 "MR-Egger" 2 "MR-Egger 95% CI" 6 "IVW") rows(1) size(vsmall))"'}{p_end}

{pstd}Scatter plot of MR-Egger model adding weighted median and modal lines (with legend entries) for comparison{p_end}
{phang2}{cmd:.} {stata "mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1"}{p_end}
{phang2}{cmd:.} {stata "mrmedian chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted"}{p_end}
{phang2}{cmd:.} {stata "addplot : function _b[beta]*x if sel1==1, range(0 0.5) lc(gs0) lp(shortdash) lw(vthin)"}{p_end}
{phang2}{cmd:.} {stata "mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, phi(.25)"}{p_end}
{phang2}{cmd:.} {stata `"addplot : function _b[beta]*x if sel1==1, range(0 0.5) lc(gs0) lp(longdash) legend(order(5 "Instruments" 4 "95% CIs" 3 "MR-Egger" 2 "MR-Egger 95% CI" 6 "Weighted median" 7 "Modal") rows(1) si(vsmall) symx(*.5))"'}{p_end}

{pstd}Scatter plot without any fitted lines{p_end}
{phang2}{cmd:.} {stata `"mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ivw noline nolci gpci legend(order(4 "Instruments" 3 "95% CI") size(vsmall) rows(1))"'}{p_end}

{marker references}{...}
{title:References}

{marker bowden}{...}
{phang}
Bowden J, Davey Smith G, Haycock PC, Burgess S. 
Consistent estimation in Mendelian randomization with some invalid instruments 
using a weighted median estimator. Genetic Epidemiology, 2016, 40, 4, 304-314. 
{browse "http://dx.doi.org/10.1002/gepi.21965":DOI}
{p_end}

{marker do}{...}{phang}
Do et al.Common variants associated with plasma triglycerides and risk 
for coronary artery disease. Nature Genetics, 2013, 45, 1345–1352.  
{browse "http://dx.doi.org/10.1038/ng.2795":DOI}
{p_end}

{marker author}
{title:Author}

{phang}Tom Palmer, MRC Integrative Epidemiology Unit and Population Health Sciences, University of Bristol, UK. {browse "mailto:tom.palmer@bristol.ac.uk":tom.palmer@bristol.ac.uk}.{p_end}

{phang}If you find any bugs or have questions please send me an email or create an issue on the GitHub repo: {browse "https://github.com/remlapmot/mrrobust/issues"} {p_end}
