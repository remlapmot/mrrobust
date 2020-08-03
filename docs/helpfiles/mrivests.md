          Title

               mrivests -- Generate genotype specific instrumental variable ratio (Wald) estimates in a
          dataset

          Syntax

                  mrivests varname_gd varname_gdse varname_gp [varname_gpse varname_cov] [if] [in] [,
                          options]

              options                      Description
              ----------------------------------------------------------------------------------------------
                generate(varlist, replace) Variables to contain IV ests and SEs or CI limits
                *                          options passed to mrratio

          Description

              mrivests calls mrratio to put the instrumental variable ratio (Wald) estimate and its standard
              error in the variables specified.

              varname_gd is a variable containing genotype-disease association estimates.

              varname_gdse is a variable containing the standard errors of the genotype-disease association
              estimates.

              varname_gp is a variable containing genotype-phenotype association estimates.

              varname_gpse is a variable containing the standard errors of the genotype-phenotype
              association estimates.

              varname_cov is a variable containing the covariance between the genotype-disease and the
              genotype-phenotype estimates.

          Options

              generate(varlist, replace) specifies the variables (2 or 3) to contain the IV estimates and
                  their standard errors or confidence interval limits. Specifying replace replaces the
                  values in these variables if they already exist in the dataset.

              * options passed through to mrratio, e.g. nome.

          Examples

              Using the data provided by Do et al. (2013) generate genotype specific estimates for the LDL-c
              phenotype.

              Setup
                  . use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear

              Select observations (p-value with exposure < 10^-8)
                  . gen byte sel1 = (ldlcp2 < 1e-8)

              Generate IV estimates in dataset
                  . mrivests chdbeta chdse ldlcbeta ldlcse if sel1==1, generate(ivest ivse)

              Generate IV estimates with SEs assuming NOME
                  . mrivests chdbeta chdse ldlcbeta if sel1==1, generate(ivest ivse, replace) nome

              Generate IV estimates with CI limits using Fieller's Theorem
                  . drop ivest
                  . mrivests chdbeta chdse ldlcbeta ldlcse if sel1==1, generate(ivest ivcilow ivciupp)
                      fieller

          References

              Do et al., 2013. Common variants associated with plasma triglycerides and risk for coronary
                  artery disease. Nature Genetics. 45, 1345–1352.  DOI


          Author

              Tom Palmer, MRC Integrative Epidemiology Unit and Population Health Sciences, University of
                  Bristol, UK. tom.palmer@bristol.ac.uk.

              If you find any bugs or have questions please send me an email or create an issue on the
                  GitHub repo: https://github.com/remlapmot/mrrobust/issues
