          Title

               mrmedianobs -- Weighted median of instrumental variable estimates

          Syntax

                  mrmedianobs depvar [varlist1] (varname_endog = varlist_ivs) [if] [in] [, options]

              options               Description
              ----------------------------------------------------------------------------------------------
                all                 report percentile and bias corrected confidence intervals
                level(#)            set confidence level; default is level(95)
                obsboot             obtain standard error by bootstrapping at observation level
                penweighted         penalized weighted estimator
                reps(#)             number of bootstrap replications to obtain standard error
                seed(#)             seed for random number generator for bootstrapping to obtain standard
                                      error
                weighted            weighted estimator

          Description

              mrmedianobs performs unweighted, weighted, and penalized IV estimator on observation level
              data (Bowden et al., 2016).

                   depvar          outcome variable
                   varlist1        covariates to adjust for
                   varname_endog   exposure/treatment received/endogenous variable
                   varlist_ivs     instrumental variables

          Options

              all report percentile and bias corrected bootstrap confidence interval limits (only applies to
                  observation level bootstrapping with obsboot).

              level(#); see [R] estimation options.

              obsboot obtain bootstrap standard error by bootstrapping at the observation level.

              reps(#) specifies the number of bootstrap replications for obtaining the standard error. The
                  default is 50 replications.

              seed(#) specifies the initial value of the random-number seed.  The default is the current
                  random-number seed. Specifying seed(#) is the same as typing set seed # before issuing the
                  command; see set_seed.

              weighted use weights.

              penweighted use penalized weights.


          Examples

              Simulated test dataset.

              Setup
                  . use https://raw.github.com/remlapmot/mrrobust/master/mrmedianobs_testdata, clear

              Unweighted median estimator
                  . mrmedianobs y (x = z1-z20)

              Weighted median estimator
                  . mrmedianobs y (x = z1-z20), weighted

              Penalized weighted median estimator
                  . mrmedianobs y (x = z1-z20), penweighted

              Unweighted median estimator with percentile CI limits of observation level bootstrapping
                  . mrmedianobs y (x = z1-z20), obsboot all


          Stored results

              mrmedian stores the following in e():

              Scalars        
                e(k)                number of instruments
                e(N)                number of observations
                e(reps)             number of (bootstrap) replications

              Macros         
                e(cmd)              mrmedianobs
                e(cmdline)          command as typed

              Matrices       
                e(b)                coefficient vector
                e(V)                variance-covariance matrix of the estimates

          References

              Bowden J, Davey Smith G, Haycock PC, Burgess S.  Consistent estimation in Mendelian
                  randomization with some invalid instruments using a weighted median estimator. Genetic
                  Epidemiology, 2016, 40, 4, 304-314.  DOI


          Author

              Tom Palmer, MRC Integrative Epidemiology Unit and Population Health Sciences, University of
                  Bristol, UK. tom.palmer@bristol.ac.uk.

              If you find any bugs or have questions please send me an email or create an issue on the
                  GitHub repo: https://github.com/remlapmot/mrrobust/issues
