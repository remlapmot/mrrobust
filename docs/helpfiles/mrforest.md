          Title

               mrforest -- Forest plot for MR-Egger type models

          Syntax

                  mrforest varname_gd varname_gdse varname_gp varname_gpse [varname_cov] [if] [in] [,
                        options]

              options                 Description
              ----------------------------------------------------------------------------------------------
                astext(#)             Percentage of plot taken up by areas for text - some trial and error
                                        may be required
                effect(string)        Label for statistics column; default is Estimate
                ivid(varname)         Variable to label genotypes, usually containing RSIDs
                ividlabel(string)     Label for genotypes; default is Genotypes
                ivwlabel(string)      Label for IVW model; default is IVW
                gsort(string)         how to sort the estimates, if specified must be one of; ascending,
                                        descending, or unsorted; default is ascending
                level(#)              set confidence level; default is level(95)
                mreggerlabel(string)  Label for MR-Egger model; default is MR-Egger
                mrmedianlabel(string) Label for median model; default is Median
                mrmodallabel(string)  Label for modal model; default is Modal
                models(#)             number of models to show (1 IVW, 2 & MR-Egger, 3 & Median, 4 & Modal);
                                        default is 2
                modelslabel(string)   Label for models; default is Summary
                modelsonly            Only show model estimates on plot
                nonote                Suppress note reporting I^2_GX
                nostats               Suppress the statistics column
                textsize(#)           Scaling factor for text on plot. I have tried to use sensible numbers
                                        here but some trial and error may be required
                zcis                  Use normal distribution CI limits (for IVW and MR-Egger)

                Options passed to other commands:
                ivwopts(string)       options for IVW estimate from mregger, ivw
                mreggeropts(string)   options for MR-Egger estimate from mregger
                mrivestopts(string)   options for mrivests used to generate genotype specific ratio
                                        estimates and SEs
                mrmedianopts(string)  options for median estimate from mrmedian
                mrmodal(string)       options for modal estimate from mrmodal

                *                     Other options passed to the metan

          Description

              mrforest plots a forest plot for MR-Egger type models.  It is really a wrapper program for a
              call to metan (Harris et al., 2008), which must be installed.

              If you do not already have metan, it can be installed by running: ssc install metan.

              varname_gd is a variable containing the genotype-disease association estimates.

              varname_gdse is a variable containing the genotype-disease association estimate standard
              errors.

              varname_gp is a variable containing the genotype-phenotype association estimates.

              varname_gpse is a variable containing the genotype-phenotype association estimate standard
              errors.

              varname_cov is a variable containing the covariances between the genotype-disease and
              genotype-phenotype associations.


          Examples

              Using the data provided by Do et al. (2013) recreate Bowden et al. (2016) Figure 4, LDL-c "All
              genetic variants" (plot in row 2, column 1).

              Setup
                  . use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear

              Select observations (p-value with exposure < 10^-8)
                  . gen byte sel1 = (ldlcp2 < 1e-8)

              Forest plot of genotype specific IV estimates and IVW and MR-Egger estimates, labelling the
              genotypes with their RSID.
                  . mrforest chdbeta chdse ldlcbeta ldlcse if sel1==1, ivid(rsid)

              Having seen the first plot we can now define nicer x-axis labels.
                  . mrforest chdbeta chdse ldlcbeta ldlcse if sel1==1, ivid(rsid)
                      xlabel(-5,-4,-3,-2,-1,0,1,2,3,4,5)

              Removing the column of estimates from the plot, and sorting in descending order of the IV
              estimates.
                  . mrforest chdbeta chdse ldlcbeta ldlcse if sel1==1, ivid(rsid) nostats gsort(descending)

              Showing all 4 models and modifying some labels.
                  . mrforest chdbeta chdse ldlcbeta ldlcse if sel1==1, ivid(rsid) models(4) modelslabel(All
                      genotypes)

          References

              Bowden J, Davey Smith G, Haycock PC, Burgess S. Consistent estimation in Mendelian
                  randomization with some invalid instruments using a weighted median estimator. Genetic
                  Epidemiology, 2016, 40, 4, 304-314.  DOI

              Do et al. Common variants associated with plasma triglycerides and risk for coronary artery
                  disease. Nature Genetics, 2013, 45, 1345–1352.  DOI

              Harris RJ, Bradburn MJ, Deeks JJ, Harbord RM, Altman DG, Sterne JAC. metan: fixed- and
                  random-effects meta-analysis.  Stata Journal, 2008, 8, 1, 3-28. Link


          Author

              Tom Palmer, MRC Integrative Epidemiology Unit and Population Health Sciences, University of
                  Bristol, UK. tom.palmer@bristol.ac.uk.

              If you find any bugs or have questions please send me an email or create an issue on the
                  GitHub repo: https://github.com/remlapmot/mrrobust/issues
