{smcl}
{* *! version 0.1.0  23jul2017 Tom Palmer}{...}
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
{synopt :{opt gxse(varname)}}Variable containg genotype-phenotype SEs{p_end}
{synopt :{opt noboot}}Do not perform bootstrapping for SEs{p_end}
{synopt :{opt nodraw}}Do not draw SIMEX plot{p_end}
{synopt :{opt reps(#)}}No. bootstrap replications{p_end}
{synopt :{opt simreps(#)}}No. simulation replications{p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:mreggersimex} performs the simulation extrapolation (SIMEX) algorithm 
on {cmd:mregger} using the commonly applied quadratic extrapolation.

{pstd}
{var:_gd} variable containing the genotype-disease association estimates.

{pstd}
{var:_gp} variable containing the genotype-phenotype association estimates.

{pstd}
For the analytic weights you need to specify the inverse of the 
genotype-disease SEs squared, i.e. aw=1/(gdse^2).

{marker examples}{...}
{title:Examples}

{pstd}Using the data provided by Do et al., Nat Gen, 2013 recreate Bowden et 
al., Gen Epi, 2016, Figure 4, LDL-c "All genetic variants" (plot in row 2, column 1).{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:.} {stata "use https://raw.github.com/remlapmot/mrmedian/master/dodata, clear"}{p_end}

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
Bowden J, Del Greco FM, Minelli C, Davey Smith G, Sheehan NA, Thompson JR. 2016. 
Assessing the suitability of summary data for two-sample Mendelian 
randomization analyses using MR-Egger regression: the role of the I2 statistic. 
45, 6, 1961-1974.
{browse "http://dx.doi.org/10.1093/ije/dyw220"}
{p_end}

{phang}
Cook J and Stefanski LA. 1995. A simulation extrapolation method for parametric 
measurement error models. Journal of the American Statistical Association. 85, 
652-663.
{p_end}

{phang}
Do R et al., 2013. Common variants associated with plasma triglycerides and risk
 for coronary artery disease. Nature Genetics. 45, 1345–1352. DOI: 
{browse "http://dx.doi.org/10.1038/ng.2795"}
{p_end}

{phang}
Hardin JW, Schmiediche H, Carroll RJ. 2003. The simulation extrapolation method 
for fitting linear models with additive measurement error. Stata Journal. 
3, 4, 373-385.
{browse "http://www.stata-journal.com/article.html?article=st0051"}
{p_end}

{marker author}
{title:Author}

{phang}Tom Palmer
