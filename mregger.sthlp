{smcl}
{* *! version 0.1.0  04jun2016 Tom Palmer}{...}
{vieweralsosee "mrrobust" "help mrrobust"}{...}
{viewerjumpto "Syntax" "mregger##syntax"}{...}
{viewerjumpto "Description" "mregger##description"}{...}
{viewerjumpto "Options" "mregger##options"}{...}
{viewerjumpto "Examples" "mregger##examples"}{...}
{viewerjumpto "Stored results" "mregger##results"}{...}
{viewerjumpto "References" "mregger##references"}{...}
{viewerjumpto "Author" "mregger##author"}{...}
{title:Title}

{p 5}
{bf:mregger} {hline 2} Mendelian randomization Egger regression
{p_end}

{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt mregger} {var:_gd} {var:_gp} [{it:aweight}] {ifin} 
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt fe:}}Fixed effect standard errors (default is multiplicative)
{p_end}
{synopt:{opt gxse(varname)}}variable of genotype-phenotype (SNP-exposure) SEs{p_end}
{synopt:{opt het:erogi}}Display heterogeneity/pleiotropy 
statistics{p_end}
{synopt:{opt ivw:}}Inverse-variance weighted estimator (default is MR-Egger)
{p_end}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt mod:ified}}use modified second order weights{p_end}
{synopt:{opt noresc:ale}}Do not rescale residual variance to be 1 (if less than 1){p_end}
{synopt:{opt oldnames}}Revert to using longer outcome name in b and V ereturned matrices{p_end}
{synopt:{opt penw:eighted}}Use penalized weights{p_end}
{synopt:{opt rad:ial}}Use radial formulations of the models{p_end}
{synopt:{opt sec:ond}}use second order weights{p_end}
{synopt:{opt tdist:}}Use t-distribution for Wald test and CI limits{p_end}
{synopt:{opt unwi2gx:}}Additionally report unweighted Q_GX and I^2_GX statistics{p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:mregger} performs inverse-variance weighted (IVW; {help mregger##ivw:Burgess et al., 2013}) and Mendelian 
randomization Egger (MR-Egger) regression ({help mregger##bowden:Bowden et al., 2015}) using summary level data 
(i.e. using genotype-disease [SNP-outcome] and genotype-phenotype [SNP-exposure] association estimates 
and their standard errors).

{pstd}
{var:_gd} variable containing the genotype-disease (SNP-outcome) association estimates.

{pstd}
{var:_gp} variable containing the genotype-phenotype (SNP-exposure) association estimates.

{pstd}
For the analytic weights you need to specify the inverse of the 
genotype-disease (SNP-outcome) standard errors squared, i.e. aw=1/(gdse^2).
 
{marker options}{...}
{title:Options}

{phang}
{opt fe} specifies fixed effect standard errors (i.e. variance of residuals 
constrained to 1 as in fixed effect meta-analysis models). The default is 
to use multiplicative standard errors (i.e. variance of residuals 
unconstrained as in standard linear regression), see 
{help mregger##thompson:Thompson and Sharp (1999)} for further details. 
We recommend specifying this option when using an 
allelic score as the instrumental variable.

{phang}
{opt gxse(varname)} specifies the variable containing the genotype-phenotype (SNP-exposure) 
association standard errors. These are required for calculating the I^2_GX
statistic ({help mregger##i2gx:Bowden et al., 2016}). An I^2_GX statistic of 90% means that the 
likely bias due measurement error in the MR-Egger slope estimate is around 
10%. If I^2_GX values are less than 90% estimates should be treated with 
caution.
 
{phang}
{opt het:erogi} displays heterogeneity/pleiotropy 
statistics. In the heterogeneity output 
the model based Q-statistic is reported by multiplying the variance of the 
residuals by the degrees of freedom ({help mregger##delgreco:Del Greco et al., 2015}). 
For the IVW model this is the Cochran Q-statistic, and for the MR-Egger model this is the 
Ruecker's Q-statistic.
 
{phang}
{opt ivw} specifies inverse-variance weighted (IVW) model ({help mregger##ivw:Burgess et al., 2013}), 
the default is MR-Egger.

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] estimation options}.

{phang}
{opt mod:ified} specifies modified second order weights, {cmd:gxse()} must also be specified.

{phang}
{opt noresc:ale} specifies that the residual variance is not set to 1 (if 
it is found to be less than 1). {help mregger##mrmedian:Bowden et al. (2016)} 
rescale the residual variance to be 1 if it is found to be less than 1.

{phang}
{opt oldnames} revert to using the longer outcome variable name in the b and V ereturned matrices.

{phang}
{opt penw:eighted} specifies using penalized weights as described in 
{help mregger##robust:Burgess et al. (2016)}.

{phang}
{opt rad:ial} specifies the radial formulation of the IVW and MR-Egger models 
({help mregger##radial:Bowden et al., 2017)}. 
Note there is only a difference for the MR-Egger model.
 
{phang}
{opt sec:ond} specifies second order weights; {cmd:gxse()} must also be specified.
 
{phang}
{opt tdist} specifies using the t-distribution, instead of the normal 
distribution, for calculating the Wald test and the confidence interval limits.

{phang}
{opt unwi2gx} specifies the unweighted Q_GX and I^2_GX statistics to be additionally displayed in 
the output and in the ereturn scalars.

{marker examples}{...}
{title:Examples}

{pstd}Using the data provided by {help mregger##do:Do et al. (2013)} recreate 
{help mregger##mrmedian:Bowden et al. (2016)}, Table 4, 
LDL-c "All genetic variants" estimates.{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:.} {stata "use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear"}{p_end}

{pstd}Select observations ({it:p}-value with exposure < 10^-8){p_end}
{phang2}{cmd:.} {stata "gen byte sel1 = (ldlcp2 < 1e-8)"}{p_end}

{pstd}IVW (with fixed effect standard errors){p_end}
{phang2}{cmd:.} {stata "mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw fe"}{p_end}

{pstd}MR-Egger (with SEs using an unconstrained residual variance){p_end}
{phang2}{cmd:.} {stata "mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1"}{p_end}

{pstd}MR-Egger reporting {it:I^2_GX} statistic and heterogeneity Q-test{p_end}
{phang2}{cmd:.} {stata "mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, gxse(ldlcse) heterogi"}{p_end}

{pstd}MR-Egger using a t-distribution for inference & CI limits{p_end}
{phang2}{cmd:.} {stata "mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, tdist"}{p_end}

{pstd}MR-Egger using the radial formulation{p_end}
{phang2}{cmd:.} {stata "mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, radial"}{p_end}

{pstd}MR-Egger using the radial formulation and reporting heterogeneity Q-test{p_end}
{phang2}{cmd:.} {stata "mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, radial heterogi"}{p_end}

{pstd}TODO:IVW fitted with second order weights{p_end}

{pstd}TODO:IVW fitted with modified second weights {p_end}

{pstd}TODO:MR-Egger fitted with second order weights{p_end}

{pstd}TODO:MR-Egger fitted with modified second weights {p_end}

{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mregger} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom (with {cmd:tdist} 
option){p_end}
{synopt:{cmd:e(k)}}number of instruments{p_end}
{synopt:{cmd:e(I2GX)}}I^2_GX (with {cmd:gxse()} option){p_end}
{synopt:{cmd:e(QGX)}}Q_GX (with {cmd:gxse()} option){p_end}
{synopt:{cmd:e(phi)}}Scale parameter (root mean squared error){p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:mregger}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimates{p_end}

{pstd}
If {opt heterogi} is specified {cmd:mregger} 
additionally returns the r-class results of {cmd:heterogi} in the e-class 
results.

{pstd}
If {opt unwi2gx} is specified {cmd:mregger} additionally returns{p_end}
{synopt:{cmd:e(I2GXunw)}}Unweighted I^2_GX statistic{p_end}
{synopt:{cmd:e(QGXunw)}}Unweighted Q_GX statistic{p_end}

{pstd}
{cmd:mregger} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(table)}}Coefficient table with rownames: b, se, z, pvalue, ll, ul, df, crit, eform{p_end}

{marker references}{...}
{title:References}

{marker bowden}{...}
{phang}
Bowden J, Davey Smith G, Burgess S. 
Mendelian randomization with invalid instruments: effect estimation and bias 
detection through Egger regression. International Journal of Epidemiology, 
2015, 44, 2, 512-525. 
{browse "http://dx.doi.org/10.1093/ije/dyv080":DOI}
{p_end}

{marker mrmedian}{...}
{phang}
Bowden J, Davey Smith G, Haycock PC, Burgess S. Consistent estimation 
in Mendelian randomization with some invalid instruments using a weighted 
median estimator. Genetic Epidemiology, 2016, 40, 4, 304-314. 
{browse "http://dx.doi.org/10.1002/gepi.21965":DOI}

{marker i2gx}{...}
{phang}
Bowden J, Del Greco F, Minelli C, Davey Smith G, Sheehan NA, Thompson JR. 
Assessing the suitability of summary data for two-sample Mendelian 
randomization analyses using MR-Egger regression: the role of the I-squared 
statistic. International Journal of Epidemiology, 2016, 45, 6, 1961-1974. 
{browse "http://dx.doi.org/10.1093/ije/dyw220":DOI}

{marker radial}{...}
{phang}
Bowden J, Spiller W, Del-Greco F, Sheehan NA, Thompson JR, Minelli C, Davey Smith G. 
Improving the visualisation, interpretation and analysis of two-sample summary 
data Mendelian randomization via the radial plot and radial regression. 
International Journal of Epidemiology, 2018, 47, 4, 1264-1278. {browse "https://doi.org/10.1093/ije/dyy101":DOI}

{marker robust}{...}
{phang}
Burgess S, Bowden J, Dudbridge F, Thompson SG. Robust instrumental 
variable methods using candidate instruments with application to Mendelian 
randomization. arXiv:1606.03729v1, 2016. 
{browse "https://arxiv.org/abs/1606.03729":Link}

{marker ivw}{...}
{phang}
Burgess S, Butterworth A, Thompson S. Mendelian randomization analysis with 
multiple genetic variants using summarized data. Genetic Epidemiology, 2013, 37, 7, 658–665. 
{browse "https://dx.doi.org/10.1002%2Fgepi.21758": DOI}

{marker delgreco}{...}
{phang}
Del Greco F M, Minelli C, Sheehan NA, Thompson JR. Detecting pleiotropy in 
Mendelian randomization studies with summary data and a continuous outcome. 
Statistics in Medicine, 2015, 34, 21, 2926-2940. 
{browse "https://onlinelibrary.wiley.com/doi/full/10.1002/sim.6522":DOI}
{p_end}

{marker do}{...}
{phang}
Do R et al. Common variants associated with plasma triglycerides and risk
 for coronary artery disease. Nature Genetics, 2013, 45, 1345–1352. DOI: 
{browse "http://dx.doi.org/10.1038/ng.2795":DOI}
{p_end}

{marker thompson}{...}
{phang}
Thompson SG, Sharp SJ. Explaining heterogeneity in meta-analysis: a 
comparison of methods. Statistics in Medicine, 1999, 18, 20, 2693-2708. 
{browse "http://dx.doi.org/10.1002/(SICI)1097-0258(19991030)18:20<2693::AID-SIM235>3.0.CO;2-V":DOI}
{p_end}

{marker author}
{title:Author}

{phang}Tom Palmer, MRC Integrative Epidemiology Unit and Population Health Sciences, University of Bristol, UK. {browse "mailto:tom.palmer@bristol.ac.uk":tom.palmer@bristol.ac.uk}.{p_end}

{phang}If you find any bugs or have questions please send me an email or create an issue on the GitHub repo: {browse "https://github.com/remlapmot/mrrobust/issues"} {p_end}
