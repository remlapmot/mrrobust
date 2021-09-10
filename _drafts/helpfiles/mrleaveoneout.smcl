{smcl}
{* *! version 0.1.0  31jul2020 Tom Palmer}{...}
{vieweralsosee "mrrobust" "help mrrobust"}{...}
{viewerjumpto "Syntax" "mrleaveoneout##syntax"}{...}
{viewerjumpto "Description" "mrleaveoneout##description"}{...}
{viewerjumpto "Options" "mrleaveoneout##options"}{...}
{viewerjumpto "Examples" "mrleaveoneout##examples"}{...}
{viewerjumpto "References" "mrleaveoneout##references"}{...}
{viewerjumpto "Author" "mrleaveoneout##author"}{...}
{title:Title}

{p 5}
{bf:mrleaveoneout} {hline 2} Leave one (genotype) out (at a time) analysis
{p_end}

{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:mrleaveoneout} {var:_gd} {var:_gp} {ifin}{cmd:,} {cmd:gyse(}{varname}{cmd:)} [{it:options}]

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{synopt :{opt astext:(#)}}Percentage of plot taken up by areas for text - some trial and error may be required{p_end}
{p2col:{cmd:genotype(}{varname}{cmd:)}}Variable to label genotypes, usually containing RSIDs{p_end}
{p2col:{cmd:gxse(}{varname}{cmd:)}}Variable with genotype-phenotype (SNP-exposure) standard errors (if required by method){p_end}
{p2col:{cmd:gyse(}{varname}{cmd:)}}Variable with genotype-disease (SNP-outcome) standard errors{p_end}
{synopt :{opt metanopts(string)}}Options passed to {cmd:metan} for the plot{p_end}
{synopt :{opt m:ethod(string)}}The method fitted for the analysis{p_end}
{synopt :{opt noplot}}Suppresses the plot{p_end}
{synopt :{opt noprint}}Suppresses the display of each leave one out model{p_end}
{synopt :{opt texts:ize(#)}}Scaling factor for text on plot. I have tried to use sensible numbers here but some trial and error may be required{p_end}
{p2col:{cmd:*}}Other options passed to the analysis method command{p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:mrleaveoneout} performs leave one out analysis, in which each genotype is omitted in turn from the analysis. 
A plot of the estimates is shown by default.

{pstd}
For multiple exposure models such as MVMR and MVMR-Egger the estimate is 
collected for the first phenotype.

{pstd}
{var:_gd} is a variable containing the genotype-disease (SNP-outcome) association estimates.

{pstd}
{var:_gp} is a variable containing the genotype-phenotype (SNP-exposure) association 
estimates.

{marker options}{...}
{title:Options}

{phang}{opt m:ethod(string)} Specifies the method used for the analysis. 
Must be one of ivw, egger, mregger, mrivw, median, mrmedian, mrmodal, 
modal, mode, mvmr, mvivw, mvegger.

{marker examples}{...}
{title:Examples}

{pstd}Using the data provided by {help mrforest##do:Do et al. (2013)}.{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:.} {stata "use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear"}{p_end}

{pstd}Select observations ({it:p}-value with exposure < 10^-8){p_end}
{phang2}{cmd:.} {stata "gen byte sel2 = (ldlcp2 < 1e-25)"}{p_end}

{pstd}Perform leave one out analysis using the IVW estimator{p_end}
{phang2}{cmd:.} {stata "mrleaveoneout chdbeta ldlcbeta if sel2==1, gyse(chdse) genotype(rsid)"}{p_end}

{pstd}Leave one out analysis using MVMR (collecting the estimate for LDL-c){p_end}
{phang2}{cmd:.} {stata "mrleaveoneout chdbeta ldlcbeta hdlcbeta tgbeta if sel2==1, method(mvmr) gyse(chdse) genotype(rsid)"}{p_end}

{pstd}If you have data which require more than 2 decimal places, use {cmd:metan}'s undocumented 
{cmd:dp} option, e.g. for 4 decimal places specify {cmd:dp(4)}{p_end}
{phang2}{cmd:.} {stata "gen chdbeta2 = chdbeta / 100"}{p_end}
{phang2}{cmd:.} {stata "gen chdse2 = chdse / 100"}{p_end}
{phang2}{cmd:.} {stata "mrleaveoneout chdbeta2 ldlcbeta if sel2==1, gyse(chdse2) genotype(rsid) metanopts(dp(4))"}{p_end}

{marker references}{...}
{title:References}

{marker do}{...}
{phang}
Do et al. Common variants associated with plasma triglycerides and risk
 for coronary artery disease. Nature Genetics, 2013, 45, 1345–1352. 
{browse "https://dx.doi.org/10.1038/ng.2795":DOI}{p_end}

{marker author}
{title:Author}

{phang}Tom Palmer, MRC Integrative Epidemiology Unit and Population Health Sciences, University of Bristol, UK. {browse "mailto:tom.palmer@bristol.ac.uk":tom.palmer@bristol.ac.uk}.{p_end}

{phang}If you find any bugs or have questions please send me an email or create an issue on the GitHub repo: {browse "https://github.com/remlapmot/mrrobust/issues"} {p_end}
