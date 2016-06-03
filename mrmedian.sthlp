{smcl}
{* *! version 0.1.0  3jun2016 Tom Palmer}{...}
{viewerjumpto "Syntax" "mrmedian##syntax"}{...}
{viewerjumpto "Description" "mrmedian##description"}{...}
{viewerjumpto "Options" "mrmedian##options"}{...}
{viewerjumpto "Examples" "mrmedian##examples"}{...}
{viewerjumpto "Stored results" "mrmedian##results"}{...}
{viewerjumpto "References" "mrmedian##references"}{...}
{title:Title}

{p 5}
{bf:mrmedian} {hline 2} Weighted median of instrumental variable estimates
{p_end}

{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt mrmedian} {varname1} {varname2} {varname3} {varname4} {ifin} 
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt :{opt PENW:eighted}}penalized weighted estimator{p_end}
{synopt :{opt seed:(#)}}seed for random number generator for bootstrapping to 
obtain standard error{p_end}
{synopt :{opt W:eighted}}weighted estimator{p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:mrmedian} performs unweighted, weighted, and penalized IV estimator.

{pstd}
{varname1} is a variable containing the genotype-disease association estimates.

{pstd}
{varname2} is a variable containing the genotype-disease association standard 
errors.

{pstd}
{varname3} is a variable containing the phenotype-disease association 
estimates.

{pstd}
{varname4} is a variable containing the phenotype-disease association standard 
errors.

{marker options}{...}
{title:Options}

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
{title:Example 1}

{pstd}Using the data provided by Do et al., Nat Gen, 2013 recreate Bowden et 
al., Gen Epi, 2016, Table 4, LDL-c "All genetic variants" median estimates.{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:. use https://raw.github.com/remlapmot/stata.mrmedian/master/dodata, clear}{p_end}

{pstd}Select observations{p_end}
{phang2}{cmd:. gen byte sel1 = (ldlcp2 < 1e-8)}{p_end}

{pstd}Unweighted median estimator{p_end}
{phang2}{cmd:. mrmedian chdbeta chdse ldlcbeta ldlcse if sel1}{p_end}

{pstd}Weighted median estimator{p_end}
{phang2}{cmd:. mrmedian chdbeta chdse ldlcbeta ldlcse if sel1, }
{cmd: weighted}{p_end}

{pstd}Penalized weighted median estimator{p_end}
{phang2}{cmd:. mrmedian chdbeta chdse ldlcbeta ldlcse if sel1, }
{cmd: penweighted}{p_end}

{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mrmedian} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(k)}}number of instruments{p_end}

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

{marker AP2009}{...}
{phang}
Bowden J, Davey Smith G, Haycock PC, Burgess S. 2016. 
Consistent estimation in Mendelian randomization with some invalid instruments
 using a weighted median estimator. Genetic Epidemiology. 
DOI: 10.1002/gepi.21965
{p_end}

{phang}
Do et al., 2013. Common variants associated with plasma triglycerides and risk
 for coronary artery disease. Nature Genetics. 45, 1345–1352. DOI: 
10.1038/ng.2795
{p_end}
