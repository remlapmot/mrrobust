{smcl}
{* *! version 0.1.0  4jun2016 Tom Palmer}{...}
{vieweralsosee "mrrobust" "help mrrobust"}{...}
{viewerjumpto "Syntax" "mrmedianobs##syntax"}{...}
{viewerjumpto "Description" "mrmedianobs##description"}{...}
{viewerjumpto "Options" "mrmedianobs##options"}{...}
{viewerjumpto "Examples" "mrmedianobs##examples"}{...}
{viewerjumpto "Stored results" "mrmedianobs##results"}{...}
{viewerjumpto "References" "mrmedianobs##references"}{...}
{viewerjumpto "Author" "mrmedianobs##author"}{...}
{title:Title}

{p 5}
{bf:mrmedianobs} {hline 2} Weighted median of instrumental variable estimates
{p_end}

{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:mrmedianobs} {depvar} [{it:{help varlist:varlist1}}] 
{cmd:(}{var:_endog} {cmd:=} {varlist:_ivs}{cmd:)} {ifin}
 [{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt :{opt all:}}report percentile and bias corrected confidence intervals{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt obsboot:}}obtain standard error by bootstrapping at observation 
level{p_end}
{synopt :{opt penw:eighted}}penalized weighted estimator{p_end}
{synopt :{opt reps:(#)}}number of bootstrap replications to obtain standard error{p_end}
{synopt :{opt seed:(#)}}seed for random number generator for bootstrapping to 
obtain standard error{p_end}
{synopt :{opt w:eighted}}weighted estimator{p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:mrmedianobs} performs unweighted, weighted, and penalized IV estimator on 
observation level data ({help mrmedianobs##bowden:Bowden et al., 2016}).

{col 10}{depvar} {col 26}outcome variable
{col 10}{varlist:1} {col 26}covariates to adjust for
{col 10}{var:_endog} {col 26}exposure/treatment received/endogenous variable
{col 10}{varlist:_ivs} {col 26}instrumental variables

{marker options}{...}
{title:Options}

{phang}
{opt all} report percentile and bias corrected bootstrap confidence interval 
limits (only applies to observation level bootstrapping with {opt obsboot}).

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] estimation options}.

{phang}
{opt obsboot} obtain bootstrap standard error by bootstrapping at the 
observation level.

{phang}
{opt reps(#)} specifies the number of bootstrap replications for obtaining the
 standard error. The default is 50 replications.

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

{pstd}Simulated test dataset.{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:.} {stata "use https://raw.github.com/remlapmot/mrrobust/master/mrmedianobs_testdata, clear"}{p_end}

{pstd}Unweighted median estimator{p_end}
{phang2}{cmd:.} {stata "mrmedianobs y (x = z1-z20)"}{p_end}

{pstd}Weighted median estimator{p_end}
{phang2}{cmd:.} {stata "mrmedianobs y (x = z1-z20), weighted"}{p_end}

{pstd}Penalized weighted median estimator{p_end}
{phang2}{cmd:.} {stata "mrmedianobs y (x = z1-z20), penweighted"}{p_end}

{pstd}Unweighted median estimator with percentile CI limits of observation level bootstrapping{p_end}
{phang2}{cmd:.} {stata "mrmedianobs y (x = z1-z20), obsboot all"}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mrmedian} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(k)}}number of instruments{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(reps)}}number of (bootstrap) replications{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:mrmedianobs}{p_end}
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

{marker author}{...}
{title:Author}

INCLUDE help mrrobust-author
