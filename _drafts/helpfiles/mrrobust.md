          Title

              mrrobust -- commands for two-sample Mendelian randomization (MR) analyses.

              https://remlapmot.github.io/mrrobust/

          Commands

                mr            Primary command syntax, i.e. use mr egger ... syntax instead of mregger ...

                mrdeps        Install dependencies for the package

                mregger       MR-Egger and inverse-variance weighted (IVW) estimators

                mreggersimex  Simulation extrapolation algorithm for the MR-Egger model

                mreggerplot   Scatter plot showing instrument specific estimates with IVW, MR-Egger, or
                                median fitted line and confidence interval

                mrmedian      Unweighted, weighted, and penalized weighted median estimators for summary
                                level data

                mrmedianobs   Unweighted, weighted, and penalized weighted median estimators for individual
                                level data

                mrmodal       Modal estimator for summary level data

                mrmodalplot   Plot of density used in the modal estimator

                mrratio       Ratio (Wald) estimator for summary level data for a single genotype

                mrivests      Generate ratio (Wald) estimates for summary level data in dataset

                mrforest      Forest plot of genotype specific and model (IVW, MR-Egger, Median, Modal) IV
                                estimates

                mrfunnel      Funnel plot of the genotype specific IV estimates

                mrmvivw       Multivariable inverse variance weighted estimator (also mvivw and mvmr)

                mrmvegger     Multivariable MR-Egger regression

                mrleaveoneout Leave one out analysis

          Description

              mrrobust is a suite of programs implementing recently developed estimators which are robust to
              certain proportions of invalid instrumental variables.

              Most of the commands are designed to use summary level data as provided by repositories such
              as MR-Base.

              The estimators were developed in the context of MR studies but could be used for other
              applications of instrumental variables.

              There is a website showing the examples from the helpfiles here: 
              https://remlapmot.github.io/mrrobust/

          Author

              Tom Palmer, MRC Integrative Epidemiology Unit and Population Health Sciences, University of
              Bristol, UK. tom.palmer@bristol.ac.uk.

              Development takes place on GitHub here https://github.com/remlapmot/mrrobust.

              Please report any bugs or issues you find, either by email or by creating an issue on the
              GitHub repository here https://github.com/remlapmot/mrrobust/issues.

              I welcome additions to the code, either by email or pull request on GitHub.
