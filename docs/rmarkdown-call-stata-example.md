---
title: Rmarkdown example
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
---

# Example showing how to run mrrobust Stata code in an R Markdown script

## Introduction

This example shows how to run R and Stata code within the same Rmarkdown
(`.Rmd`) script using the `Statamarkdown` R package. More information
about this package is available
[here](https://github.com/Hemken/Statamarkdown) and
[here](https://www.ssc.wisc.edu/~hemken/Stataworkshops/Stata%20and%20R%20Markdown/StataMarkdown.html).
To install this package and load it into your current R session run the
following in R.

``` r
# install.packages("remotes") # uncomment on first run
# remotes::install_github("Hemken/Statamarkdown") # uncomment on first run
library(Statamarkdown)
```

Next we need to tell `Statamarkdown` where Stata is installed.

``` r
stataexe <- find_stata()
```

    ## Stata found at C:/Program Files (x86)/Stata15/StataSE-64.exe

``` r
knitr::opts_chunk$set(engine.path = stataexe, cleanlog = FALSE)
```

Note when writing our Stata code chunks we need to be careful when we
specify the `collectcode=TRUE` code chunk option, because each Stata
code chunk is run as a separate batch job. See
[here](https://www.ssc.wisc.edu/~hemken/Stataworkshops/Stata%20and%20R%20Markdown/StataProfile.html)
for more information.

Using R and Stata code in the same script means that we can use the
functions provided by the
[`TwoSampleMR`](https://github.com/MRCIEU/TwoSampleMR) package to obtain
data from [MR-Base](http://www.mrbase.org/).

To see the `Rmd` code which generates this page see
[here](https://raw.githubusercontent.com/remlapmot/mrrobust/master/_drafts/rmarkdown-call-stata-example/rmarkdown-call-stata-example.Rmd).
It consists of R code chunks and Stata code chunks.

Next we install the other required packages in R. Note I don’t run these
lines of code in this script because I already have these packages
installed.

``` r
# remotes::install_github("MRCIEU/TwoSampleMR") # uncomment on first run
# remotes::install_github("MRCIEU/MRInstruments") # uncomment on first run
```

We will be running the script from the MR-Base paper ([Hemani et
al., 2018](https://doi.org/10.7554/eLife.34408)). The R code we will use
is from
[here](https://raw.githubusercontent.com/explodecomputer/mr-base-methods-paper/master/scripts/ldl-chd.R).

We load the packages into our R session. Note that the `foreign` package
provides the `write.dta()` function which we will use to save the data
in Stata format.

``` r
library(TwoSampleMR)
library(MRInstruments)
library(foreign)
```

We can access the data using the `MRInstruments` package.

``` r
data(gwas_catalog)

# Get published SNPs for LDL cholesterol
ldl_snps <- subset(gwas_catalog, grepl("LDL choles", Phenotype) & Author == "Willer CJ")$SNP

# Extract from GLGC dataset
exposure <- convert_outcome_to_exposure(extract_outcome_data(ldl_snps, 300))
```

    ## Extracting data for 62 SNP(s) from 1 GWAS(s)

    ## Warning in format_d(d): From version 0.4.2 the outcome format has
    ## changed. You can find the deprecated version of the output name in
    ## outcome.deprecated

``` r
# Get outcome data from Cardiogram 2015
outcome <- extract_outcome_data(exposure$SNP, 7)
```

    ## Extracting data for 62 SNP(s) from 1 GWAS(s)

    ## Warning in format_d(d): From version 0.4.2 the outcome format has
    ## changed. You can find the deprecated version of the output name in
    ## outcome.deprecated

    ## Finding proxies for 1 SNPs in outcome 7

    ## Extracting data for 1 SNP(s) from 1 GWAS(s)

    ## Warning in format_d(d): From version 0.4.2 the outcome format has
    ## changed. You can find the deprecated version of the output name in
    ## outcome.deprecated

``` r
# Harmonise exposure and outcome datasets
# Assume alleles are on the forward strand
dat <- harmonise_data(exposure, outcome, action=1)
```

    ## Harmonising LDL cholesterol || id:300 (300) and Coronary heart disease || id:7 (7)

At this point we have our harmonised genotype-exposure and
genotype-outcome association data saved in an object in our R session
called `dat`.

The next two code chunks perform the analysis in R.

``` r
# Perform MR
mr(dat)
```

    ## Analysing '300' on '7'

    ##   id.exposure id.outcome                        outcome
    ## 1         300          7 Coronary heart disease || id:7
    ## 2         300          7 Coronary heart disease || id:7
    ## 3         300          7 Coronary heart disease || id:7
    ## 4         300          7 Coronary heart disease || id:7
    ## 5         300          7 Coronary heart disease || id:7
    ##                    exposure                    method nsnp         b
    ## 1 LDL cholesterol || id:300                  MR Egger   62 0.5854136
    ## 2 LDL cholesterol || id:300           Weighted median   62 0.4887319
    ## 3 LDL cholesterol || id:300 Inverse variance weighted   62 0.4686211
    ## 4 LDL cholesterol || id:300               Simple mode   62 0.4678942
    ## 5 LDL cholesterol || id:300             Weighted mode   62 0.5189450
    ##           se         pval
    ## 1 0.06182590 1.619410e-13
    ## 2 0.03900421 5.101237e-36
    ## 3 0.03919370 6.000986e-33
    ## 4 0.06148168 2.062428e-10
    ## 5 0.03282123 2.997639e-23

``` r
mr_heterogeneity(dat)
```

    ## Warning in mr_heterogeneity(dat): Please check news(package='TwoSampleMR')
    ## for information on recent bug fixes

    ##   id.exposure id.outcome                        outcome
    ## 1         300          7 Coronary heart disease || id:7
    ## 2         300          7 Coronary heart disease || id:7
    ##                    exposure                    method        Q Q_df
    ## 1 LDL cholesterol || id:300                  MR Egger 170.4804   60
    ## 2 LDL cholesterol || id:300 Inverse variance weighted 186.6560   61
    ##         Q_pval
    ## 1 1.583556e-12
    ## 2 1.154072e-14

``` r
dat$exposure <- "LDL cholesterol"
dat$outcome <- "Coronary heart disease"

# Label outliers and create plots
dat$labels <- dat$SNP
dat$labels[! dat$SNP %in% c("rs11065987", "rs1250229", "rs4530754")] <- NA
```

To proceed in Stata we can save our `dat` object as a Stata dataset

``` r
write.dta(dat, file = "dat.dta")
```

At this point in Stata install the `mrrobust` package and its
dependencies if you have not done so previously.

``` stata
net install github, from("https://haghish.github.io/github/")
gitget mrrobust
```

Note at this point if you obtain an error saying that these packages are
not installed when in fact you think you have them, this is probably
because `Statamarkdown` does not appear to run a profile do-file,
`profile.do`, saved on a drive other than `C:`. Therefore make new
`PERSONAL` and `PLUS` folders on your `C:` drive (in Stata see `help
adopath`) and then run the code above.

We read the data into Stata and list the variable names (note any `.` in
the colnames of `dat` have been replaced with `_`). Note currently I
cannot get the `collectcode=TRUE` chunk option to work, so I read the
dataset in at the start of every code chunk.

``` stata
use dat, clear
ds, v(28)
di _N
```

    ##  . use dat, clear
    ## (Written by R.              )
    ## 
    ## . ds, v(28)
    ## SNP                     ncontrol_outcome        target_a1_outcome
    ## effect_allele_exposure  pval_outcome            target_a2_outcome
    ## other_allele_exposure   units_outcome           proxy_a1_outcome
    ## effect_allele_outcome   outcome                 proxy_a2_outcome
    ## other_allele_outcome    consortium_outcome      exposure
    ## beta_exposure           year_outcome            se_exposure
    ## beta_outcome            pmid_outcome            pval_exposure
    ## eaf_exposure            category_outcome        units_exposure
    ## eaf_outcome             subcategory_outcome     mr_keep_exposure
    ## remove                  originalname_outcome    pval_origin_exposure
    ## palindromic             outcome_deprecated      units_exposure_dat
    ## ambiguous               mr_keep_outcome         id_exposure
    ## id_outcome              data_source_outcome     action
    ## se_outcome              proxy_outcome           mr_keep
    ## samplesize_outcome      target_snp_outcome      labels
    ## ncase_outcome           proxy_snp_outcome
    ## 
    ## . di _N
    ## 62

We can then run the IVW model using `mregger` with multiplicative
standard errors.

``` stata
qui use dat, clear
mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)], ivw
```

    ##  . qui use dat, clear
    ## 
    ## . mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)], ivw
    ## 
    ##                                                       Number of genotypes = 62
    ## ------------------------------------------------------------------------------
    ##              |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
    ## -------------+----------------------------------------------------------------
    ## beta_outcome |
    ## beta_expos~e |   .4686211   .0391937    11.96   0.000     .3918029    .5454394
    ## ------------------------------------------------------------------------------

We then fit the MR-Egger, median, and modal based estimators.

``` stata
qui use dat, clear
mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)]

mrmedian beta_outcome se_outcome beta_exposure se_exposure, weighted

mrmodal beta_outcome se_outcome beta_exposure se_exposure, weighted
```

    ##  . qui use dat, clear
    ## 
    ## . mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)]
    ## 
    ##                                                       Number of genotypes = 62
    ## ------------------------------------------------------------------------------
    ##              |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
    ## -------------+----------------------------------------------------------------
    ## sign(beta~re)|
    ## beta_outcome |
    ##        slope |   .5854136   .0618259     9.47   0.000     .4642371    .7065902
    ##        _cons |  -.0095539   .0040042    -2.39   0.017    -.0174019   -.0017059
    ## ------------------------------------------------------------------------------
    ## Residual standard error:  1.686
    ## 
    ## . 
    ## . mrmedian beta_outcome se_outcome beta_exposure se_exposure, weighted
    ## 
    ##                                                       Number of genotypes = 62
    ##                                                            Replications = 1000
    ## ------------------------------------------------------------------------------
    ##              |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
    ## -------------+----------------------------------------------------------------
    ##         beta |   .4887683   .0367335    13.31   0.000     .4167721    .5607646
    ## ------------------------------------------------------------------------------
    ## 
    ## . 
    ## . mrmodal beta_outcome se_outcome beta_exposure se_exposure, weighted
    ## 
    ##                                                       Number of genotypes = 62
    ##                                                            Replications = 1000
    ##                                                                        Phi = 1
    ## ------------------------------------------------------------------------------
    ##              |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
    ## -------------+----------------------------------------------------------------
    ##         beta |    .518945   .0361584    14.35   0.000     .4480759    .5898141
    ## ------------------------------------------------------------------------------

And we could continue with additional Stata code (or indeed R code) as
we liked.

To run this `Rmd` file, open it in RStudio and click the `Knit` button
in the toolbar of the Source code window.

## References

  - Hemani et al. The MR-Base platform supports systematic causal
    inference across the human phenome. eLife, 2018;7:e34408
    <https://doi.org/10.7554/eLife.34408>
