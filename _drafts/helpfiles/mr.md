          Title

               mr -- Mendelian randomization programs

          Syntax

                  mr subcommand ... [aweight] [if] [in] [, options]

          Description

              mr is a simple wrapper to the commands in the mrrobust package.

              The subcommand is specified as the mrrobust program name without its mr prefix, i.e. mregger
              ... can alternatively be run using the syntax mr egger ....

          Options

              mr takes the options for the specified subcommand.

          Examples

              Using the data provided by Do et al. (2013) recreate Bowden et al. (2016), Table 4, LDL-c "All
              genetic variants" estimates.

              Setup
                  . use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear

              Select observations (p-value with exposure < 10^-8)
                  . gen byte sel1 = (ldlcp2 < 1e-8)

              IVW (with fixed effect standard errors)
                  . mr egger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw fe

              Scatter plot of MR-Egger model
                  . mr eggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1

              Multivariable IVW
                  . mr mvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1

          Stored results

              mr returns the results from the specified subcommand.


          References

              Bowden J, Davey Smith G, Haycock PC, Burgess S. Consistent estimation in Mendelian
                  randomization with some invalid instruments using a weighted median estimator. Genetic
                  Epidemiology, 2016, 40, 4, 304-314.  DOI

              Do et al., 2013. Common variants associated with plasma triglycerides and risk for coronary
                  artery disease. Nature Genetics. 45, 1345–1352.  DOI


          Author

              Tom Palmer, MRC Integrative Epidemiology Unit and Population Health Sciences, University of
                  Bristol, UK. tom.palmer@bristol.ac.uk.

              If you find any bugs or have questions please send me an email or create an issue on the
                  GitHub repo: https://github.com/remlapmot/mrrobust/issues
