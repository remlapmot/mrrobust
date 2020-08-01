---
title: Collect and export results
author: Tom Palmer
date: 2020-01-23
---

# Example demonstrating how to collect and export results

* [Setup example data](#setup-example-data)
* [Fit estimators - collecting results using `r(table)` matrix](#fit)
* [Combine and export results](#combine-and-export-results)

This example shows how to conveniently save and export your estimates using the `r(table)` matrix 
that is now returned by each command.

## Setup example data

```stata
. use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear
```


Select observations (p-value with exposure < 10^-8)

```stata
. gen byte sel1 = (ldlcp2 < 1e-8)
```


## Fit estimators - collecting results using `r(table)` matrix {#fit}

IVW (with fixed effect standard errors)

```stata
. mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw fe

                                                      Number of genotypes = 73
                                      Residual standard error constrained at 1
─────────────┬────────────────────────────────────────────────────────────────
             │      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
─────────────┼────────────────────────────────────────────────────────────────
chdbeta      │
    ldlcbeta │   .4815055    .038221    12.60   0.000     .4065938    .5564173
─────────────┴────────────────────────────────────────────────────────────────

. mat ivw = r(table)
```


MR-Egger (with SEs using an unconstrained residual variance)

```stata
. mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1

                                                      Number of genotypes = 73
                                              Residual standard error =  1.548
─────────────┬────────────────────────────────────────────────────────────────
             │      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
─────────────┼────────────────────────────────────────────────────────────────
chdbeta      │
       slope │   .6173131   .1034573     5.97   0.000     .4145405    .8200858
       _cons │  -.0087706   .0054812    -1.60   0.110    -.0195136    .0019723
─────────────┴────────────────────────────────────────────────────────────────

. mat mregger = r(table)
```


MR-Egger using the radial formulation

```stata
. mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, radial

                                                      Number of genotypes = 73
                                              Residual standard error =  1.547
─────────────┬────────────────────────────────────────────────────────────────
             │      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
─────────────┼────────────────────────────────────────────────────────────────
radialGD     │
    radialGP │    .642582   .1157871     5.55   0.000     .4156434    .8695205
       _cons │  -.5737301   .3545658    -1.62   0.106    -1.268666    .1212062
─────────────┴────────────────────────────────────────────────────────────────

. mat radial = r(table)
```


Weighted mode estimator

```stata
. mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted

                                                      Number of genotypes = 73
                                                           Replications = 1000
                                                                       Phi = 1
─────────────┬────────────────────────────────────────────────────────────────
             │      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
─────────────┼────────────────────────────────────────────────────────────────
        beta │   .4789702   .0672551     7.12   0.000     .3471526    .6107879
─────────────┴────────────────────────────────────────────────────────────────

. mat mode = r(table)
```


Weighted median estimator

```stata
. mrmedian chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted

                                                      Number of genotypes = 73
                                                           Replications = 1000
─────────────┬────────────────────────────────────────────────────────────────
             │      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
─────────────┼────────────────────────────────────────────────────────────────
        beta │   .4582573   .0657043     6.97   0.000     .3294793    .5870354
─────────────┴────────────────────────────────────────────────────────────────

. mat median = r(table)
```


## Combine and export results

Check our matrices

```stata
. mat dir
       median[9,1]
         mode[9,1]
       radial[9,2]
      mregger[9,2]
          ivw[9,1]

. mat list ivw

ivw[9,1]
          chdbeta:
         ldlcbeta
     b  .48150551
    se  .03822098
     z  12.597937
pvalue  2.167e-36
    ll  .40659377
    ul  .55641726
    df          .
  crit   1.959964
 eform          0

. mat list mregger

mregger[9,2]
           chdbeta:    chdbeta:
             slope       _cons
     b   .61731315  -.00877065
    se   .10345735   .00548118
     z   5.9668371    -1.60014
pvalue   2.419e-09   .10956752
    ll   .41454047  -.01951356
    ul   .82008582   .00197226
    df           .           .
  crit    1.959964    1.959964
 eform           0           0

. mat list radial

radial[9,2]
          radialGD:   radialGD:
          radialGP       _cons
     b   .64258196  -.57373006
    se   .11578709   .35456584
     z   5.5496858    -1.61812
pvalue   2.862e-08   .10563675
    ll   .41564344  -1.2686663
    ul   .86952048   .12120621
    df           .           .
  crit    1.959964    1.959964
 eform           0           0

. mat list mode

mode[9,1]
             beta
     b   .4789702
    se  .06725514
     z  7.1216895
pvalue  1.066e-12
    ll  .34715256
    ul  .61078785
    df          .
  crit   1.959964
 eform          0

. mat list median

median[9,1]
             beta
     b  .45825733
    se  .06570429
     z  6.9745418
pvalue  3.069e-12
    ll  .32947928
    ul  .58703537
    df          .
  crit   1.959964
 eform          0
```


Combined into single matrix

```stata
. mat output = (ivw, mregger, radial, mode, median)

. mat colnames output = ivw_beta mregger_beta mregger_cons ///
> radial_beta radial_cons mode_beta median_beta

. mat coleq output = "" "" "" "" "" "" ""

. mat output = output'

. mat list output, format(%4.3f)

output[7,9]
                   b      se       z  pvalue      ll      ul      df    crit   eform
    ivw_beta   0.482   0.038  12.598   0.000   0.407   0.556       .   1.960   0.000
mregger_beta   0.617   0.103   5.967   0.000   0.415   0.820       .   1.960   0.000
mregger_cons  -0.009   0.005  -1.600   0.110  -0.020   0.002       .   1.960   0.000
 radial_beta   0.643   0.116   5.550   0.000   0.416   0.870       .   1.960   0.000
 radial_cons  -0.574   0.355  -1.618   0.106  -1.269   0.121       .   1.960   0.000
   mode_beta   0.479   0.067   7.122   0.000   0.347   0.611       .   1.960   0.000
 median_beta   0.458   0.066   6.975   0.000   0.329   0.587       .   1.960   0.000
```


Export matrix to dataset

```stata
. drop _all

. svmat output, names(col)
number of observations will be reset to 7
Press any key to continue, or Break to abort
number of observations (_N) was 0, now 7

. local rownames : rownames output

. di "`rownames'"
ivw_beta mregger_beta mregger_cons radial_beta radial_cons mode_beta median_beta

. tokenize `rownames'

. gen str15 estimate = ""
(7 missing values generated)

. forvalues i = 1/7 {
  2. replace estimate = "``i''" in `i'
  3. }
(1 real change made)
(1 real change made)
(1 real change made)
(1 real change made)
(1 real change made)
(1 real change made)
(1 real change made)
```


Show dataset

```stata
. list estimate b se z pvalue ll ul, clean noobs

        estimate           b         se          z     pvalue          ll         ul  
        ivw_beta    .4815055    .038221   12.59794   2.17e-36    .4065938   .5564172  
    mregger_beta    .6173131   .1034573   5.966837   2.42e-09    .4145405   .8200858  
    mregger_cons   -.0087707   .0054812   -1.60014   .1095675   -.0195136   .0019723  
     radial_beta    .6425819   .1157871   5.549686   2.86e-08    .4156434   .8695205  
     radial_cons   -.5737301   .3545658   -1.61812   .1056367   -1.268666   .1212062  
       mode_beta    .4789702   .0672551   7.121689   1.07e-12    .3471526   .6107879  
     median_beta    .4582573   .0657043   6.974542   3.07e-12    .3294793   .5870354  
```


Save dataset

```stata
. save myestimates, replace
file myestimates.dta saved
```


Export as tab-delimited textfile

```stata
. export delimited using myestimates.txt, delimiter(tab) replace
file myestimates.txt saved
```

