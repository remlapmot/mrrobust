          Title

               mrmodalplot -- Density plot to investigate values of phi in mrmodal

          Syntax

                  mrmodalplot varname_gd varname_gdse varname_gp varname_gpse [if] [in] [, options]

              options               Description
              ----------------------------------------------------------------------------------------------
                lc(optlist)         list of line colors
                lp(optlist)         list of line patterns
                lw(optlist)         list of line widths
                nome                NOME assumption
                phi(numlist)        value/s of phi (for bandwidth), default is .25 .5 1
                reps(#)             number of bootstrap replications to obtain standard error
                seed(#)             seed for random number generator for bootstrapping to obtain standard
                                      error
                weighted            weighted IV estimates
                *                   Other options passed to the twoway plot

          Description

              mrmodalplot plots the density of the IV estimates used in the mrmodal estimator.

              varname_gd is a variable containing the genotype-disease association estimates.

              varname_gdse is a variable containing the genotype-disease association estimate standard
              errors.

              varname_gp is a variable containing the genotype-phenotype association estimates.

              varname_gpse is a variable containing the genotype-phenotype association estimate standard
              errors.

          Examples

              Using the data provided by Do et al. (2013) recreate Bowden et (2016), Figure 4, LDL-c "All
              genetic variants" (plot in row 2, column 1).

              Setup
                  . use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear

              Select observations (p-value with exposure < 10^-8)
                  . gen byte sel1 = (ldlcp2 < 1e-8)

              Densities with phi=.25, .5, 1 and reproducible standard error
                  . mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345)

              Densities with phi=.4, .6, .8, 1 and reproducible standard error
                  . mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, phi(.4(.2)1) seed(12345)

              Lines in grayscale and reproducible standard error
                  . mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, lc(gs10 gs5 gs0) seed(12345)


          References

              Bowden J, Davey Smith G, Haycock PC, Burgess S. Consistent estimation in Mendelian
                  randomization with some invalid instruments using a weighted median estimator. Genetic
                  Epidemiology, 2016, 40, 4, 304-314.  DOI

              Do et al. Common variants associated with plasma triglycerides and risk for coronary artery
                  disease. Nature Genetics, 2013, 45, 1345–1352.  DOI


          Author

              Tom Palmer, MRC Integrative Epidemiology Unit and Population Health Sciences, University of
                  Bristol, UK. tom.palmer@bristol.ac.uk.

              If you find any bugs or have questions please send me an email or create an issue on the
                  GitHub repo: https://github.com/remlapmot/mrrobust/issues
