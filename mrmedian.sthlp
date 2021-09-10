{smcl}
{* *! version 0.1.0  3jun2016 Tom Palmer}{...}
{vieweralsosee "mrrobust" "help mrrobust"}{...}
{viewerjumpto "Syntax" "mrmedian##syntax"}{...}
{viewerjumpto "Description" "mrmedian##description"}{...}
{viewerjumpto "Options" "mrmedian##options"}{...}
{viewerjumpto "Examples" "mrmedian##examples"}{...}
{viewerjumpto "Stored results" "mrmedian##results"}{...}
{viewerjumpto "References" "mrmedian##references"}{...}
{viewerjumpto "Author" "mrmedian##author"}{...}
{title:Title}

{p 5}
{bf:mrmedian} {hline 2} Weighted median of instrumental variable estimates
{p_end}

{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt mrmedian} {var:_gd} {var:_gdse} {var:_gp} {var:_gpse} {ifin} 
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt penw:eighted}}penalized weighted estimator{p_end}
{synopt :{opt reps:(#)}}number of bootstrap replications to obtain standard error{p_end}
{synopt :{opt seed:(#)}}seed for random number generator for bootstrapping to 
obtain standard error{p_end}
{synopt :{opt w:eighted}}weighted estimator{p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:mrmedian} performs unweighted, weighted, and penalized median IV 
estimator on summary level data (i.e. reported genotype-disease [SNP-outcome] and 
genotype-phenotype [SNP-exposure] association estimates and their standard errors for individual 
genotypes).

{pstd}
See {help mrmedian##bowden:Bowden et al. (2016)} for more information.

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

{marker options}{...}
{title:Options}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] estimation options}.

{phang}
{opt reps(#)} specifies the number of bootstrap replications for obtaining the
 standard error. The default is 1000 replications.

{phang}
{opt seed(#)} specifies the initial value of the random-number seed. 
The default is the current random-number seed. Specifying {opt seed(#)} is the
 same as typing {cmd:set seed} {it:#} before issuing the command; 
see {helpb set_seed}.

{phang}
{opt weighted} use weights.

{phang}
{opt penweighted} use penalized weights.


{marker examples}{...}
{title:Examples}

{pstd}Using the data provided by {help mrmedian##do:Do et al. (2013)} recreate 
{help mrmedian##bowden:Bowden et al. (2016)}, Table 4, 
LDL-c "All genetic variants" median estimates.{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:.} {stata "use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear"}{p_end}

{pstd}Select observations ({it:p}-value with exposure < 10^-8){p_end}
{phang2}{cmd:.} {stata "gen byte sel1 = (ldlcp2 < 1e-8)"}{p_end}

{pstd}Unweighted median estimator{p_end}
{phang2}{cmd:.} {stata "mrmedian chdbeta chdse ldlcbeta ldlcse if sel1==1"}{p_end}

{pstd}Unweighted median estimator with reproducible standard error{p_end}
{phang2}{cmd:.} {stata "mrmedian chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345)"}{p_end}

{pstd}Weighted median estimator{p_end}
{phang2}{cmd:.} {stata "mrmedian chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted"}{p_end}

{pstd}Penalized weighted median estimator{p_end}
{phang2}{cmd:.} {stata "mrmedian chdbeta chdse ldlcbeta ldlcse if sel1==1, penweighted"}{p_end}

{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mrmedian} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(k)}}number of instruments{p_end}
{synopt:{cmd:e(reps)}}number of (bootstrap) replications{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:mrmedian}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimates{p_end}

{marker references}{...}
{title:References}

{marker bowden}{...}
{phang}
Bowden J, Davey Smith G, Haycock PC, Burgess S. 
Consistent estimation in Mendelian randomization with some invalid instruments
 using a weighted median estimator. Genetic Epidemiology, 2016, 40, 4, 304-314. 
{browse "https://dx.doi.org/10.1002/gepi.21965":DOI}
{p_end}

{marker do}{...}
{phang}
Do et al. Common variants associated with plasma triglycerides and risk
 for coronary artery disease. Nature Genetics, 2013, 45, 1345–1352. 
{browse "https://dx.doi.org/10.1038/ng.2795":DOI}
{p_end}

{marker author}
{title:Author}

{phang}Tom Palmer, MRC Integrative Epidemiology Unit and Population Health Sciences, University of Bristol, UK. {browse "mailto:tom.palmer@bristol.ac.uk":tom.palmer@bristol.ac.uk}.{p_end}

{phang}If you find any bugs or have questions please send me an email or create an issue on the GitHub repo: {browse "https://github.com/remlapmot/mrrobust/issues"} {p_end}
