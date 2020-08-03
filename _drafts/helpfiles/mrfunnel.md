          Title

               mrfunnel -- Funnel plot for two-sample MR analysis

          Syntax

                  mrfunnel varname_gd varname_gdse varname_gp varname_gpse [if] [in] [, options]

              options               Description
              ----------------------------------------------------------------------------------------------
                metric(metric)      scale of y-axis
                noivw               do not plot IVW line
                nomregger           do not plot MR-Egger line
                mrivestsopts(opts)  options passed to mrivests
                *                   Other options passed to the plot

          Description

              mrfunnel provides a funnel plot for a two-sample Mendelian randomization analysis.

              There are 3 choices of measures of instrument strength to plot on the y-axis, which are
              described below.
           
              On the plot the MR-Egger estimate is the line with the longer dashes, the IVW estimate is
              shown with the shorter dashes.

              varname_gd is a variable containing the genotype-disease association estimates.

              varname_gdse is a variable containing the genotype-disease association estimate standard
              errors.

              varname_gp is a variable containing the genotype-phenotype association estimates.

              varname_gpse is a variable containing the genotype-phenotype association estimate standard
              errors.

          Options

              metric(gpbeta|gpbetastd|invse) specifies the metric for the y-axis. Can be one of:
              - gpbeta: the absolute value of the genotype-phenotype estimates,
              - gpbetastd: gpbeta standardised by the genotype-disease standard errors (the default),
              - invse: the inverse of the standard errors on the genotype specific IV ratio estimates.

          Examples

              Using the data provided by Do et al. (2013) recreate Bowden et al. (2016) Web Figure A2
              (top-right plot, LDL-C with 73 genotypes).

              Setup
                  . use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear

              Select observations (p-value with exposure < 10^-8)
                  . gen byte sel1 = (ldlcp2 < 1e-8)

              Funnel plot
                  . mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1

              Without adding the IVW and MR-Egger estimates
                  . mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, noivw nomregger

              Using an unstandardised y-axis
                  . mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, metric(gpbeta)

              Using inverse IV SEs on the y-axis
                  . mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, metric(invse)


          References

              Do et al., 2013. Common variants associated with plasma triglycerides and risk for coronary
                  artery disease. Nature Genetics. 45, 1345–1352.  DOI

              Bowden J, Davey Smith G, Haycock PC, Burgess S. Consistent estimation in Mendelian
                  randomization with some invalid instruments using a weighted median estimator. Genetic
                  Epidemiology, 2016, 40, 4, 304-314.  DOI


          Author

              Tom Palmer, MRC Integrative Epidemiology Unit and Population Health Sciences, University of
                  Bristol, UK. tom.palmer@bristol.ac.uk.

              If you find any bugs or have questions please send me an email or create an issue on the
                  GitHub repo: https://github.com/remlapmot/mrrobust/issues
