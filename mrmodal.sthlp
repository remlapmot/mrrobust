{smcl}
{* *! version 0.1.0  2jun2017 Tom Palmer}{...}
{vieweralsosee "mrrobust" "help mrrobust"}{...}
{viewerjumpto "Syntax" "mrmodal##syntax"}{...}
{viewerjumpto "Description" "mrmodal##description"}{...}
{viewerjumpto "Options" "mrmodal##options"}{...}
{viewerjumpto "Examples" "mrmodal##examples"}{...}
{viewerjumpto "Stored results" "mrmodal##results"}{...}
{viewerjumpto "References" "mrmodal##references"}{...}
{viewerjumpto "Author" "mrmodal##author"}{...}
{title:Title}

{p 5}
{bf:mrmodal} {hline 2} Modal estimator for summary data
{p_end}

{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt mrmodal} {var:_gd} {var:_gdse} {var:_gp} {var:_gpse} {ifin} 
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nome:}}NOME assumption{p_end}
{synopt :{opt nosave:}}Do not save density and vector of IV estimates in Mata{p_end}
{synopt :{opt phi:(#)}}value of phi (for bandwidth){p_end}
{synopt :{opt reps:(#)}}number of bootstrap replications to obtain standard error{p_end}
{synopt :{opt seed:(#)}}seed for random number generator for bootstrapping to 
obtain standard error{p_end}
{synopt :{opt weight:ed}}weighted IV estimates{p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:mrmodal} implements the zero modal estimator of Hartwig et al. (2017) 
for use with summary level 
data (i.e. reported genotype-disease and phenotype-disease 
association estimates and their standard errors for individual genotypes).

{pstd}
As per the working paper, standard errors are obtained by parametric 
bootstrap.

{pstd}
See {browse "http://dx.doi.org/10.1101/126102":Hartwig et al., bioRxiv, 2017}, for more information.

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

{marker options}{...}
{title:Options}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] estimation options}.

{phang}
{opt nome} specifies the NOME (no measurement error in the genotype-phenotype 
associations) assumption.

{phang}
{opt nosave} specifies that the density of the IV estimates and column vector 
of IV estimates should not be saved in Mata. If not specified these are saved 
in Mata as mrmodal_densityiv and mrmodal_g respectively.

{phang}
{opt phi(#)} specifies the parameter phi which is used in the calculation of 
the bandwidth for the density estimation. Default is phi = 1, other values 
commonly chosen are 0.25 and 0.5.

{phang}
{opt reps(#)} specifies the number of bootstrap replications for obtaining the
 standard error. The default is 1000 replications.

{phang}
{opt seed(#)} specifies the initial value of the random-number seed. 
The default is the current random-number seed. Specifying {opt seed(#)} is the
 same as typing {cmd:set seed} {it:#} before issuing the command; 
see {helpb set_seed}.

{phang}
{opt weighted} weight the instrumental variable estimates.

{marker examples}{...}
{title:Examples}

{pstd}Using the data provided by Do et al., Nat Gen, 2013.{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:.} {stata "use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear"}{p_end}

{pstd}Select observations ({it:p}-value with exposure < 10^-8){p_end}
{phang2}{cmd:.} {stata "gen byte sel1 = (ldlcp2 < 1e-8)"}{p_end}

{pstd}Investigate what is a good value of phi to use (we want a smooth density plot){p_end}
{phang2}{cmd:.} {stata "mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1"}{p_end}

{pstd}Simple mode estimator{p_end}
{phang2}{cmd:.} {stata "mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1"}{p_end}

{pstd}Simple mode estimator with reproducible standard error{p_end}
{phang2}{cmd:.} {stata "mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345)"}{p_end}

{pstd}Weighted mode estimator{p_end}
{phang2}{cmd:.} {stata "mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted"}{p_end}

{pstd}Simple mode estimator with NOME assumption{p_end}
{phang2}{cmd:.} {stata "mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, nome"}{p_end}

{pstd}Weighted mode estimator with NOME assumption{p_end}
{phang2}{cmd:.} {stata "mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted nome"}{p_end}

{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mrmodal} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(k)}}number of instruments{p_end}
{synopt:{cmd:e(phi)}}value of phi{p_end}
{synopt:{cmd:e(reps)}}number of (bootstrap) replications{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:mrmodal}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimates{p_end}

{marker references}{...}
{title:References}

{marker hartwig}{...}
{phang}
Hartwig FP, Davey Smith G, Bowden J. 2017. 
Robust inference in two-sample Mendelian randomisation via the zero modal 
pleiotropy assumption. bioRxiv. 
DOI: {browse "http://dx.doi.org/10.1101/126102"}

{marker author}
{title:Author}

{phang}Tom Palmer, MRC Integrative Epidemiology Unit and Population Health Sciences, University of Bristol, UK. {browse "mailto:tom.palmer@bristol.ac.uk":tom.palmer@bristol.ac.uk}.{p_end}

{phang}If you find any bugs or have questions please send me an email or create an issue on the GitHub repo: {browse "https://github.com/remlapmot/mrrobust/issues"} {p_end}
