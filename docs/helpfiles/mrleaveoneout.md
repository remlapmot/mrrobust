          Title

               mrleaveoneout -- Leave one (genotype) out (at a time) analysis

          Syntax

                  mrleaveoneout varname_gd varname_gp [if] [in], gyse(varname) [options]

              options                 Description
              ----------------------------------------------------------------------------------------------
                astext(#)             Percentage of plot taken up by areas for text - some trial and error
                                        may be required
                genotype(varname)     Variable to label genotypes, usually containing RSIDs
                gxse(varname)         Variable with genotype-phenotype standard errors (if required by
                                        method)
                gyse(varname)         Variable with genotype-disease standard errors
                metanopts(string)     Options passed to metan for the plot
                method(string)        The method fitted for the analysis
                noplot                Suppresses the plot
                noprint               Suppresses the display of each leave one out model
                textsize(#)           Scaling factor for text on plot. I have tried to use sensible numbers
                                        here but some trial and error may be required
                *                     Other options passed to the analysis method command

          Description

              mrleaveoneout performs leave one out analysis, in which each genotype is omitted in turn from
              the analysis.  A plot of the estimates is shown by default.

              For multiple exposure models such as MVMR and MVMR-Egger the estimate is collected for the
              first phenotype.

              varname_gd is a variable containing the genotype-disease association estimates.

              varname_gp is a variable containing the genotype-phenotype association estimates.

          Options

              method(string) Specifies the method used for the analysis.  Must be one of ivw, egger,
                  mregger, mrivw, median, mrmedian, mrmodal, modal, mode, mvmr, mvivw, mvegger.

          Examples

              Using the data provided by Do et al. (2013).

              Setup
                  . use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear

              Select observations (p-value with exposure < 10^-8)
                  . gen byte sel2 = (ldlcp2 < 1e-25)

              Perform leave one out analysis using the IVW estimator
                  . mrleaveoneout chdbeta ldlcbeta if sel2==1, gyse(chdse) genotype(rsid)

              Leave one out analysis using MVMR (collecting the estimate for LDL-c)
                  . mrleaveoneout chdbeta ldlcbeta hdlcbeta tgbeta if sel2==1, method(mvmr) gyse(chdse)
                      genotype(rsid)

          References

              Do et al. Common variants associated with plasma triglycerides and risk for coronary artery
                  disease. Nature Genetics, 2013, 45, 1345–1352.  DOI


          Author

              Tom Palmer, MRC Integrative Epidemiology Unit and Population Health Sciences, University of
                  Bristol, UK. tom.palmer@bristol.ac.uk.

              If you find any bugs or have questions please send me an email or create an issue on the
                  GitHub repo: https://github.com/remlapmot/mrrobust/issues
