          Title

               mrmvivw/mvivw/mvmr -- Multivariable inverse variance weighted regression (MVIVW)

          Syntax

                  mrmvivw/mvivw/mvmr varname_gd varname_gp1 [varname_gp2 ...] [aweight] [if] [in] [,
                          options]

              options               Description
              ----------------------------------------------------------------------------------------------
                fe                  fixed effect standard errors (default is multiplicative random effect)
                gxse(varlist)       varlist of genotype-phenotype standard errors
                level(#)            set confidence level; default is level(95)
                tdist               use t-distribution for Wald test and CI limits

          Description

              mrmvivw/mvivw/mvmr performs multivariable inverse-variance weighted (IVW) regression using
              summary level data.  See  Burgess et al. (2015) for more information.

              varname_gd variable containing the genotype-disease association estimates.

              varname_gp# variable containing the #th genotype-phenotype association estimates.

              For the analytic weights you need to specify the inverse of the genotype-disease standard
              errors squared, i.e. aw=1/(gdse^2).

          Options

              fe specifies fixed effect standard errors (i.e. variance of residuals constrained to 1 as in
                  fixed effect meta-analysis models). The default is multiplicative random effect standard
                  errors in which case the variance of the residuals is unconstrained and the square root of
                  the estimated residual variance is displayed (Residual standard error). If the residual
                  variance is found to be less than 1 an error message is shown and the model is refitted
                  with it constrained to 1.

              gxse(varlist) specifies a varlist of genotype-phenotype standard errors.  These should be in
                  the same order as the genotype-phenotype variables in the main varlist.  When this option
                  is specified the Q_A statistic for instrument validity is calculated.  When this is
                  specified and there are two or more phenotypes conditional F statistics for instrument
                  strength are calculated.  See Sanderson et al. (2019) and Sanderson et al. (2020) for more
                  information.

              level(#); see [R] estimation options.

              tdist specifies using the t-distribution, instead of the normal distribution, for calculating
                  the Wald test and the confidence interval limits.

          Examples

              Using the data provided by Do et al. (2013).

              Setup
                  . use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear

              Select observations (p-value with LDL-C < 10^-8)
                  . gen byte sel1 = (ldlcp2 < 1e-8)

              Fit MVMR/MVIVW
                  . mrmvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1

                  . mvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1

                  . mvmr chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1

              Report Q_A statistic and conditional F-statistics
                  . mrmvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, gxse(ldlcse hdlcse
                      tgse)

          Stored results

              mrmvivw/mvivw/mvmr stores the following in e():

              Scalars        
                e(df_r)             residual degrees of freedom (with tdist option)
                e(N)                Number of genotypes
                e(Np)               Number of phenotypes
                e(phi)              Scale parameter (root mean squared error)
              If gxse() specified
                e(Qa)               Q_A statistic
                e(Qadf)             Degrees of freedom of Q_A statistic
                e(Qap)              P-value for Q_A chi-squared test

              Macros         
                e(cmd)              Command name
                e(cmdline)          Command issued
                e(setype)           Standard error type

              Matrices       
                e(b)                coefficient vector
                e(V)                variance-covariance matrix of the estimates
              If gxse() specified
                e(Fx)               vector of conditional F-statistics
                e(Qx)               vector of Q_x statistics

              mrmvivw/mvivw/mvmr stores the following in r():

              Matrices       
                r(table)            Coefficient table with rownames: b, se, z, pvalue, ll, ul, df, crit,
                                      eform

          References

              Burgess S, Dudbridge F, Thompson SG. Multivariable Mendelian randomization:  the use of
                  pleiotropic genetic variants to estimate causal effects.  American Journal of
                  Epidemiology, 2015, 181, 4, 251–260.  DOI

              Do et al., 2013. Common variants associated with plasma triglycerides and risk for coronary
                  artery disease. Nature Genetics. 45, 1345–1352.  DOI

              Sanderson E, Davey Smith G, Windmeijer F, Bowden J. An examination of multivariable Mendelian
                  randomization in the single-sample and two-sample summary data settings. International
                  Journal of Epidemiology, 2019, 48, 3, 713-727.  DOI

              Sanderson E, Spiller W, Bowden J. Testing and correcting for weak and pleiotropic instruments
                  in two-sample multivariable Mendelian randomisation.  bioRxiv preprint, 2020,
                  2020.04.02.021980 DOI


          Author

              Tom Palmer, MRC Integrative Epidemiology Unit and Population Health Sciences, University of
                  Bristol, UK. tom.palmer@bristol.ac.uk.

              If you find any bugs or have questions please send me an email or create an issue on the
                  GitHub repo: https://github.com/remlapmot/mrrobust/issues
