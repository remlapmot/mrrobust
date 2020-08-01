---
title: Rmarkdown example
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
    toc: true
---

  - [Example showing mrrobust Stata code in an R Markdown
    file](#example-showing-mrrobust-stata-code-in-an-r-markdown-file)
      - [Introduction](#introduction)
      - [Extracting data from MR-Base](#extracting-data-from-mr-base)
      - [Analysis in Stata using the mrrobust
        package](#analysis-in-stata-using-the-mrrobust-package)
      - [References](#references)

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

Next we need to tell `Statamarkdown` where Stata is installed.

``` r
stataexe <- find_stata()
```

    ## Stata found at C:/Program Files (x86)/Stata15/StataMP-64.exe

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
remotes::install_github("MRCIEU/TwoSampleMR") # uncomment on first run
remotes::install_github("MRCIEU/MRInstruments") # uncomment on first run
```

## Extracting data from MR-Base

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
exposure <- convert_outcome_to_exposure(extract_outcome_data(ldl_snps, "ieu-a-300"))
```

    ## Extracting data for 62 SNP(s) from 1 GWAS(s)

``` r
# Get outcome data from Cardiogram 2015
outcome <- extract_outcome_data(exposure$SNP, 7)
```

    ## Deprecated IDs being used? Detected numeric IDs. Trying to fix, but please note the changes below for future.

    ## 7  ->  ieu-a-7

    ## Extracting data for 62 SNP(s) from 1 GWAS(s)

    ## Finding proxies for 1 SNPs in outcome ieu-a-7

    ## Extracting data for 1 SNP(s) from 1 GWAS(s)

``` r
# Harmonise exposure and outcome datasets
# Assume alleles are on the forward strand
dat <- harmonise_data(exposure, outcome, action = 1)
```

    ## Harmonising LDL cholesterol || id:ieu-a-300 (ieu-a-300) and Coronary heart disease || id:ieu-a-7 (ieu-a-7)

At this point we have our harmonised genotype-exposure and
genotype-outcome association data saved in an object in our R session
called `dat`.

The next two code chunks perform the analysis in R.

``` r
# Perform MR
mr(dat)
```

    ## Analysing 'ieu-a-300' on 'ieu-a-7'

    ##   id.exposure id.outcome                              outcome                        exposure
    ## 1   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7 LDL cholesterol || id:ieu-a-300
    ## 2   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7 LDL cholesterol || id:ieu-a-300
    ## 3   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7 LDL cholesterol || id:ieu-a-300
    ## 4   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7 LDL cholesterol || id:ieu-a-300
    ## 5   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7 LDL cholesterol || id:ieu-a-300
    ##                      method nsnp         b         se         pval
    ## 1                  MR Egger   62 0.5853125 0.06191076 1.712795e-13
    ## 2           Weighted median   62 0.4887311 0.03698009 7.088023e-40
    ## 3 Inverse variance weighted   62 0.4689295 0.03923672 6.392333e-33
    ## 4               Simple mode   62 0.4678942 0.06009129 1.025743e-10
    ## 5             Weighted mode   62 0.5189450 0.03373384 1.148029e-22

``` r
mr_heterogeneity(dat)
```

    ##   id.exposure id.outcome                              outcome                        exposure
    ## 1   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7 LDL cholesterol || id:ieu-a-300
    ## 2   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7 LDL cholesterol || id:ieu-a-300
    ##                      method        Q Q_df       Q_pval
    ## 1                  MR Egger 170.9462   60 1.356009e-12
    ## 2 Inverse variance weighted 187.0110   61 1.021208e-14

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

    ## 
    ## 
    ## . use dat, cl(Written by R.              )
    ## 
    ## . ds, v(28)
    ## SNP                     pos                     proxy_a1_outcome
    ## effect_allele_exposure  se_outcome              proxy_a2_outcome
    ## other_allele_exposure   samplesize_outcome      exposure
    ## effect_allele_outcome   pval_outcome            chr_exposure
    ## other_allele_outcome    outcome                 pos_exposure
    ## beta_exposure           originalname_outcome    se_exposure
    ## beta_outcome            outcome_deprecated      pval_exposure
    ## eaf_exposure            mr_keep_outcome         mr_keep_exposure
    ## eaf_outcome             data_source_outcome     pval_origin_exposure
    ## remove                  proxy_outcome           id_exposure
    ## palindromic             target_snp_outcome      action
    ## ambiguous               proxy_snp_outcome       mr_keep
    ## id_outcome              target_a1_outcome       labels
    ## chr                     target_a2_outcome
    ## 
    ## . di _N
    ## 62

We can then run the IVW model using `mregger` with multiplicative
standard errors.

``` stata
qui use dat, clear
mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)], ivw
```

    ## 
    ## 
    ## . qui use dat, cl. mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)], ivw
    ## 
    ##                                                       Number of genotypes = 62
    ##                                               Residual standard error =  1.751
    ## ------------------------------------------------------------------------------
    ##              |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
    ## -------------+----------------------------------------------------------------
    ## beta_outcome |
    ## beta_expos~e |   .4689295   .0392367    11.95   0.000      .392027    .5458321
    ## ------------------------------------------------------------------------------

We then fit the MR-Egger, median, and modal based estimators.

``` stata
qui use dat, clear
mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)]

mrmedian beta_outcome se_outcome beta_exposure se_exposure, weighted

mrmodal beta_outcome se_outcome beta_exposure se_exposure, weighted
```

    ## 
    ## 
    ## . qui use dat, cl. mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)]
    ## 
    ##                                                       Number of genotypes = 62
    ##                                               Residual standard error =  1.688
    ## ------------------------------------------------------------------------------
    ##              |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
    ## -------------+----------------------------------------------------------------
    ## beta_outcome |
    ##        slope |   .5853125   .0619108     9.45   0.000     .4639696    .7066554
    ##        _cons |  -.0095226   .0040103    -2.37   0.018    -.0173826   -.0016626
    ## ------------------------------------------------------------------------------
    ## 
    ## . 
    ## . mrmedian beta_outcome se_outcome beta_exposure se_exposure, weighted
    ## 
    ##                                                       Number of genotypes = 62
    ##                                                            Replications = 1000
    ## ------------------------------------------------------------------------------
    ##              |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
    ## -------------+----------------------------------------------------------------
    ##         beta |   .4887676   .0360119    13.57   0.000     .4181856    .5593496
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
    ##         beta |    .518945   .0359903    14.42   0.000     .4484053    .5894848
    ## ------------------------------------------------------------------------------

And we could continue with additional Stata code (or indeed R code) as
we liked.

To run this `Rmd` file, open it in RStudio and click the `Knit` button
in the toolbar of the Source code window.

## References

  - Hemani et al. The MR-Base platform supports systematic causal
    inference across the human phenome. eLife, 2018;7:e34408
    <https://doi.org/10.7554/eLife.34408>
