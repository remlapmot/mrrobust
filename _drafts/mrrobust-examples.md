---
title: "Examples from the mrrobust helpfiles"
author: "Tom Palmer"
date: "17 May 2018"
---

# Install dependencies and `mrrobust` package
```
ssc install addplot
ssc install kdens
ssc install moremata
ssc install heterogi
ssc install metan
net install grc1leg, from(http://www.stata.com/users/vwiggins)
net install mrrobust, from(https://raw.github.com/remlapmot/mrrobust/master/) replace
```
    
# Examples

Read in example data.

{{1}}


Select observations (*p*-value with exposure < 10^-8^).

{{2}}



## `mrforest` examples
Forest plot of genotype specific IV estimates and IVW and MR-Egger estimates, 
labelling the genotypes with their RSID.

{{3}}

![Example forest plot of genotype specific IV estimates](mrforest.svg){.img-responsive .center-block}


## `mregger` examples
Using the data provided by Do et al., Nat Gen, 2013 recreate Bowden et al., 
Gen Epi, 2016, Table 4, LDL-c "All genetic variants" estimates.

IVW (with fixed effect standard errors, i.e. variance of residuals 
[residual variance] constrained to 1).

{{4}}


MR-Egger (with SEs using an unconstrained residual variance 
[multiplicative random effects]).

{{5}}


MR-Egger reporting I^2_GX statistic and heterogeneity Q-test.

{{6}}


MR-Egger using a t-distribution for inference (p-values) & CI limits.

{{7}}


MR-Egger using the radial formulation.

{{8}}


MR-Egger using the radial formulation and reporting heterogeneity (Rucker's) Q-test.

{{9}}



## `mreggersimex` examples
SIMEX suppressing bootstrapped SEs (for speed - remove `noboot` option to obtain 
SEs).

{{10}}

![SIMEX applied to the MR-Egger model](mreggersimex-plot.svg){.img-responsive .center-block}


## `mreggerplot` examples

{{11}}

![Scatter plot of the MR-Egger model](mreggerplot.svg){.img-responsive .center-block}


## `mrmedian` examples
Weighted median estimator.

{{12}}



## `mrmodal` examples

{{13}}

![Densities of the IV estimates using different values of phi](mrmodalplot.svg){.img-responsive .center-block}

Simple mode estimator.

{{14}}


Weighted mode estimator.

{{15}}


Simple mode estimator with NOME assumption.

{{16}}



## `mrfunnel` examples

{{17}}

![Example funnel plot](mrfunnel.svg){.img-responsive .center-block}
