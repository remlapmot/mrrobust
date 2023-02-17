---
title: R Markdown example
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
    toc: true
---

- <a href="#example-showing-mrrobust-stata-code-in-an-r-markdown-file"
  id="toc-example-showing-mrrobust-stata-code-in-an-r-markdown-file">Example
  showing mrrobust Stata code in an R Markdown file</a>
  - <a href="#introduction" id="toc-introduction">Introduction</a>
  - <a href="#extracting-data-from-mr-base"
    id="toc-extracting-data-from-mr-base">Extracting data from MR-Base</a>
  - <a href="#analysis-in-stata-using-the-mrrobust-package"
    id="toc-analysis-in-stata-using-the-mrrobust-package">Analysis in Stata
    using the mrrobust package</a>
  - <a href="#references" id="toc-references">References</a>
  - <a href="#session-info" id="toc-session-info">Session info</a>

# Example showing mrrobust Stata code in an R Markdown file

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

    ## Stata found at C:/Program Files/Stata17/StataMP-64.exe

    ## The 'stata' engine is ready to use.

Note when writing our Stata code chunks we need to be careful when we
specify the `collectcode=TRUE` code chunk option, because each Stata
code chunk is run as a separate batch job.

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
# Perform MR
mr(dat)
```

    Analysing 'ieu-a-300' on 'ieu-a-7'

      id.exposure id.outcome                              outcome
    1   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7
    2   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7
    3   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7
    4   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7
    5   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7
                             exposure                    method nsnp
    1 LDL cholesterol || id:ieu-a-300                  MR Egger   62
    2 LDL cholesterol || id:ieu-a-300           Weighted median   62
    3 LDL cholesterol || id:ieu-a-300 Inverse variance weighted   62
    4 LDL cholesterol || id:ieu-a-300               Simple mode   62
    5 LDL cholesterol || id:ieu-a-300             Weighted mode   62
              b         se         pval
    1 0.5854136 0.06182590 1.619410e-13
    2 0.4887319 0.03781608 3.299105e-38
    3 0.4686211 0.03919370 6.000986e-33
    4 0.4678942 0.05816448 3.690329e-11
    5 0.5189450 0.03622652 3.510856e-21

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

    Running C:\Users\tom\Documents\GitHub\mrrobust\_drafts\rmarkdown-call-stata-exa
    > mple\profile.do . ds, v(28)
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

    Running C:\Users\tom\Documents\GitHub\mrrobust\_drafts\rmarkdown-call-stata-exa
    > mple\profile.do . di _N
    62

We can then run the IVW model using `mregger` with fixed effect standard
errors.

``` stata
mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)], ivw fe
```

    Running C:\Users\tom\Documents\GitHub\mrrobust\_drafts\rmarkdown-call-stata-exa
    > mple\profile.do . mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)], ivw fe

                                                          Number of genotypes = 62
                                          Residual standard error constrained at 1
    ------------------------------------------------------------------------------
                 | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
    -------------+----------------------------------------------------------------
    beta_outcome |
    beta_expos~e |   .4686211   .0224058    20.92   0.000     .4247066    .5125357
    ------------------------------------------------------------------------------

We then fit the MR-Egger, median, and modal based estimators.

``` stata
mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)]

mrmedian beta_outcome se_outcome beta_exposure se_exposure, weighted

mrmodal beta_outcome se_outcome beta_exposure se_exposure, weighted
```

    Running C:\Users\tom\Documents\GitHub\mrrobust\_drafts\rmarkdown-call-stata-exa
    > mple\profile.do . mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)]

                                                          Number of genotypes = 62
                                                  Residual standard error =  1.686
    ------------------------------------------------------------------------------
                 | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
    -------------+----------------------------------------------------------------
    beta_outcome |
           slope |   .5854136   .0618259     9.47   0.000     .4642371    .7065902
           _cons |  -.0095539   .0040042    -2.39   0.017    -.0174019   -.0017059
    ------------------------------------------------------------------------------

                                                          Number of genotypes = 62
                                                               Replications = 1000
    ------------------------------------------------------------------------------
                 | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
    -------------+----------------------------------------------------------------
            beta |   .4887683   .0359701    13.59   0.000     .4182682    .5592685
    ------------------------------------------------------------------------------

                                                          Number of genotypes = 62
                                                               Replications = 1000
                                                                           Phi = 1
    ------------------------------------------------------------------------------
                 | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
    -------------+----------------------------------------------------------------
            beta |    .518945   .0361584    14.35   0.000     .4480759    .5898141
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
─ Session info ─────────────────────────────────────────────────────────
 setting  value
 version  R version 4.2.2 (2022-10-31 ucrt)
 os       Windows 10 x64 (build 22623)
 system   x86_64, mingw32
 ui       RStudio
 language (EN)
 collate  English_United Kingdom.utf8
 ctype    English_United Kingdom.utf8
 tz       Europe/London
 date     2023-02-17
 rstudio  2022.12.0+353 Elsbeth Geranium (desktop)
 pandoc   2.19.2 @ C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools/ (via rmarkdown)

─ Packages ─────────────────────────────────────────────────────────────
 package       * version date (UTC) lib source
 cli             3.6.0   2023-01-09 [1] CRAN (R 4.2.2)
 codetools       0.2-19  2023-02-01 [2] CRAN (R 4.2.2)
 curl            5.0.0   2023-01-12 [1] CRAN (R 4.2.2)
 digest          0.6.31  2022-12-11 [1] CRAN (R 4.2.2)
 dplyr           1.1.0   2023-01-29 [1] CRAN (R 4.2.2)
 evaluate        0.20    2023-01-17 [1] CRAN (R 4.2.2)
 fansi           1.0.4   2023-01-22 [1] CRAN (R 4.2.2)
 fastmap         1.1.0   2021-01-25 [1] CRAN (R 4.2.0)
 foreach         1.5.2   2022-02-02 [1] CRAN (R 4.2.2)
 foreign       * 0.8-84  2022-12-06 [2] CRAN (R 4.2.2)
 generics        0.1.3   2022-07-05 [1] CRAN (R 4.2.1)
 glmnet          4.1-6   2022-11-27 [1] CRAN (R 4.2.2)
 glue            1.6.2   2022-02-24 [1] CRAN (R 4.2.0)
 htmltools       0.5.4   2022-12-07 [1] CRAN (R 4.2.2)
 httr            1.4.4   2022-08-17 [1] CRAN (R 4.2.1)
 ieugwasr        0.1.5   2023-02-17 [1] Github (mrcieu/ieugwasr@33e4629)
 iterators       1.0.14  2022-02-05 [1] CRAN (R 4.2.2)
 jsonlite        1.8.4   2022-12-06 [1] CRAN (R 4.2.2)
 knitr           1.42.3  2023-02-17 [1] Github (yihui/knitr@78f1db5)
 lattice         0.20-45 2021-09-22 [2] CRAN (R 4.2.2)
 lifecycle       1.0.3   2022-10-07 [1] CRAN (R 4.2.1)
 magrittr        2.0.3   2022-03-30 [1] CRAN (R 4.2.0)
 Matrix          1.5-3   2022-11-11 [1] CRAN (R 4.2.2)
 mr.raps         0.2     2018-01-30 [1] CRAN (R 4.2.0)
 MRInstruments * 0.3.2   2022-11-28 [1] Github (mrcieu/MRInstruments@efa2ca0)
 nortest         1.0-4   2015-07-30 [1] CRAN (R 4.2.0)
 pillar          1.8.1   2022-08-19 [1] CRAN (R 4.2.1)
 pkgconfig       2.0.3   2019-09-22 [1] CRAN (R 4.2.0)
 plyr            1.8.8   2022-11-11 [1] CRAN (R 4.2.2)
 R6              2.5.1   2021-08-19 [1] CRAN (R 4.2.0)
 Rcpp            1.0.10  2023-01-22 [1] CRAN (R 4.2.2)
 rlang           1.0.6   2022-09-24 [1] CRAN (R 4.2.1)
 rmarkdown       2.20    2023-01-19 [1] CRAN (R 4.2.2)
 rstudioapi      0.14    2022-08-22 [1] CRAN (R 4.2.1)
 sessioninfo     1.2.2   2021-12-06 [1] CRAN (R 4.2.1)
 shape           1.4.6   2021-05-19 [1] CRAN (R 4.2.0)
 Statamarkdown * 0.7.2   2023-02-15 [1] CRAN (R 4.2.2)
 survival        3.5-3   2023-02-12 [2] CRAN (R 4.2.2)
 tibble          3.1.8   2022-07-22 [1] CRAN (R 4.2.1)
 tidyselect      1.2.0   2022-10-10 [1] CRAN (R 4.2.1)
 TwoSampleMR   * 0.5.6   2023-02-17 [1] Github (MRCIEU/TwoSampleMR@f5935b5)
 utf8            1.2.3   2023-01-31 [1] CRAN (R 4.2.2)
 vctrs           0.5.2   2023-01-23 [1] CRAN (R 4.2.2)
 xfun            0.37    2023-01-31 [1] CRAN (R 4.2.2)
 yaml            2.3.7   2023-01-23 [1] CRAN (R 4.2.2)

 [1] C:/Users/tom/AppData/Local/R/win-library/4.2
 [2] C:/Program Files/R/R-4.2.2/library

────────────────────────────────────────────────────────────────────────
```
