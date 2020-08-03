          Title

               mrratio -- Instrumental variable ratio (Wald) estimator

          Syntax

                  mrratio #gd #gdse #gp [#gpse #cov] [, options]

              options               Description
              ----------------------------------------------------------------------------------------------
                eform               exp() estimate and CI limits
                fieller             CI using Fieller's Theorem
                level(#)            set confidence level; default is level(95)
                nome                NOME assumption

          Description

              mrratio implements the standard instrumental variable ratio (Wald) estimator.

              mrratio can generate confidence interval limits using either a standard error from a Taylor
              series expansion (the default), a standard error using the NOME (no measurement error) in the
              genotype-phenotype association assumption, or using Fieller's Theorem.

              The user needs to have summary level genotype-disease and genotype-phenotype association
              estimates and their standard errors. If assuming NOME the standard error of the
              genotype-phenotype association is not required.

              It is also optional to provide the covariance between the genotype-disease and
              genotype-phenotype estimates. If these are from independent samples then this covariance is
              zero.

              #gd genotype-disease association estimate.

              #gdse standard error of the genotype-disease association estimate.

              #gp genotype-phenotype association estimate.

              #gpse standard error of the genotype-phenotype association estimate.

              #cov covariance between the genotype-disease and the genotype-phenotype estimates.

          Options

              eform specifies reporting the exponentiated ratio estimate and confidence interval limits.

              fieller specifies deriving the confidence interval using Fieller's Theorem.

              level(#); see [R] estimation options.

              nome specifies the NOME (no measurement error in the genotype-phenotype association)
                  assumption.

          Examples

              Hypothetical example
                  . mrratio 1 .5 1 .25

              With NOME assumption
                  . mrratio 1 .5 1 .25, nome

              With NOME assumption
                  . mrratio 1 .5 1, nome

              Exponentiate estimate and CI limits
                  . mrratio 1 .5 1 .25, eform

              CI using Fieller's Theorem
                  . mrratio 1 .5 1 .25, fieller

          Stored results

              mrratio stores the following in e():

              Scalars        
                e(fiellerres)       Result code from the Fieller CI: . fieller not specified; 1 closed CI; 2
                                      union of two intervals; 3 CI is whole real line
                e(level)            level specified in first call to mrratio.

              When fieller specified additional scalars:
                e(lowerci)          lower CI limit
                e(upperci)          upper CI limit

              Macros         
                e(cmd)              mrratio
                e(cmdline)          command as typed

              Matrices       
                e(b)                coefficient vector
                e(V)                variance-covariance matrix of the estimate


          Author

              Tom Palmer, MRC Integrative Epidemiology Unit and Population Health Sciences, University of
                  Bristol, UK. tom.palmer@bristol.ac.uk.

              If you find any bugs or have questions please send me an email or create an issue on the
                  GitHub repo: https://github.com/remlapmot/mrrobust/issues
