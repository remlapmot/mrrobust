          Title

               mregger -- Mendelian randomization Egger regression

          Syntax

                  mregger varname_gd varname_gp [aweight] [if] [in] [, options]

              options               Description
              ----------------------------------------------------------------------------------------------
                fe                  Fixed effect standard errors (default is multiplicative)
                gxse(varname)       variable of genotype-phenotype SEs
                heterogi            Display heterogeneity/pleiotropy statistics
                ivw                 Inverse-variance weighted estimator (default is MR-Egger)
                level(#)            set confidence level; default is level(95)
                norescale           Do not rescale residual variance to be 1 (if less than 1)
                oldnames            Revert to using longer outcome name in b and V ereturned matrices
                penweighted         Use penalized weights
                radial              Use radial formulations of the models
                tdist               Use t-distribution for Wald test and CI limits
                unwi2gx             Additionally report unweighted Q_GX and I^2_GX statistics

          Description

              mregger performs inverse-variance weighted (IVW; Burgess et al., 2013) and Mendelian
              randomization Egger (MR-Egger) regression (Bowden et al., 2015) using summary level data (i.e.
              using genotype-disease and phenotype-disease association estimates and their standard errors).

              varname_gd variable containing the genotype-disease association estimates.

              varname_gp variable containing the genotype-phenotype association estimates.

              For the analytic weights you need to specify the inverse of the genotype-disease standard
              errors squared, i.e. aw=1/(gdse^2).

          Options

              fe specifies fixed effect standard errors (i.e. variance of residuals constrained to 1 as in
                  fixed effect meta-analysis models). The default is to use multiplicative standard errors
                  (i.e. variance of residuals unconstrained as in standard linear regression), see Thompson
                  and Sharp (1999) for further details.  We recommend specifying this option when using an
                  allelic score as the instrumental variable.

              gxse(varname) specifies the variable containing the genotype-phenotype association standard
                  errors. These are required for calculating the I^2_GX statistic (Bowden et al., 2016). An
                  I^2_GX statistic of 90% means that the likely bias due measurement error in the MR-Egger
                  slope estimate is around 10%. If I^2_GX values are less than 90% estimates should be
                  treated with caution.

              heterogi suppresses display of heterogeneity/pleiotropy statistics. In the heterogeneity
                  output the model based Q-statistic is reported by multiplying the variance of the
                  residuals by the degrees of freedom (Del Greco et al., 2015).

              ivw specifies inverse-variance weighted (IVW) model (Burgess et al., 2013), the default is
                  MR-Egger.

              level(#); see [R] estimation options.

              norescale specifies that the residual variance is not set to 1 (if it is found to be less than
                  1). Bowden et al. (2016) rescale the residual variance to be 1 if it is found to be less
                  than 1.

              oldnames revert to using the longer outcome variable name in the b and V ereturned matrices.

              penweighted specifies using penalized weights as described in Burgess et al. (2016).

              radial specifies the radial formulation of the IVW and MR-Egger models (Bowden et al., 2017).
                  Note there is only a difference for the MR-Egger model.

              tdist specifies using the t-distribution, instead of the normal distribution, for calculating
                  the Wald test and the confidence interval limits.

              unwi2gx specifies the unweighted Q_GX and I^2_GX statistics to be additionally displayed in
                  the output and in the ereturn scalars.

          Examples

              Using the data provided by Do et al. (2013) recreate Bowden et al. (2016), Table 4, LDL-c "All
              genetic variants" estimates.

              Setup
                  . use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear

              Select observations (p-value with exposure < 10^-8)
                  . gen byte sel1 = (ldlcp2 < 1e-8)

              IVW (with fixed effect standard errors)
                  . mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw fe

              MR-Egger (with SEs using an unconstrained residual variance)
                  . mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1

              MR-Egger reporting I^2_GX statistic and heterogeneity Q-test
                  . mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, gxse(ldlcse) heterogi

              MR-Egger using a t-distribution for inference & CI limits
                  . mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, tdist

              MR-Egger using the radial formulation
                  . mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, radial

              MR-Egger using the radial formulation and reporting heterogeneity Q-test
                  . mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, radial heterogi


          Stored results

              mregger stores the following in e():

              Scalars        
                e(df_r)             residual degrees of freedom (with tdist option)
                e(k)                number of instruments
                e(I2GX)             I^2_GX (with gxse() option)
                e(QGX)              Q_GX (with gxse() option)
                e(phi)              Scale parameter (root mean squared error)

              Macros         
                e(cmd)              mregger
                e(cmdline)          command as typed

              Matrices       
                e(b)                coefficient vector
                e(V)                variance-covariance matrix of the estimates

              If heterogi is specified mregger additionally returns the r-class results of heterogi in the
              e-class results.

              If unwi2gx is specified mregger additionally returns
                e(I2GXunw)          Unweighted I^2_GX statistic
                e(QGXunw)           Unweighted Q_GX statistic

              mregger stores the following in r():

              Matrices       
                r(table)            Coefficient table with rownames: b, se, z, pvalue, ll, ul, df, crit,
                                      eform

          References

              Bowden J, Davey Smith G, Burgess S.  Mendelian randomization with invalid instruments: effect
                  estimation and bias detection through Egger regression. International Journal of
                  Epidemiology, 2015, 44, 2, 512-525.  DOI

              Bowden J, Davey Smith G, Haycock PC, Burgess S. Consistent estimation in Mendelian
                  randomization with some invalid instruments using a weighted median estimator. Genetic
                  Epidemiology, 2016, 40, 4, 304-314.  DOI

              Bowden J, Del Greco F, Minelli C, Davey Smith G, Sheehan NA, Thompson JR.  Assessing the
                  suitability of summary data for two-sample Mendelian randomization analyses using MR-Egger
                  regression: the role of the I-squared statistic. International Journal of Epidemiology,
                  2016, 45, 6, 1961-1974.  DOI

              Bowden J, Spiller W, Del-Greco F, Sheehan NA, Thompson JR, Minelli C, Davey Smith G.
                  Improving the visualisation, interpretation and analysis of two-sample summary data
                  Mendelian randomization via the radial plot and radial regression.  International Journal
                  of Epidemiology, 2018, 47, 4, 1264-1278. DOI

              Burgess S, Bowden J, Dudbridge F, Thompson SG. Robust instrumental variable methods using
                  candidate instruments with application to Mendelian randomization. arXiv:1606.03729v1,
                  2016.  Link

              Burgess S, Butterworth A, Thompson S. Mendelian randomization analysis with multiple genetic
                  variants using summarized data. Genetic Epidemiology, 2013, 37, 7, 658–665.   DOI

              Del Greco F M, Minelli C, Sheehan NA, Thompson JR. Detecting pleiotropy in Mendelian
                  randomization studies with summary data and a continuous outcome.  Statistics in Medicine,
                  2015, 34, 21, 2926-2940.  DOI

              Do R et al. Common variants associated with plasma triglycerides and risk for coronary artery
                  disease. Nature Genetics, 2013, 45, 1345–1352. DOI:  DOI

              Thompson SG, Sharp SJ. Explaining heterogeneity in meta-analysis: a comparison of methods.
                  Statistics in Medicine, 1999, 18, 20, 2693-2708.  DOI


          Author

              Tom Palmer, MRC Integrative Epidemiology Unit and Population Health Sciences, University of
                  Bristol, UK. tom.palmer@bristol.ac.uk.

              If you find any bugs or have questions please send me an email or create an issue on the
                  GitHub repo: https://github.com/remlapmot/mrrobust/issues
