---
title: markstat example
---

# Run MR-Base from a Stata do-file/Markdown script

## Introduction

This example shows how to run R and Stata code within the same Stata Markdown (`.stmd`) script. The general approach is detailed on the Stata Markdown website [here](https://data.princeton.edu/stata/markdown/quantiles) and [here](https://data.princeton.edu/stata/markdown/gettingStarted#R).

This means that we can use the functions provided by the [`TwoSampleMR`](https://github.com/MRCIEU/TwoSampleMR) package to obtain data from [MR-Base](http://www.mrbase.org/).

To see the `stmd` code which generates this page see [here](https://raw.githubusercontent.com/remlapmot/mrrobust/master/_drafts/markstat-call-R-example/markstat-call-R-example.stmd). You will see that the file is written in markdown and includes R and Stata code chunks.

Before you start please install the following two Stata packages from the SSC archive, so in Stata issue the following commands (I have commented them out because I have already installed them).

```stata
. * ssc install whereis
. * ssc install markstat
```


We first need to register the R executable with Stata.

```stata
. whereis R "C:\\Program Files\\R\\R-4.0.2\\bin\\R.exe"
C:\\Program Files\\R\\R-4.0.2\\bin\\R.exe
```


Next we have an R code chunk in which we install the required packages in R (again I have commented these lines out because I already have them installed).

```r
> # install.packages("devtools")
> # devtools::install_github("MRCIEU/TwoSampleMR")
> # devtools::install_github("MRCIEU/MRInstruments")
```


We will be running the script from the MR-Base paper ([Hemani et al., 2018](https://doi.org/10.7554/eLife.34408)). The R code we will use is from [here](https://raw.githubusercontent.com/explodecomputer/mr-base-methods-paper/master/scripts/ldl-chd.R).

First, we load the packages into our R session. Note that the `foreign` package provides the `write.dta()` function which we will use to save the data in Stata format.

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
  id.exposure id.outcome                              outcome
1   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7
2   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7
3   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7
4   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7
5   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7
                         exposure                    method nsnp         b
1 LDL cholesterol || id:ieu-a-300                  MR Egger   62 0.5853125
2 LDL cholesterol || id:ieu-a-300           Weighted median   62 0.4887311
3 LDL cholesterol || id:ieu-a-300 Inverse variance weighted   62 0.4689295
4 LDL cholesterol || id:ieu-a-300               Simple mode   62 0.4678942
5 LDL cholesterol || id:ieu-a-300             Weighted mode   62 0.5189450
          se         pval
1 0.06191076 1.712795e-13
2 0.03895722 4.216716e-36
3 0.03923672 6.392333e-33
4 0.06216638 2.876028e-10
5 0.03194083 7.807418e-24
> mr_heterogeneity(dat)
  id.exposure id.outcome                              outcome
1   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7
2   ieu-a-300    ieu-a-7 Coronary heart disease || id:ieu-a-7
                         exposure                    method        Q Q_df
1 LDL cholesterol || id:ieu-a-300                  MR Egger 170.9462   60
2 LDL cholesterol || id:ieu-a-300 Inverse variance weighted 187.0110   61
        Q_pval
1 1.356009e-12
2 1.021208e-14
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


We now switch from using R code chunks to Stata code chunks. We read the data into Stata and list the variable names (note any `.` in the colnames of `dat` have been replaced with `_`).

```stata
. use dat, clear
(Written by R.              )

. ds, v(28)
SNP                     ncontrol_outcome        target_a1_outcome
effect_allele_exposure  pval_outcome            target_a2_outcome
other_allele_exposure   units_outcome           proxy_a1_outcome
effect_allele_outcome   outcome                 proxy_a2_outcome
other_allele_outcome    consortium_outcome      exposure
beta_exposure           year_outcome            se_exposure
beta_outcome            pmid_outcome            pval_exposure
eaf_exposure            category_outcome        units_exposure
eaf_outcome             subcategory_outcome     mr_keep_exposure
remove                  originalname_outcome    pval_origin_exposure
palindromic             outcome_deprecated      units_exposure_dat
ambiguous               mr_keep_outcome         id_exposure
id_outcome              data_source_outcome     action
se_outcome              proxy_outcome           mr_keep
samplesize_outcome      target_snp_outcome      labels
ncase_outcome           proxy_snp_outcome

. di _N
62
```


We can then run the IVW model using `mregger` with multiplicative standard errors.

```stata
. mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)], ivw

                                                      Number of genotypes = 62
                                              Residual standard error =  1.749
─────────────┬────────────────────────────────────────────────────────────────
             │      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
─────────────┼────────────────────────────────────────────────────────────────
beta_outcome │
beta_expos~e │   .4686211   .0391937    11.96   0.000     .3918029    .5454394
─────────────┴────────────────────────────────────────────────────────────────
```


It is helpful to view the forest plot of genotype specific IV estimates.

```stata
. decode SNP, gen(rsid)

. mrforest beta_outcome se_outcome beta_exposure se_exposure, ivid(rsid)

. graph export ldl-chd-mrforest.svg, width(600) replace
(file ldl-chd-mrforest.svg written in SVG format)
```


![Forest plot of genotype specific IV estimates.](ldl-chd-mrforest.svg)

We can visualise this model with `mreggerplot`.

```stata
. mreggerplot beta_outcome se_outcome beta_exposure se_exposure

. graph export ldl-chd-mreggerplot.svg, width(600) replace
(file ldl-chd-mreggerplot.svg written in SVG format)
```


![Plot of the MR-Egger model.](ldl-chd-mreggerplot.svg)

We then fit the MR-Egger, median, and modal based estimators.

```stata
. mregger beta_outcome beta_exposure [aw=1/(se_outcome^2)]

                                                      Number of genotypes = 62
                                              Residual standard error =  1.686
─────────────┬────────────────────────────────────────────────────────────────
             │      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
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
             │      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
─────────────┼────────────────────────────────────────────────────────────────
        beta │   .4887683   .0376206    12.99   0.000     .4150334    .5625033
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
        beta │    .518945   .0363605    14.27   0.000     .4476798    .5902102
─────────────┴────────────────────────────────────────────────────────────────
```


And we could continue with additional Stata code (or indeed R code) as we liked.

Note to run this `.stmd` file in Stata we do so with the following command (specifying additional options as required, see `help markstat` for more information).
```
markstat using markstat-call-R-example
```

## References

- Hemani et al. The MR-Base platform supports systematic causal inference across the human phenome. eLife, 2018;7:e34408 <https://doi.org/10.7554/eLife.34408>
