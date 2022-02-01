---
output:
  md_document:
    preserve_yaml: true
    toc: true
    variant: gfm
title: Rmarkdown example
---

-   [Example showing mrrobust Stata code in an R Markdown
    file](#example-showing-mrrobust-stata-code-in-an-r-markdown-file)
    -   [Introduction](#introduction)
    -   [Extracting data from MR-Base](#extracting-data-from-mr-base)
    -   [Analysis in Stata using the mrrobust
        package](#analysis-in-stata-using-the-mrrobust-package)
    -   [References](#references)
    -   [Session info](#session-info)

# Example showing mrrobust Stata code in an R Markdown file

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

    ## Stata found at C:/Program Files/Stata17/StataMP-64.exe

    ## The 'stata' engine is ready to use.

Next we need to tell `Statamarkdown` where Stata is installed.

``` r
stataexe <- find_stata()
```

    Stata found at C:/Program Files/Stata17/StataMP-64.exe

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
data from [MR-Base](https://www.mrbase.org/).

To see the `Rmd` code which generates this page see
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

We load the packages into our R session. Note that the `foreign` package
provides the `write.dta()` function which we will use to save the data
in Stata format.

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

We can access the data using the `MRInstruments` package.

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
# Perform MR
mr(dat)
```

    Analysing 'ieu-a-300' on 'ieu-a-7'

      id.exposure id.outcome                              outcome                        exposure                    method nsnp         b         se
    1   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7 LDL cholesterol || id:ieu-a-300                  MR Egger   62 0.5854136 0.06182590
    2   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7 LDL cholesterol || id:ieu-a-300           Weighted median   62 0.4887319 0.03814809
    3   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7 LDL cholesterol || id:ieu-a-300 Inverse variance weighted   62 0.4686211 0.03919370
    4   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7 LDL cholesterol || id:ieu-a-300               Simple mode   62 0.4678942 0.06338355
    5   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7 LDL cholesterol || id:ieu-a-300             Weighted mode   62 0.5189450 0.03477515
              pval
    1 1.619410e-13
    2 1.414881e-37
    3 6.000986e-33
    4 5.102500e-10
    5 4.999412e-22

``` r
mr_heterogeneity(dat)
```

      id.exposure id.outcome                              outcome                        exposure                    method        Q Q_df       Q_pval
    1   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7 LDL cholesterol || id:ieu-a-300                  MR Egger 170.4804   60 1.583556e-12
    2   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7 LDL cholesterol || id:ieu-a-300 Inverse variance weighted 186.6560   61 1.154072e-14

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
`PERSONAL` and `PLUS` folders on your `C:` drive (in Stata see
`help adopath`) and then run the code above.

We read the data into Stata and list the variable names (note any `.` in
the colnames of `dat` have been replaced with `_`). Note currently I
cannot get the `collectcode=TRUE` chunk option to work, so I read the
dataset in at the start of every code chunk.

``` stata
use dat, clear
ds, v(28)
di _N
```

    . use dat, cl(Written by R.              )

    . ds, v(28)
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

    . di _N
    62

We can then run the IVW model using `mregger` with multiplicative
standard errors.

``` stata
qui use dat, clear
mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)], ivw
```

    . qui use dat, cl. mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)], ivw

                                                          Number of genotypes = 62
                                                  Residual standard error =  1.749
    ------------------------------------------------------------------------------
                 | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
    -------------+----------------------------------------------------------------
    beta_outcome |
    beta_expos~e |   .4686211   .0391937    11.96   0.000     .3918029    .5454394
    ------------------------------------------------------------------------------

We then fit the MR-Egger, median, and modal based estimators.

``` stata
qui use dat, clear

mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)]

mrmedian beta_outcome se_outcome beta_exposure se_exposure, weighted

mrmodal beta_outcome se_outcome beta_exposure se_exposure, weighted
```

    . qui use dat, cl. 
    . mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)]

                                                          Number of genotypes = 62
                                                  Residual standard error =  1.686
    ------------------------------------------------------------------------------
                 | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
    -------------+----------------------------------------------------------------
    beta_outcome |
           slope |   .5854136   .0618259     9.47   0.000     .4642371    .7065902
           _cons |  -.0095539   .0040042    -2.39   0.017    -.0174019   -.0017059
    ------------------------------------------------------------------------------

    . 
    . mrmedian beta_outcome se_outcome beta_exposure se_exposure, weighted

                                                          Number of genotypes = 62
                                                               Replications = 1000
    ------------------------------------------------------------------------------
                 | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
    -------------+----------------------------------------------------------------
            beta |   .4887683   .0359701    13.59   0.000     .4182682    .5592685
    ------------------------------------------------------------------------------

    . 
    . mrmodal beta_outcome se_outcome beta_exposure se_exposure, weighted

                                                          Number of genotypes = 62
                                                               Replications = 1000
                                                                           Phi = 1
    ------------------------------------------------------------------------------
                 | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
    -------------+----------------------------------------------------------------
            beta |    .518945   .0361584    14.35   0.000     .4480759    .5898141
    ------------------------------------------------------------------------------

And we could continue with additional Stata code (or indeed R code) as
we liked.

To run this `Rmd` file, open it in RStudio and click the `Knit` button
in the toolbar of the Source code window.

## References

-   Hemani et al. The MR-Base platform supports systematic causal
    inference across the human phenome. eLife, 2018;7:e34408
    <https://doi.org/10.7554/eLife.34408>

## Session info

For reproducibility

``` r
sessioninfo::session_info()
- Session info ---------------------------------------------------------------------------------------------------------------------------------------
 setting  value
 version  R version 4.1.2 (2021-11-01)
 os       Windows 10 x64 (build 19044)
 system   x86_64, mingw32
 ui       RStudio
 language (EN)
 collate  English_United Kingdom.1252
 ctype    English_United Kingdom.1252
 tz       Europe/London
 date     2022-02-01
 rstudio  2022.02.0-preview+392 Prairie Trillium (desktop)
 pandoc   2.17.0.1 @ C:/Program Files/RStudio/bin/quarto/bin/ (via rmarkdown)

- Packages -------------------------------------------------------------------------------------------------------------------------------------------
 package       * version date (UTC) lib source
 assertthat      0.2.1   2019-03-21 [1] CRAN (R 4.1.0)
 cli             3.1.1   2022-01-20 [1] CRAN (R 4.1.2)
 codetools       0.2-18  2020-11-04 [2] CRAN (R 4.1.2)
 crayon          1.4.2   2021-10-29 [1] CRAN (R 4.1.1)
 curl            4.3.2   2021-06-23 [1] CRAN (R 4.1.0)
 DBI             1.1.2   2021-12-20 [1] CRAN (R 4.1.2)
 digest          0.6.29  2021-12-01 [1] CRAN (R 4.1.2)
 dplyr           1.0.7   2021-06-18 [1] CRAN (R 4.1.0)
 ellipsis        0.3.2   2021-04-29 [1] CRAN (R 4.1.0)
 evaluate        0.14    2019-05-28 [1] CRAN (R 4.1.0)
 fansi           1.0.2   2022-01-14 [1] CRAN (R 4.1.2)
 fastmap         1.1.0   2021-01-25 [1] CRAN (R 4.1.0)
 foreach         1.5.1   2020-10-15 [1] CRAN (R 4.1.0)
 foreign       * 0.8-82  2022-01-13 [2] CRAN (R 4.1.2)
 generics        0.1.2   2022-01-31 [1] CRAN (R 4.1.2)
 glmnet          4.1-3   2021-11-02 [1] CRAN (R 4.1.2)
 glue            1.6.1   2022-01-22 [1] CRAN (R 4.1.2)
 htmltools       0.5.2   2021-08-25 [1] CRAN (R 4.1.1)
 httr            1.4.2   2020-07-20 [1] CRAN (R 4.1.0)
 ieugwasr        0.1.5   2021-06-28 [1] Github (mrcieu/ieugwasr@8a24a94)
 iterators       1.0.13  2020-10-15 [1] CRAN (R 4.1.0)
 jsonlite        1.7.3   2022-01-17 [1] CRAN (R 4.1.2)
 knitr           1.37    2021-12-16 [1] CRAN (R 4.1.2)
 lattice         0.20-45 2021-09-22 [2] CRAN (R 4.1.2)
 lifecycle       1.0.1   2021-09-24 [1] CRAN (R 4.1.1)
 magrittr        2.0.2   2022-01-26 [1] CRAN (R 4.1.2)
 Matrix          1.4-0   2021-12-08 [2] CRAN (R 4.1.2)
 mr.raps         0.2     2018-01-30 [1] CRAN (R 4.1.0)
 MRInstruments * 0.3.2   2021-06-28 [1] Github (mrcieu/MRInstruments@efa2ca0)
 nortest         1.0-4   2015-07-30 [1] CRAN (R 4.1.0)
 pillar          1.7.0   2022-02-01 [1] CRAN (R 4.1.2)
 pkgconfig       2.0.3   2019-09-22 [1] CRAN (R 4.1.0)
 plyr            1.8.6   2020-03-03 [1] CRAN (R 4.1.0)
 purrr           0.3.4   2020-04-17 [1] CRAN (R 4.1.0)
 R6              2.5.1   2021-08-19 [1] CRAN (R 4.1.1)
 Rcpp            1.0.8   2022-01-13 [1] CRAN (R 4.1.2)
 rlang           1.0.0   2022-01-26 [1] CRAN (R 4.1.2)
 rmarkdown       2.11    2021-09-14 [1] CRAN (R 4.1.1)
 sessioninfo     1.2.2   2021-12-06 [1] CRAN (R 4.1.2)
 shape           1.4.6   2021-05-19 [1] CRAN (R 4.1.0)
 Statamarkdown * 0.7.0   2021-09-15 [1] Github (Hemken/Statamarkdown@a68a8b9)
 stringi         1.7.6   2021-11-29 [1] CRAN (R 4.1.2)
 stringr         1.4.0   2019-02-10 [1] CRAN (R 4.1.0)
 survival        3.2-13  2021-08-24 [2] CRAN (R 4.1.2)
 tibble          3.1.6   2021-11-07 [1] CRAN (R 4.1.2)
 tidyselect      1.1.1   2021-04-30 [1] CRAN (R 4.1.0)
 TwoSampleMR   * 0.5.6   2021-09-15 [1] Github (mrcieu/twosamplemr@2bb4947)
 utf8            1.2.2   2021-07-24 [1] CRAN (R 4.1.0)
 vctrs           0.3.8   2021-04-29 [1] CRAN (R 4.1.0)
 xfun            0.29    2021-12-14 [1] CRAN (R 4.1.2)
 yaml            2.2.2   2022-01-25 [1] CRAN (R 4.1.2)

 [1] C:/Users/eptmp/Documents/R/win-library/4.1
 [2] C:/Program Files/R/R-4.1.2/library

------------------------------------------------------------------------------------------------------------------------------------------------------
```
