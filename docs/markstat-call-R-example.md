---
title: markstat example
---

## Introduction

This example shows how to run R and Stata code within the same Stata Markdown (`.stmd`) script. The general approach is detailed on the Stata Markdown website [here](https://data.princeton.edu/stata/markdown/quantiles) and [here](https://data.princeton.edu/stata/markdown/gettingStarted#R).

This means that we can use the functions provided by the [`TwoSampleMR`](https://github.com/MRCIEU/TwoSampleMR) package to obtain data from [MR-Base](http://www.mrbase.org/).

To see the `stmd` code which generates this page see [here](./markstat-call-R-example.stmd). It consists of R code chunks and Stata code chunks.

Before you start please install the following two Stata packages from the SSC archive.
```
ssc install whereis
ssc install markstat
```

We first need to register the R executable with Stata.

```stata
. whereis R "C:\\Program Files\\R\\R-3.5.1\\bin\\R.exe"
C:\\Program Files\\R\\R-3.5.1\\bin\\R.exe
```


Next we install the required packages in R. Note I have commented these lines out because I already have these packages installed.

```r
> #install.packages("devtools")
> #devtools::install_github("MRCIEU/TwoSampleMR")
> #devtools::install_github("MRCIEU/MRInstruments")
```


We will be running the script from the MR-Base paper ([Hemani et al., 2018](https://doi.org/10.7554/eLife.34408)). The R code we will use is from [here](https://raw.githubusercontent.com/explodecomputer/mr-base-methods-paper/master/scripts/ldl-chd.R).

First, we load the packages into our R session. Note that the `foreign` package provides the `write.dta()` function which we will use to save the data in Stata format.

```r
> library(TwoSampleMR)
> library(MRInstruments)
> library(foreign)
```


Our version of the code starts by reading in some code to generate a set of plots in R.

```r
> source("mrplots.R")
```


Now we can access the data using the `MRInstruments` package.

```r
> data(gwas_catalog)
> 
> # Get published SNPs for LDL cholesterol
> ldl_snps <- subset(gwas_catalog, grepl("LDL choles", Phenotype) & Author == "Willer CJ")$SNP
> 
> # Extract from GLGC dataset
> exposure <- convert_outcome_to_exposure(extract_outcome_data(ldl_snps, 300))
> 
> # Get outcome data from Cardiogram 2015
> outcome <- extract_outcome_data(exposure$SNP, 7)
> 
> # Harmonise exposure and outcome datasets
> # Assume alleles are on the forward strand
> dat <- harmonise_data(exposure, outcome, action=1)
```

At this point we have our harmonised genotype-exposure and genotype-outcome association data saved in an object in our R session called `dat`.

The next two code chunks perform the analysis in R.

```r
> # Perform MR
> mr(dat)
  id.exposure id.outcome                        outcome
1         300          7 Coronary heart disease || id:7
2         300          7 Coronary heart disease || id:7
3         300          7 Coronary heart disease || id:7
4         300          7 Coronary heart disease || id:7
5         300          7 Coronary heart disease || id:7
                   exposure                    method nsnp         b         se
1 LDL cholesterol || id:300                  MR Egger   62 0.5854136 0.06182590
2 LDL cholesterol || id:300           Weighted median   62 0.4887319 0.03913398
3 LDL cholesterol || id:300 Inverse variance weighted   62 0.4686211 0.03919370
4 LDL cholesterol || id:300               Simple mode   62 0.4678942 0.06294220
5 LDL cholesterol || id:300             Weighted mode   62 0.5189450 0.03400655
          pval
1 1.619410e-13
2 8.606446e-36
3 6.000986e-33
4 4.155456e-10
5 1.698074e-22
> mr_heterogeneity(dat)
  id.exposure id.outcome                        outcome
1         300          7 Coronary heart disease || id:7
2         300          7 Coronary heart disease || id:7
                   exposure                    method        Q Q_df
1 LDL cholesterol || id:300                  MR Egger 170.4804   60
2 LDL cholesterol || id:300 Inverse variance weighted 186.6560   61
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


We now save our `dat` object as a Stata dataset.

```r
> write.dta(dat, file = "dat.dta")
```


We now switch from using R code chunks to Stata code chunks. We read the data into Stata and list the variable names (note any `.` in the colnames of `dat` have been replaced with `_`).

```stata
. use dat, clear
(Written by R.              )

. ds, v(28)
SNP                     id_outcome              subcategory_outcome     exposure
effect_allele_exposure  se_outcome              originalname_outcome    se_exposure
other_allele_exposure   samplesize_outcome      outcome_deprecated      pval_exposure
effect_allele_outcome   ncase_outcome           mr_keep_outcome         units_exposure
other_allele_outcome    ncontrol_outcome        data_source_outcome     mr_keep_exposure
beta_exposure           pval_outcome            proxy_outcome           pval_origin_exposure
beta_outcome            units_outcome           target_snp_outcome      units_exposure_dat
eaf_exposure            outcome                 proxy_snp_outcome       id_exposure
eaf_outcome             consortium_outcome      target_a1_outcome       action
remove                  year_outcome            target_a2_outcome       mr_keep
palindromic             pmid_outcome            proxy_a1_outcome        labels
ambiguous               category_outcome        proxy_a2_outcome

. di _N
62
```


We can then run the IVW model using `mregger` with multiplicative standard errors.

```stata
. mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)], ivw

                                                      Number of genotypes = 62
──────────────┬────────────────────────────────────────────────────────────────
              │      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
──────────────┼────────────────────────────────────────────────────────────────
beta_outcome  │
beta_exposure │   .4686211   .0391937    11.96   0.000     .3918029    .5454394
──────────────┴────────────────────────────────────────────────────────────────
```


We then fit the MR-Egger, median, and modal based estimators.

```stata
. mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)]

                                                      Number of genotypes = 62
─────────────┬────────────────────────────────────────────────────────────────
             │      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
─────────────┼────────────────────────────────────────────────────────────────
sign(beta~re)│
beta_outcome │
       slope │   .5854136   .0618259     9.47   0.000     .4642371    .7065902
       _cons │  -.0095539   .0040042    -2.39   0.017    -.0174019   -.0017059
─────────────┴────────────────────────────────────────────────────────────────
Residual standard error:  1.686
```



```stata
. mrmedian beta_outcome se_outcome beta_exposure se_exposure, weighted

                                                      Number of genotypes = 62
                                                           Replications = 1000
─────────────┬────────────────────────────────────────────────────────────────
             │      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
─────────────┼────────────────────────────────────────────────────────────────
        beta │   .4887683   .0387849    12.60   0.000     .4127512    .5647854
─────────────┴────────────────────────────────────────────────────────────────
```



```stata
. mrmodal beta_outcome se_outcome beta_exposure se_exposure, weighted

                                                      Number of genotypes = 62
                                                           Replications = 1000
                                                                       Phi = 1
─────────────┬────────────────────────────────────────────────────────────────
             │      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
─────────────┼────────────────────────────────────────────────────────────────
        beta │    .518945   .0360917    14.38   0.000     .4482067    .5896834
─────────────┴────────────────────────────────────────────────────────────────
```


And we could continue with additional Stata code (or indeed R code) as we liked.

Note to run this `.stmd` file in Stata we do so with the following command (specifying additional options as required, see `help markstat` for more information).
```
markstat using markstat-call-R-example
```

## References

- Hemani et al. The MR-Base platform supports systematic causal inference across the human phenome. eLife, 2018;7:e34408 <https://doi.org/10.7554/eLife.34408>
