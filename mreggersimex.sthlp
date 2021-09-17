{smcl}
{* *! version 0.1.0  23jul2017 Tom Palmer}{...}
{vieweralsosee "mrrobust" "help mrrobust"}{...}
{viewerjumpto "Syntax" "mreggersimex##syntax"}{...}
{viewerjumpto "Description" "mreggersimex##description"}{...}
{viewerjumpto "Examples" "mreggersimex##examples"}{...}
{viewerjumpto "References" "mreggersimex##references"}{...}
{viewerjumpto "Author" "mreggersimex##author"}{...}
{title:Title}

{p 5}
{bf:mreggersimex} {hline 2} SIMEX for the MR-Egger estimator
{p_end}

{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:mreggersimex} {var:_gd} {var:_gp} [{it:aweight}] {ifin} 
[{cmd:,} {it:options}]

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{synopt :{opt mreggeropts}}Options for {help mregger}{p_end}
{synopt :{opt bsopts}}Options for {help bootstrap}{p_end}
{synopt :{opt gxse(varname)}}Variable containg genotype-phenotype (SNP-exposure) SEs{p_end}
{synopt :{opt noboot}}Do not perform bootstrapping for SEs{p_end}
{synopt :{opt nodraw}}Do not draw SIMEX plot{p_end}
{synopt :{opt reps(#)}}No. bootstrap replications{p_end}
{synopt :{opt seed:(#)}}Seed for random number generator, specify for reproducible results{p_end}
{synopt :{opt simreps(#)}}No. simulation replications{p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:mreggersimex} performs the simulation extrapolation (SIMEX) algorithm 
({help mreggersimex##cook:Cook et al., 1995}, {help mreggersimex##hardin:Hardin et al., 2003})
on {cmd:mregger} using the commonly applied quadratic extrapolation 
({help mreggersimex##bowden:Bowden et al., 2016}).

{pstd}
{var:_gd} variable containing the genotype-disease (SNP-outcome) association estimates.

{pstd}
{var:_gp} variable containing the genotype-phenotype (SNP-exposure) association estimates.

{pstd}
For the analytic weights you need to specify the inverse of the 
genotype-disease (SNP-outcome) SEs squared, i.e. aw=1/(gdse^2).

{marker examples}{...}
{title:Examples}

{pstd}Using the data provided by {help mreggersimex##do:Do et al. (2013)} recreate 
{help mreggersimex##mrmedian:Bowden et el. (2016)}, Figure 4, 
LDL-c "All genetic variants" (plot in row 2, column 1).{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:.} {stata "use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear"}{p_end}

{pstd}Select observations ({it:p}-value with exposure < 10^-8){p_end}
{phang2}{cmd:.} {stata "gen byte sel1 = (ldlcp2 < 1e-8)"}{p_end}

{pstd}SIMEX using default settings{p_end}
{phang2}{cmd:.} {stata "mreggersimex chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, gxse(ldlcse) seed(12345)"}{p_end}

{pstd}Suppressing the bootstrap SEs{p_end}
{phang2}{cmd:.} {stata "mreggersimex chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, gxse(ldlcse) seed(12345) noboot"}{p_end}

{pstd}Suppressing the bootstrap SEs and the plot{p_end}
{phang2}{cmd:.} {stata "mreggersimex chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, gxse(ldlcse) seed(12345) noboot nodraw"}{p_end}

{marker references}{...}
{title:References}

{marker bowden}{...}
{phang}
Bowden J, Del Greco FM, Minelli C, Davey Smith G, Sheehan NA, Thompson JR. 
Assessing the suitability of summary data for two-sample Mendelian 
randomization analyses using MR-Egger regression: the role of the I2 statistic. 
International Journal of Epidemiology, 2016, 45, 6, 1961-1974.
{browse "https://dx.doi.org/10.1093/ije/dyw220":DOI}
{p_end}

{marker mrmedian}{...}
{phang}
Bowden J, Davey Smith G, Haycock PC, Burgess S. 
Consistent estimation in Mendelian randomization with some invalid instruments
 using a weighted median estimator. Genetic Epidemiology, 2016, 40, 4, 304-314. 
{browse "https://dx.doi.org/10.1002/gepi.21965":DOI}
{p_end}

{marker cook}{...}
{phang}
Cook J and Stefanski LA. A simulation extrapolation method for parametric 
measurement error models. Journal of the American Statistical Association, 1995, 85, 
652-663. 
{browse "https://www.jstor.org/stable/2290994":Link}
{p_end}

{marker do}{...}
{phang}
Do R et al. Common variants associated with plasma triglycerides and risk
 for coronary artery disease. Nature Genetics, 2013, 45, 1345–1352. DOI: 
{browse "https://dx.doi.org/10.1038/ng.2795":DOI}
{p_end}

{marker hardin}{...}
{phang}
Hardin JW, Schmiediche H, Carroll RJ. The simulation extrapolation method 
for fitting linear models with additive measurement error. Stata Journal. 
2003, 3, 4, 373-385. 
{browse "https://www.stata-journal.com/article.html?article=st0051":DOI}
{p_end}

{marker author}{...}
{title:Author}

INCLUDE help mrrobust-author
