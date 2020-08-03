          Title

               mrmvegger -- Multivariable MR-Egger regression (MVMR-Egger)

          Syntax

                  mrmvegger varname_gd varname_gp1 [varname_gp2 ...] [aweight] [if] [in] [, options]

              options               Description
              ----------------------------------------------------------------------------------------------
                orient(#)           orient the data wrt to the phenotype which corresponds with the #th
                                      genotype-phenotype association variable in the varlist (default is 1)
                level(#)            set confidence level; default is level(95)
                tdist               use t-distribution for Wald test and CI limits

          Description

              mrmvegger performs multivariable MR-Egger regression.  For further information see Rees et al.
              (2017).

              By default multiplicative random effect standard errors are reported.  However, if the
              residual variance is found to be less than 1 the model is refitted with this constrained to 1.

              varname_gd variable containing the genotype-disease association estimates.

              varname_gp# variable containing the #th genotype-phenotype association estimates.

              For the analytic weights you need to specify the inverse of the genotype-disease standard
              errors squared, i.e. aw=1/(gdse^2).

          Options

              orient(#) specifies which phenotype to orient the data to. The default is 1, i.e. the
                  phenotype in the first genotype-phenotype variable in the varlist.

              level(#); see [R] estimation options.

              tdist specifies using the t-distribution, instead of the normal distribution, for calculating
                  the Wald test and the confidence interval limits.

          Examples

              Using the data provided by Do et al. (2013).

              Setup
                  . use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear

              Select observations (p-value with LDL-C < 10^-8)
                  . gen byte sel1 = (ldlcp2 < 1e-8)

              MVMR-Egger regression
                  . mrmvegger chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1

              Orient wrt HDL-C instead of LDL-C
                  . mrmvegger chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, orient(2)

              Orient wrt triglycerides instead of LDL-C
                  . mrmvegger chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, orient(3)

          Stored results

              mrmvegger stores the following in e():

              Scalars        
                e(df_r)             residual degrees of freedom (with tdist option)
                e(N)                Number of genotypes
                e(Np)               Number of phenotypes
                e(phi)              Scale parameter (root mean squared error)

              Macros         
                e(cmd)              Command name
                e(cmdline)          Command issued
                e(orientvar)        Genotype-phenotype association variable the model is oriented wrt

              Matrices       
                e(b)                coefficient vector
                e(V)                variance-covariance matrix of the estimates

              mrmvegger stores the following in r():

              Matrices       
                r(table)            Coefficient table with rownames: b, se, z, pvalue, ll, ul, df, crit,
                                      eform

          References

              Do et al., 2013. Common variants associated with plasma triglycerides and risk for coronary
                  artery disease. Nature Genetics. 45, 1345–1352.  DOI

              Rees J, Wood A, Burgess S. Extending the MR-Egger method for multivariable Mendelian
                  randomization to correct for both measured and unmeasured pleiotropy.  Statistics in
                  Medicine, 2017, 36, 29, 4705-4718.  DOI


          Author

              Tom Palmer, MRC Integrative Epidemiology Unit and Population Health Sciences, University of
                  Bristol, UK. tom.palmer@bristol.ac.uk.

              If you find any bugs or have questions please send me an email or create an issue on the
                  GitHub repo: https://github.com/remlapmot/mrrobust/issues
