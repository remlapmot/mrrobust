{smcl}
{* *! version 0.1.0  24jun2020 Tom Palmer}{...}
{vieweralsosee "mrrobust" "help mrrobust"}{...}
{viewerjumpto "Syntax" "mrmvegger##syntax"}{...}
{viewerjumpto "Description" "mrmvegger##description"}{...}
{viewerjumpto "Options" "mrmvegger##options"}{...}
{viewerjumpto "Examples" "mrmvegger##examples"}{...}
{viewerjumpto "Stored results" "mrmvegger##results"}{...}
{viewerjumpto "References" "mrmvegger##references"}{...}
{viewerjumpto "Author" "mrmvegger##author"}{...}
{title:Title}

{p 5}
{bf:mrmvegger} {hline 2} Multivariable MR-Egger regression (MVMR-Egger)
{p_end}

{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt mrmvegger} {var:_gd} {var:_gp1} [{var:_gp2} ...] [{it:aweight}] {ifin} 
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt orient:(#)}}orient the data wrt to the phenotype which corresponds with the #th genotype-phenotype (SNP-exposure) association variable in the varlist (default is 1){p_end}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt tdist:}}use t-distribution for Wald test and CI limits{p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:mrmvegger} performs multivariable MR-Egger regression. 
For further information see {help mrmvegger##rees:Rees et al. (2017)}.

{pstd}
By default multiplicative random effect standard errors are reported. 
However, if the residual variance is found to be less than 1 the model 
is refitted with this constrained to 1.

{pstd}
{var:_gd} variable containing the genotype-disease (SNP-outcome) association estimates.

{pstd}
{var:_gp#} variable containing the #th genotype-phenotype (SNP-exposure) association estimates.

{pstd}
For the analytic weights you need to specify the inverse of the genotype-disease (SNP-outcome) standard errors squared, i.e. aw=1/(gdse^2).

{marker options}{...}
{title:Options}

{phang}
{opt orient(#)} specifies which phenotype to orient the data to. The default is 1, i.e. the phenotype in the first genotype-phenotype (SNP-exposure) variable in the varlist.

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] estimation options}.

{phang}
{opt tdist} specifies using the t-distribution, instead of the normal 
distribution, for calculating the Wald test and the confidence interval limits.

{marker examples}{...}
{title:Examples}

{pstd}Using the data provided by {help mrmvegger##do:Do et al. (2013)}.{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:.} {stata "use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear"}{p_end}

{pstd}Select observations ({it:p}-value with LDL-C < 10^-8){p_end}
{phang2}{cmd:.} {stata "gen byte sel1 = (ldlcp2 < 1e-8)"}{p_end}

{pstd}MVMR-Egger regression{p_end}
{phang2}{cmd:.} {stata "mrmvegger chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1"}{p_end}

{pstd}Orient wrt HDL-C instead of LDL-C{p_end}
{phang2}{cmd:.} {stata "mrmvegger chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, orient(2)"}{p_end}

{pstd}Orient wrt triglycerides instead of LDL-C{p_end}
{phang2}{cmd:.} {stata "mrmvegger chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, orient(3)"}{p_end}

{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mrmvegger} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom (with {cmd:tdist} option){p_end}
{synopt:{cmd:e(N)}}Number of genotypes{p_end}
{synopt:{cmd:e(Np)}}Number of phenotypes{p_end}
{synopt:{cmd:e(phi)}}Scale parameter (root mean squared error){p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}Command name{p_end}
{synopt:{cmd:e(cmdline)}}Command issued{p_end}
{synopt:{cmd:e(orientvar)}}Genotype-phenotype (SNP-exposure) association variable the model is oriented wrt{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimates{p_end}

{pstd}
{cmd:mrmvegger} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(table)}}Coefficient table with rownames: b, se, z, pvalue, ll, ul, df, crit, eform{p_end}

{marker references}{...}
{title:References}

{marker do}{...}
{phang}
Do et al., 2013. Common variants associated with plasma triglycerides and risk
 for coronary artery disease. Nature Genetics. 45, 1345–1352. 
{browse "https://dx.doi.org/10.1038/ng.2795":DOI}
{p_end}

{marker rees}{...}
{phang}
Rees J, Wood A, Burgess S. Extending the MR-Egger method for multivariable Mendelian 
randomization to correct for both measured and unmeasured pleiotropy. 
Statistics in Medicine, 2017, 36, 29, 4705-4718.
{browse "https://dx.doi.org/10.1002/sim.7492":DOI}
{p_end}

{marker author}{...}
{title:Author}

INCLUDE help mrrobust-author
