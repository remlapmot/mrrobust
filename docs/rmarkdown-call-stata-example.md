---
title: R Markdown example
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
    toc: true
---

- [Example showing how to include mrrobust Stata code in an R Markdown
  file using the Statamarkdown R
  package](#example-showing-how-to-include-mrrobust-stata-code-in-an-r-markdown-file-using-the-statamarkdown-r-package)
  - [Introduction](#introduction)
  - [Extracting data from MR-Base](#extracting-data-from-mr-base)
  - [Analysis in Stata using the mrrobust
    package](#analysis-in-stata-using-the-mrrobust-package)
  - [References](#references)
  - [Session info](#session-info)

# Example showing how to include mrrobust Stata code in an R Markdown file using the Statamarkdown R package

## Introduction

This example shows how to run R and Stata code within the same R
Markdown (`.Rmd`) file using the **Statamarkdown** R package. More
information about this package is available
[here](https://github.com/Hemken/Statamarkdown) and
[here](https://www.ssc.wisc.edu/~hemken/Stataworkshops/Statamarkdown/stata-and-r-markdown.html).
To install this package and load it into your current R session run the
following in R.

``` r
# install.packages("Statamarkdown") # uncomment on first run
library(Statamarkdown)
```

Note when writing our Stata code chunks we need to be careful when we
specify the `collectcode=TRUE` code chunk option, because each Stata
code chunk is run as a separate batch job. For example, we include this
chunk option in a chunk which reads in a dataset which we wish to use in
subsequent chunks.

Using R and Stata code in the same script means that we can use the
functions provided by the
[**TwoSampleMR**](https://github.com/MRCIEU/TwoSampleMR) package to
obtain data from [MR-Base](https://www.mrbase.org/).

To see the R Markdown code which generates this page see
[here](https://raw.githubusercontent.com/remlapmot/mrrobust/master/_drafts/rmarkdown-call-stata-example/rmarkdown-call-stata-example.Rmd).
It consists of R code chunks and Stata code chunks.

Next we install the other required packages in R. Note I don’t run these
lines of code in this script because I already have these packages
installed.

``` r
remotes::install_github("MRCIEU/TwoSampleMR") # uncomment on first run
remotes::install_github("MRCIEU/MRInstruments") # uncomment on first run
```

## Extracting data from MR-Base

We will be running the script from the MR-Base paper ([Hemani et al.,
2018](https://doi.org/10.7554/eLife.34408)). The R code we will use is
from
[here](https://raw.githubusercontent.com/explodecomputer/mr-base-methods-paper/master/scripts/ldl-chd.R).

We load the packages into our R session. Note that the **foreign**
package provides the `write.dta()` function which we will use to save
the data in Stata format.

``` r
library(TwoSampleMR)
```

    TwoSampleMR version 0.5.6 
    [>] New: Option to use non-European LD reference panels for clumping etc
    [>] Some studies temporarily quarantined to verify effect allele
    [>] See news(package='TwoSampleMR') and https://gwas.mrcieu.ac.uk for further details

``` r
library(MRInstruments)
library(foreign)
```

We can access the data using the **MRInstruments** package.

``` r
data(gwas_catalog)

# Get published SNPs for LDL cholesterol
ldl_snps <- subset(gwas_catalog, grepl("LDL choles", Phenotype) & Author == "Willer CJ")$SNP

# Extract from GLGC dataset
exposure <- convert_outcome_to_exposure(extract_outcome_data(ldl_snps, "ieu-a-300"))
```

    API: public: http://gwas-api.mrcieu.ac.uk/

    Extracting data for 62 SNP(s) from 1 GWAS(s)

``` r
# Get outcome data from Cardiogram 2015
outcome <- extract_outcome_data(exposure$SNP, "ieu-a-7")
```

    Extracting data for 62 SNP(s) from 1 GWAS(s)

    Finding proxies for 1 SNPs in outcome ieu-a-7

    Extracting data for 1 SNP(s) from 1 GWAS(s)

``` r
# Harmonise exposure and outcome datasets
# Assume alleles are on the forward strand
dat <- harmonise_data(exposure, outcome, action = 1)
```

    Harmonising LDL cholesterol || id:ieu-a-300 (ieu-a-300) and Coronary heart disease || id:ieu-a-7 (ieu-a-7)

At this point we have our harmonised genotype-exposure and
genotype-outcome association data saved in an object in our R session
called `dat`.

The next two code chunks perform the analysis in R.

``` r
# Perform MR analysis
mr(dat)
```

    Analysing 'ieu-a-300' on 'ieu-a-7'

      id.exposure id.outcome                              outcome
    1   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7
    2   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7
    3   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7
    4   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7
    5   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7
                             exposure                    method nsnp         b
    1 LDL cholesterol || id:ieu-a-300                  MR Egger   62 0.5854136
    2 LDL cholesterol || id:ieu-a-300           Weighted median   62 0.4887319
    3 LDL cholesterol || id:ieu-a-300 Inverse variance weighted   62 0.4686211
    4 LDL cholesterol || id:ieu-a-300               Simple mode   62 0.4678942
    5 LDL cholesterol || id:ieu-a-300             Weighted mode   62 0.5189450
              se         pval
    1 0.06182590 1.619410e-13
    2 0.03782321 3.405189e-38
    3 0.03919370 6.000986e-33
    4 0.06388963 6.434096e-10
    5 0.03309571 4.513679e-23

``` r
mr_heterogeneity(dat)
```

      id.exposure id.outcome                              outcome
    1   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7
    2   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7
                             exposure                    method        Q Q_df
    1 LDL cholesterol || id:ieu-a-300                  MR Egger 170.4804   60
    2 LDL cholesterol || id:ieu-a-300 Inverse variance weighted 186.6560   61
            Q_pval
    1 1.583556e-12
    2 1.154072e-14

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

## Analysis in Stata using the mrrobust package

At this point in Stata install the **mrrobust** package and its
dependencies if you have not done so previously.

``` stata
net install github, from("https://haghish.github.io/github/")
gitget mrrobust
```

We now read the dataset into Stata and look at the variable names and
the number of observations.

``` stata
qui use dat, clear
```

``` stata
ds, v(28)
```

    SNP                     pos                     proxy_a1_outcome
    effect_allele_exposure  se_outcome              proxy_a2_outcome
    other_allele_exposure   samplesize_outcome      exposure
    effect_allele_outcome   pval_outcome            chr_exposure
    other_allele_outcome    outcome                 pos_exposure
    beta_exposure           originalname_outcome    se_exposure
    beta_outcome            outcome_deprecated      pval_exposure
    eaf_exposure            mr_keep_outcome         mr_keep_exposure
    eaf_outcome             data_source_outcome     pval_origin_exposure
    remove                  proxy_outcome           id_exposure
    palindromic             target_snp_outcome      action
    ambiguous               proxy_snp_outcome       mr_keep
    id_outcome              target_a1_outcome       labels
    chr                     target_a2_outcome

``` stata
di _N
```

    62

We can then run the IVW model using `mregger` with fixed effect standard
errors.

``` stata
mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)], ivw fe
```

                                                          Number of genotypes = 62
                                          Residual standard error constrained at 1
    -------------------------------------------------------------------------------
                  | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
    --------------+----------------------------------------------------------------
    beta_outcome  |
    beta_exposure |   .4686211   .0224058    20.92   0.000     .4247066    .5125357
    -------------------------------------------------------------------------------

We then fit the MR-Egger, median, and modal based estimators.

``` stata
mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)]
```

                                                          Number of genotypes = 62
                                                  Residual standard error =  1.686
    ------------------------------------------------------------------------------
                 | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
    -------------+----------------------------------------------------------------
    beta_outcome |
           slope |   .5854136   .0618259     9.47   0.000     .4642371    .7065902
           _cons |  -.0095539   .0040042    -2.39   0.017    -.0174019   -.0017059
    ------------------------------------------------------------------------------

``` stata
mrmedian beta_outcome se_outcome beta_exposure se_exposure, weighted
```

                                                          Number of genotypes = 62
                                                               Replications = 1000
    ------------------------------------------------------------------------------
                 | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
    -------------+----------------------------------------------------------------
            beta |   .4887683   .0359701    13.59   0.000     .4182682    .5592685
    ------------------------------------------------------------------------------

``` stata
mrmodal beta_outcome se_outcome beta_exposure se_exposure, weighted
```

                                                          Number of genotypes = 62
                                                               Replications = 1000
                                                                           Phi = 1
    ------------------------------------------------------------------------------
                 | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
    -------------+----------------------------------------------------------------
            beta |    .518945   .0340225    15.25   0.000     .4522621     .585628
    ------------------------------------------------------------------------------

And we could continue with additional Stata code (or indeed R code) as
we like.

To run this R Markdown file, either; open it in RStudio and click the
`Knit` button in the toolbar of the Source code window, or run

``` r
rmarkdown::render('rmarkdown-call-stata-example.Rmd')
```

## References

- Hemani et al. The MR-Base platform supports systematic causal
  inference across the human phenome. eLife, 2018;7:e34408
  <https://doi.org/10.7554/eLife.34408>

## Session info

For reproducibility

``` r
sessioninfo::session_info()
─ Session info ──────────────────────────────────────────────────────────────
 setting  value
 version  R version 4.2.3 (2023-03-15)
 os       macOS Ventura 13.2.1
 system   aarch64, darwin20
 ui       RStudio
 language (EN)
 collate  en_US.UTF-8
 ctype    en_US.UTF-8
 tz       Europe/London
 date     2023-03-19
 rstudio  2023.03.0-daily+361 Cherry Blossom (desktop)
 pandoc   3.1.1 @ /opt/homebrew/bin/ (via rmarkdown)

─ Packages ──────────────────────────────────────────────────────────────────
 package       * version date (UTC) lib source
 cli             3.6.0   2023-01-09 [1] CRAN (R 4.2.0)
 codetools       0.2-19  2023-02-01 [1] CRAN (R 4.2.3)
 curl            5.0.0   2023-01-12 [1] CRAN (R 4.2.0)
 digest          0.6.31  2022-12-11 [1] CRAN (R 4.2.0)
 dplyr           1.1.0   2023-01-29 [1] CRAN (R 4.2.0)
 evaluate        0.20    2023-01-17 [1] CRAN (R 4.2.0)
 fansi           1.0.4   2023-01-22 [1] CRAN (R 4.2.0)
 fastmap         1.1.1   2023-02-24 [1] CRAN (R 4.2.0)
 foreach         1.5.2   2022-02-02 [1] CRAN (R 4.2.0)
 foreign       * 0.8-84  2022-12-06 [1] CRAN (R 4.2.3)
 generics        0.1.3   2022-07-05 [1] CRAN (R 4.2.0)
 glmnet          4.1-6   2022-11-27 [1] CRAN (R 4.2.0)
 glue            1.6.2   2022-02-24 [1] CRAN (R 4.2.0)
 htmltools       0.5.4   2022-12-07 [1] CRAN (R 4.2.0)
 httr            1.4.5   2023-02-24 [1] CRAN (R 4.2.0)
 ieugwasr        0.1.5   2023-03-19 [1] Github (mrcieu/ieugwasr@33e4629)
 iterators       1.0.14  2022-02-05 [1] CRAN (R 4.2.0)
 jsonlite        1.8.4   2022-12-06 [1] CRAN (R 4.2.0)
 knitr           1.42.5  2023-03-15 [1] Github (yihui/knitr@c50d307)
 lattice         0.20-45 2021-09-22 [1] CRAN (R 4.2.3)
 lifecycle       1.0.3   2022-10-07 [1] CRAN (R 4.2.0)
 magrittr        2.0.3   2022-03-30 [1] CRAN (R 4.2.0)
 Matrix          1.5-3   2022-11-11 [1] CRAN (R 4.2.3)
 mr.raps         0.2     2018-01-30 [1] CRAN (R 4.2.0)
 MRInstruments * 0.3.2   2023-03-19 [1] Github (MRCIEU/MRInstruments@efa2ca0)
 nortest         1.0-4   2015-07-30 [1] CRAN (R 4.2.0)
 pillar          1.8.1   2022-08-19 [1] CRAN (R 4.2.0)
 pkgconfig       2.0.3   2019-09-22 [1] CRAN (R 4.2.0)
 plyr            1.8.8   2022-11-11 [1] CRAN (R 4.2.0)
 R6              2.5.1   2021-08-19 [1] CRAN (R 4.2.0)
 Rcpp            1.0.10  2023-01-22 [1] CRAN (R 4.2.0)
 rlang           1.1.0   2023-03-14 [1] CRAN (R 4.2.0)
 rmarkdown       2.20    2023-01-19 [1] CRAN (R 4.2.0)
 rstudioapi      0.14    2022-08-22 [1] CRAN (R 4.2.0)
 sessioninfo     1.2.2   2021-12-06 [1] CRAN (R 4.2.0)
 shape           1.4.6   2021-05-19 [1] CRAN (R 4.2.0)
 Statamarkdown * 0.7.2   2023-02-15 [1] CRAN (R 4.2.0)
 survival        3.5-5   2023-03-12 [1] CRAN (R 4.2.0)
 tibble          3.2.0   2023-03-08 [1] CRAN (R 4.2.0)
 tidyselect      1.2.0   2022-10-10 [1] CRAN (R 4.2.0)
 TwoSampleMR   * 0.5.6   2023-03-19 [1] Github (MRCIEU/TwoSampleMR@f5935b5)
 utf8            1.2.3   2023-01-31 [1] CRAN (R 4.2.0)
 vctrs           0.6.0   2023-03-16 [1] CRAN (R 4.2.2)
 xfun            0.37    2023-01-31 [1] CRAN (R 4.2.0)
 yaml            2.3.7   2023-01-23 [1] CRAN (R 4.2.0)

 [1] /Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library

─────────────────────────────────────────────────────────────────────────────
```
