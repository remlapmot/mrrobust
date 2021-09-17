{smcl}
{* *! version 0.1.0  16jun2016 Tom Palmer}{...}
{vieweralsosee "mrrobust" "help mrrobust"}{...}
{viewerjumpto "Syntax" "mrforest##syntax"}{...}
{viewerjumpto "Description" "mrforest##description"}{...}
{viewerjumpto "Examples" "mrforest##examples"}{...}
{viewerjumpto "References" "mrforest##references"}{...}
{viewerjumpto "Author" "mrforest##author"}{...}
{title:Title}

{p 5}
{bf:mrforest} {hline 2} Forest plot for MR-Egger type models
{p_end}

{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:mrforest} {var:_gd} {var:_gdse} {var:_gp} {var:_gpse} [{var:_cov}] {ifin} 
[{cmd:,} {it:options}]

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{synopt :{opt astext:(#)}}Percentage of plot taken up by areas for text - some trial and error may be required{p_end}
{synopt :{opt effect:(string)}}Label for statistics column; default is Estimate{p_end}
{p2col:{cmd:ivid(}{varname}{cmd:)}}Variable to label genotypes, usually containing RSIDs{p_end}
{synopt :{opt ividlabel:(string)}}Label for genotypes; default is Genotypes{p_end}
{synopt :{opt ivwlabel:(string)}}Label for IVW model; default is IVW{p_end}
{p2col:{cmd:gsort(}{it:string}{cmd:)}}how to sort the estimates, if specified must be one of; ascending, descending, or unsorted; default is ascending{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is
       {cmd:level(95)}{p_end}
{synopt :{opt mreggerlabel:(string)}}Label for MR-Egger model; default is MR-Egger{p_end}
{synopt :{opt mrmedianlabel:(string)}}Label for median model; default is Median{p_end}
{synopt :{opt mrmodallabel:(string)}}Label for modal model; default is Modal{p_end}
{synopt :{opt models:(#)}}number of models to show (1 IVW, 2 & MR-Egger, 3 & Median, 4 & Modal); default is 2{p_end}
{synopt :{opt modelslabel:(string)}}Label for models; default is Summary{p_end}
{synopt :{opt modelsonly:}}Only show model estimates on plot{p_end}
{synopt :{opt nonote:}}Suppress note reporting I^2_GX{p_end}
{synopt :{opt nostats:}}Suppress the statistics column{p_end}
{synopt :{opt texts:ize(#)}}Scaling factor for text on plot. I have tried to use sensible numbers here but some trial and error may be required{p_end}
{synopt :{opt zcis:}}Use normal distribution CI limits (for IVW and MR-Egger){p_end}

{p2col:Options passed to other commands:}{p_end}
{p2col:{cmd:ivwopts(}{it:string}{cmd:)}}options for IVW estimate from {cmd:mregger, ivw fe}{p_end}
{p2col:{cmd:mreggeropts(}{it:string}{cmd:)}}options for MR-Egger estimate from {help mregger}{p_end}
{p2col:{cmd:mrivestopts(}{it:string}{cmd:)}}options for {help mrivests} used to generate genotype specific ratio estimates and SEs{p_end}
{p2col:{cmd:mrmedianopts(}{it:string}{cmd:)}}options for median estimate from {help mrmedian}{p_end}
{p2col:{cmd:mrmodal(}{it:string}{cmd:)}}options for modal estimate from {help mrmodal}{p_end}
{p2col:{cmd:nofe}}Remove {cmd:fe} option (fixed effect SE) from the IVW fit{p_end}

{p2col:{cmd:*}}Other options passed to the {help metan}{p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:mrforest} plots a forest plot for MR-Egger type models. 
It is really a wrapper program for a call to {help metan} 
({help mrforest##harris:Harris et al., 2008}), which must be installed.

{pstd}
If you do not already have {cmd:metan}, it can be installed by running: {cmd:ssc install metan}.

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

{pstd}
{var:_cov} is a variable containing the covariances between 
the genotype-disease (SNP-outcome) and genotype-phenotype (SNP-exposure) associations.


{marker examples}{...}
{title:Examples}

{pstd}Using the data provided by {help mrforest##do:Do et al. (2013)} recreate 
{help mrforest##bowden:Bowden et al. (2016)} Figure 4, 
LDL-c "All genetic variants" (plot in row 2, column 1).{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:.} {stata "use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear"}{p_end}

{pstd}Select observations ({it:p}-value with exposure < 10^-8){p_end}
{phang2}{cmd:.} {stata "gen byte sel1 = (ldlcp2 < 1e-8)"}{p_end}

{pstd}Forest plot of genotype specific IV estimates and IVW and MR-Egger estimates, labelling the genotypes with their RSID.{p_end}
{phang2}{cmd:.} {stata "mrforest chdbeta chdse ldlcbeta ldlcse if sel1==1, ivid(rsid)"}{p_end}

{pstd}Having seen the first plot we can now define nicer {it:x}-axis labels.{p_end}
{phang2}{cmd:.} {stata "mrforest chdbeta chdse ldlcbeta ldlcse if sel1==1, ivid(rsid) xlabel(-5,-4,-3,-2,-1,0,1,2,3,4,5)"}{p_end}

{pstd}Removing the column of estimates from the plot, and sorting in descending order of the IV estimates.{p_end}
{phang2}{cmd:.} {stata "mrforest chdbeta chdse ldlcbeta ldlcse if sel1==1, ivid(rsid) nostats gsort(descending)"}{p_end}

{pstd}Showing all 4 models and modifying some labels.{p_end}
{phang2}{cmd:.} {stata "mrforest chdbeta chdse ldlcbeta ldlcse if sel1==1, ivid(rsid) models(4) modelslabel(All genotypes)"}{p_end}

{pstd}If you have data which require more than 2 decimal places, use {cmd:metan}'s undocumented 
{cmd:dp} option, e.g. for 4 decimal places specify {cmd:dp(4)}{p_end}
{phang2}{cmd:.} {stata "gen chdbeta2 = chdbeta / 100"}{p_end}
{phang2}{cmd:.} {stata "gen chdse2 = chdse / 100"}{p_end}
{phang2}{cmd:.} {stata "mrforest chdbeta chdse ldlcbeta ldlcse if sel1==1, ivid(rsid) dp(4)"}{p_end}

{marker references}{...}
{title:References}

{marker bowden}{...}
{phang}
Bowden J, Davey Smith G, Haycock PC, Burgess S. Consistent estimation in 
Mendelian randomization with some invalid instruments using a weighted median 
estimator. Genetic Epidemiology, 2016, 40, 4, 304-314. 
{browse "https://dx.doi.org/10.1002/gepi.21965":DOI}
{p_end}

{marker do}{...}
{phang}
Do et al. Common variants associated with plasma triglycerides and risk
 for coronary artery disease. Nature Genetics, 2013, 45, 1345–1352. 
{browse "https://dx.doi.org/10.1038/ng.2795":DOI}
{p_end}

{marker harris}{...}
{phang}
Harris RJ, Bradburn MJ, Deeks JJ, Harbord RM, Altman DG, Sterne JAC. metan: fixed- and random-effects meta-analysis. 
Stata Journal, 2008, 8, 1, 3-28. {browse "https://www.stata-journal.com/article.html?article=sbe24_2":Link}

{marker author}{...}
{title:Author}

INCLUDE help mrrobust-author
