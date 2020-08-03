          Title

               mreggersimex -- SIMEX for the MR-Egger estimator

          Syntax

                  mreggersimex varname_gd varname_gp [aweight] [if] [in] [, options]

              options                 Description
              ----------------------------------------------------------------------------------------------
                mreggeropts           Options for mregger
                bsopts                Options for bootstrap
                gxse(varname)         Variable containg genotype-phenotype SEs
                noboot                Do not perform bootstrapping for SEs
                nodraw                Do not draw SIMEX plot
                reps(#)               No. bootstrap replications
                seed(#)               Seed for random number generator, specify for reproducible results
                simreps(#)            No. simulation replications

          Description

              mreggersimex performs the simulation extrapolation (SIMEX) algorithm (Cook et al., 1995,
              Hardin et al., 2003) on mregger using the commonly applied quadratic extrapolation (Bowden et
              al., 2016).

              varname_gd variable containing the genotype-disease association estimates.

              varname_gp variable containing the genotype-phenotype association estimates.

              For the analytic weights you need to specify the inverse of the genotype-disease SEs squared,
              i.e. aw=1/(gdse^2).

          Examples

              Using the data provided by Do et al. (2013) recreate Bowden et el. (2016), Figure 4, LDL-c
              "All genetic variants" (plot in row 2, column 1).

              Setup
                  . use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear

              Select observations (p-value with exposure < 10^-8)
                  . gen byte sel1 = (ldlcp2 < 1e-8)

              SIMEX using default settings
                  . mreggersimex chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, gxse(ldlcse) seed(12345)

              Suppressing the bootstrap SEs
                  . mreggersimex chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, gxse(ldlcse) seed(12345) noboot

              Suppressing the bootstrap SEs and the plot
                  . mreggersimex chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, gxse(ldlcse) seed(12345) noboot
                      nodraw

          References

              Bowden J, Del Greco FM, Minelli C, Davey Smith G, Sheehan NA, Thompson JR.  Assessing the
                  suitability of summary data for two-sample Mendelian randomization analyses using MR-Egger
                  regression: the role of the I2 statistic.  International Journal of Epidemiology, 2016,
                  45, 6, 1961-1974.  DOI

              Bowden J, Davey Smith G, Haycock PC, Burgess S.  Consistent estimation in Mendelian
                  randomization with some invalid instruments using a weighted median estimator. Genetic
                  Epidemiology, 2016, 40, 4, 304-314.  DOI

              Cook J and Stefanski LA. A simulation extrapolation method for parametric measurement error
                  models. Journal of the American Statistical Association, 1995, 85, 652-663.  Link

              Do R et al. Common variants associated with plasma triglycerides and risk for coronary artery
                  disease. Nature Genetics, 2013, 45, 1345–1352. DOI:  DOI

              Hardin JW, Schmiediche H, Carroll RJ. The simulation extrapolation method for fitting linear
                  models with additive measurement error. Stata Journal.  2003, 3, 4, 373-385.  DOI


          Author

              Tom Palmer, MRC Integrative Epidemiology Unit and Population Health Sciences, University of
                  Bristol, UK. tom.palmer@bristol.ac.uk.

              If you find any bugs or have questions please send me an email or create an issue on the
                  GitHub repo: https://github.com/remlapmot/mrrobust/issues
