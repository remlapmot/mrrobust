---
title: markstat example
---

* [Run MR-Base from a Stata do-file or Stata Markdown script](#title)
  * [Introduction](#introduction)
  * [Extracting data from MR-Base](#extracting-data-from-mr-base)
  * [Performing the analysis using mrrobust in Stata](#performing-the-analysis-using-mrrobust-in-stata)
  * [References](#references)

# Run MR-Base from a Stata do-file or Stata Markdown script {#title}

## Introduction

This example shows how to run R and Stata code within the same Stata Markdown (`.stmd`) script. 
The general approach is detailed on the Stata Markdown website 
[here](https://data.princeton.edu/stata/markdown/quantiles) and 
[here](https://data.princeton.edu/stata/markdown/gettingStarted#R).

This means that we can use the functions provided by the 
[`TwoSampleMR`](https://github.com/MRCIEU/TwoSampleMR) package to obtain data from 
[MR-Base](https://www.mrbase.org/).

To see the `stmd` code which generates this page see 
[here](https://raw.githubusercontent.com/remlapmot/mrrobust/master/_drafts/markstat-call-R-example/markstat-call-R-example.stmd). 
You will see that the file is written in markdown and includes R and Stata code chunks.

Before you start please install the following two Stata packages from the SSC archive, so in Stata 
issue the following commands (I have commented them out because I have already installed them).

```stata
. * ssc install whereis
. * ssc install markstat
```


We first need to register the R executable with Stata.

```stata
. if c(os) == "Windows" local rpath "C:\\Program Files\\R\\R-4.2.2\\bin\\x64\\R.exe"

. else if c(os) == "Unix" local rpath "/usr/bin/R"

. else local rpath "/usr/local/bin/R"

. whereis R "`rpath'"
C:\\Program Files\\R\\R-4.2.2\\bin\\x64\\R.exe
```


Next we have an R code chunk in which we install the required packages in R.

```r
> if (!requireNamespace("remotes", quietly = TRUE)) install.packages("remotes")
> if (!requireNamespace("TwoSampleMR", quietly = TRUE)) remotes::install_github("MRCIEU/TwoSampleMR")
> if (!requireNamespace("MRInstruments", quietly = TRUE)) remotes::install_github("MRCIEU/MRInstruments")
```


## Extracting data from MR-Base

We will be running the script from the MR-Base paper 
([Hemani et al., 2018](https://doi.org/10.7554/eLife.34408)). The R code we will use is from 
[here](https://raw.githubusercontent.com/explodecomputer/mr-base-methods-paper/master/scripts/ldl-chd.R).

First, we load the packages into our R session. Note that the `foreign` package provides the 
`write.dta()` function which we will use to save the data in Stata format.

```r
> library(TwoSampleMR)
> library(MRInstruments)
> library(foreign)
```


Our edited version of the code starts by reading in some code to generate a set of plots in R.

```r
> source("mrplots.R")
```


We can access the data using the `MRInstruments` package.

```r
> data(gwas_catalog)
> 
> # Get published SNPs for LDL cholesterol
> ldl_snps <- subset(gwas_catalog, grepl("LDL choles", Phenotype) & Author == "Willer CJ")$SNP
> 
> # Extract from GLGC dataset
> exposure <- convert_outcome_to_exposure(extract_outcome_data(ldl_snps, "ieu-a-300"))
> 
> # Get outcome data from Cardiogram 2015
> outcome <- extract_outcome_data(exposure$SNP, "ieu-a-7")
> 
> # Harmonise exposure and outcome datasets
> # Assume alleles are on the forward strand
> dat <- harmonise_data(exposure, outcome, action=1)
```

At this point we have our harmonised genotype-exposure and genotype-outcome association data saved 
in an object in our R session called `dat`.

The next two code chunks perform the analysis in R.

```r
> # Perform MR
> mr(dat)
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
2 0.03807123 1.013424e-37
3 0.03919370 6.000986e-33
4 0.06472604 9.363083e-10
5 0.03164044 4.876146e-24
> mr_heterogeneity(dat)
  id.exposure id.outcome                              outcome
1   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7
2   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7
                         exposure                    method        Q Q_df
1 LDL cholesterol || id:ieu-a-300                  MR Egger 170.4804   60
2 LDL cholesterol || id:ieu-a-300 Inverse variance weighted 186.6560   61
        Q_pval
1 1.583556e-12
2 1.154072e-14
> dat$exposure <- "LDL cholesterol"
> dat$outcome <- "Coronary heart disease"
> 
> # Label outliers and create plots
> dat$labels <- dat$SNP
> dat$labels[! dat$SNP %in% c("rs11065987", "rs1250229", "rs4530754")] <- NA
```



```r
> png("ldl-chd.png", width=1000, height=1000)
> mr_plots(dat)
> dev.off()
null device 
          1 
```


![Plots generated `TwoSampleMR`.](ldl-chd.png)

We now save our `dat` object as a Stata dataset.

```r
> write.dta(dat, file = "dat.dta")
```


## Performing the analysis using mrrobust in Stata

We now switch from using R code chunks to Stata code chunks. We read the data into Stata and list 
the variable names (note any `.` in the colnames of `dat` have been replaced with `_`).

```stata
. use dat, clear
(Written by R.              )

. ds, v(28)
SNP                     remove                  outcome                 target_a2_outcome       pval_origin_exposure
effect_allele_exposure  palindromic             originalname_outcome    proxy_a1_outcome        id_exposure
other_allele_exposure   ambiguous               outcome_deprecated      proxy_a2_outcome        action
effect_allele_outcome   id_outcome              mr_keep_outcome         exposure                mr_keep
other_allele_outcome    chr                     data_source_outcome     chr_exposure            labels
beta_exposure           pos                     proxy_outcome           pos_exposure
beta_outcome            se_outcome              target_snp_outcome      se_exposure
eaf_exposure            samplesize_outcome      proxy_snp_outcome       pval_exposure
eaf_outcome             pval_outcome            target_a1_outcome       mr_keep_exposure

. di _N
62
```


We can then run the IVW model using `mregger` with multiplicative standard errors.

```stata
. mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)], ivw

                                                      Number of genotypes = 62
                                              Residual standard error =  1.749
──────────────┬────────────────────────────────────────────────────────────────
              │ Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
──────────────┼────────────────────────────────────────────────────────────────
beta_outcome  │
beta_exposure │   .4686211   .0391937    11.96   0.000     .3918029    .5454394
──────────────┴────────────────────────────────────────────────────────────────
```


It is helpful to view the forest plot of genotype specific IV estimates.

```stata
. mrforest beta_outcome se_outcome beta_exposure se_exposure, ivid(SNP) ///
> xlabel(-3,-2,-1,0,1,2,3)

. graph export ldl-chd-mrforest.svg, width(600) replace
file ldl-chd-mrforest.svg saved as SVG format
```


![Forest plot of genotype specific IV estimates.](ldl-chd-mrforest.svg)

We can visualise this model with `mreggerplot`.

```stata
. mreggerplot beta_outcome se_outcome beta_exposure se_exposure

. graph export ldl-chd-mreggerplot.svg, width(600) replace
file ldl-chd-mreggerplot.svg saved as SVG format
```


![Plot of the MR-Egger model.](ldl-chd-mreggerplot.svg)

We then fit the MR-Egger, median, and modal based estimators.

```stata
. mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)]

                                                      Number of genotypes = 62
                                              Residual standard error =  1.686
─────────────┬────────────────────────────────────────────────────────────────
             │ Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
─────────────┼────────────────────────────────────────────────────────────────
beta_outcome │
       slope │   .5854136   .0618259     9.47   0.000     .4642371    .7065902
       _cons │  -.0095539   .0040042    -2.39   0.017    -.0174019   -.0017059
─────────────┴────────────────────────────────────────────────────────────────
```



```stata
. mrmedian beta_outcome se_outcome beta_exposure se_exposure, weighted

                                                      Number of genotypes = 62
                                                           Replications = 1000
─────────────┬────────────────────────────────────────────────────────────────
             │ Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
─────────────┼────────────────────────────────────────────────────────────────
        beta │   .4887683   .0359701    13.59   0.000     .4182682    .5592685
─────────────┴────────────────────────────────────────────────────────────────
```



```stata
. mrmodal beta_outcome se_outcome beta_exposure se_exposure, weighted

                                                      Number of genotypes = 62
                                                           Replications = 1000
                                                                       Phi = 1
─────────────┬────────────────────────────────────────────────────────────────
             │ Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
─────────────┼────────────────────────────────────────────────────────────────
        beta │    .518945   .0361584    14.35   0.000     .4480759    .5898141
─────────────┴────────────────────────────────────────────────────────────────
```


And we could continue with additional Stata code (or indeed R code) as we liked.

Note to run this `.stmd` file in Stata we do so with the following command (specifying additional 
options as required, see `help markstat` for more information).
```
markstat using markstat-call-R-example
```

## References

- Hemani et al. The MR-Base platform supports systematic causal inference across the human phenome. 
eLife, 2018;7:e34408 <https://doi.org/10.7554/eLife.34408>
