          Title

               mrmodal -- Modal estimator for summary data

          Syntax

                  mrmodal varname_gd varname_gdse varname_gp varname_gpse [if] [in] [, options]

              options               Description
              ----------------------------------------------------------------------------------------------
                level(#)            set confidence level; default is level(95)
                nome                NOME assumption
                nosave              Do not save density and vector of IV estimates in Mata
                phi(#)              value of phi (for bandwidth)
                reps(#)             number of bootstrap replications to obtain standard error
                seed(#)             seed for random number generator for bootstrapping to obtain standard
                                      error
                weighted            weighted IV estimates

          Description

              mrmodal implements the zero modal estimator of Hartwig et al. (2017) for use with summary
              level data (i.e. reported genotype-disease and phenotype-disease association estimates and
              their standard errors for individual genotypes).

              Standard errors are obtained by parametric bootstrapping.

              varname_gd is a variable containing the genotype-disease association estimates.

              varname_gdse is a variable containing the genotype-disease association estimate standard
              errors.

              varname_gp is a variable containing the genotype-phenotype association estimates.

              varname_gpse is a variable containing the genotype-phenotype association estimate standard
              errors.

          Options

              level(#); see [R] estimation options.

              nome specifies the NOME (no measurement error in the genotype-phenotype associations)
                  assumption.

              nosave specifies that the density of the IV estimates and column vector of IV estimates should
                  not be saved in Mata. If not specified these are saved in Mata as mrmodal_densityiv and
                  mrmodal_g respectively.

              phi(#) specifies the parameter phi which is used in the calculation of the bandwidth for the
                  density estimation. Default is phi = 1, other values commonly chosen are 0.25 and 0.5.

              reps(#) specifies the number of bootstrap replications for obtaining the standard error. The
                  default is 1000 replications.

              seed(#) specifies the initial value of the random-number seed.  The default is the current
                  random-number seed. Specifying seed(#) is the same as typing set seed # before issuing the
                  command; see set_seed.

              weighted weight the instrumental variable estimates.

          Examples

              Using the data provided by Do et al. (2013).

              Setup
                  . use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear

              Select observations (p-value with exposure < 10^-8)
                  . gen byte sel1 = (ldlcp2 < 1e-8)

              Investigate what is a good value of phi to use (we want a smooth density plot)
                  . mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1

              Simple mode estimator
                  . mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1

              Simple mode estimator with reproducible standard error
                  . mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345)

              Weighted mode estimator
                  . mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted

              Simple mode estimator with NOME assumption
                  . mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, nome

              Weighted mode estimator with NOME assumption
                  . mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted nome

          Stored results

              mrmodal stores the following in e():

              Scalars        
                e(k)                number of instruments
                e(phi)              value of phi
                e(reps)             number of (bootstrap) replications

              Macros         
                e(cmd)              mrmodal
                e(cmdline)          command as typed

              Matrices       
                e(b)                coefficient vector
                e(V)                variance-covariance matrix of the estimates

          References

              Do et al. Common variants associated with plasma triglycerides and risk for coronary artery
                  disease. Nature Genetics, 2013, 45, 1345–1352.  DOI

              Hartwig FP, Davey Smith G, Bowden J.  Robust inference in two-sample Mendelian randomisation
                  via the zero modal pleiotropy assumption. International Journal of Epidemiology, 2017, 46,
                  6, 1985-1998.  DOI


          Author

              Tom Palmer, MRC Integrative Epidemiology Unit and Population Health Sciences, University of
                  Bristol, UK. tom.palmer@bristol.ac.uk.

              If you find any bugs or have questions please send me an email or create an issue on the
                  GitHub repo: https://github.com/remlapmot/mrrobust/issues
