{smcl}
{* *! version 0.1.0  19jan2020 Tom Palmer}{...}
{vieweralsosee "mrrobust" "help mrrobust"}{...}
{viewerjumpto "Syntax" "mr##syntax"}{...}
{viewerjumpto "Description" "mr##description"}{...}
{viewerjumpto "Options" "mr##options"}{...}
{viewerjumpto "Examples" "mr##examples"}{...}
{viewerjumpto "Stored results" "mr##results"}{...}
{viewerjumpto "Author" "mr##author"}{...}
{title:Title}

{p 5}
{bf:mr} {hline 2} Mendelian randomization programs
{p_end}

{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt mr} {it:subcommand} ... [{it:aweight}] {ifin} [{cmd:,} {it:options}]

{marker description}{...}
{title:Description}

{pstd}
{cmd:mr} is a simple wrapper to the commands in the {help mrrobust} package.

{pstd}
The {it:subcommand} is specified as the mrrobust program name without its mr prefix, i.e. {cmd:mregger ...} can alternatively be run using the syntax {cmd:mr egger ...}.
 
{marker options}{...}
{title:Options}

{phang}
{cmd:mr} takes the options for the specified subcommand.

{marker examples}{...}
{title:Examples}

{pstd}Using the data provided by Do et al., Nat Gen, 2013 recreate Bowden et 
al., Gen Epi, 2016, Table 4, LDL-c "All genetic variants" estimates.{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:.} {stata "use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear"}{p_end}

{pstd}Select observations ({it:p}-value with exposure < 10^-8){p_end}
{phang2}{cmd:.} {stata "gen byte sel1 = (ldlcp2 < 1e-8)"}{p_end}

{pstd}IVW (with fixed effect standard errors){p_end}
{phang2}{cmd:.} {stata "mr egger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw fe"}{p_end}

{pstd}Scatter plot of MR-Egger model{p_end}
{phang2}{cmd:.} {stata "mr eggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1"}{p_end}

{pstd}Multivariable IVW{p_end}
{phang2}{cmd:.} {stata "mr mvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1"}{p_end}

{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mr} returns the results from the specified subcommand.

{marker author}
{title:Author}

{phang}Tom Palmer, MRC Integrative Epidemiology Unit and Population Health Sciences, University of Bristol, UK. {browse "mailto:tom.palmer@bristol.ac.uk":tom.palmer@bristol.ac.uk}.{p_end}

{phang}If you find any bugs or have questions please send me an email or create an issue on the GitHub repo: {browse "https://github.com/remlapmot/mrrobust/issues"} {p_end}
