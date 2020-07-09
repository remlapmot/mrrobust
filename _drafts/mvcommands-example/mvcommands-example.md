---
title: "mv commands"
author: "Tom Palmer"
date: "2020-07-02"
---

# mv commands

Read in the Do et al. example dataset.

```stata
. use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear
```


Select observations (p-value with LDL-C < 10<sup>-8</sup>)

```stata
. gen byte sel1 = (ldlcp2 < 1e-8)
```


## MV-IVW (MVMR)

Fit the multivariable inverse-variance weighted (MV-IVW) estimator with LDL-c and HDL-c [@burgess-aje-2015].

```stata
. mrmvivw chdbeta ldlcbeta hdlcbeta [aw=1/(chdse^2)] if sel1==1

                                                      Number of genotypes = 73
                                                      Number of phenotypes = 2
                                                Standard errors: Random effect
─────────────┬────────────────────────────────────────────────────────────────
             │      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
─────────────┼────────────────────────────────────────────────────────────────
    ldlcbeta │   .4670719   .0581901     8.03   0.000     .3530214    .5811224
    hdlcbeta │  -.2930048   .1211822    -2.42   0.016    -.5305175   -.0554921
─────────────┴────────────────────────────────────────────────────────────────
```


Additionally include a third phenotype -- triglycerides.

```stata
. mrmvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1

                                                      Number of genotypes = 73
                                                      Number of phenotypes = 3
                                                Standard errors: Random effect
─────────────┬────────────────────────────────────────────────────────────────
             │      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
─────────────┼────────────────────────────────────────────────────────────────
    ldlcbeta │     .42862   .0609661     7.03   0.000     .3091286    .5481113
    hdlcbeta │  -.1941989   .1308289    -1.48   0.138    -.4506189    .0622211
      tgbeta │   .2260456   .1232828     1.83   0.067    -.0155842    .4676755
─────────────┴────────────────────────────────────────────────────────────────
```


Report the Q<sub>A</sub> statistic for instrument validity and the conditional 
F-statistics for instrument strength for each phenotype [@sanderson-ije-2019; @sanderson-biorxiv-2020].

```stata
. mrmvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, ///
> gxse(ldlcse hdlcse tgse)

                                                      Number of genotypes = 73
                                                      Number of phenotypes = 3
                                                Standard errors: Random effect
─────────────┬────────────────────────────────────────────────────────────────
             │      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
─────────────┼────────────────────────────────────────────────────────────────
    ldlcbeta │     .42862   .0609661     7.03   0.000     .3091286    .5481113
    hdlcbeta │  -.1941989   .1308289    -1.48   0.138    -.4506189    .0622211
      tgbeta │   .2260456   .1232828     1.83   0.067    -.0155842    .4676755
─────────────┴────────────────────────────────────────────────────────────────
 Q_A statistic for instrument validity; chi2(70) = 152.88 (p =  0.0000)
 Conditional F-statistics for instrument strength:
 F_x1 = 130.31
 F_x2 = 36.29
 F_x3 = 40.44
 (numbers correspond to phenotype ordering in varlist)
```


## MVMR-Egger

Fit MVMR-Egger regression [@rees-statsmed-2017], by default orienting the model to the phenotype associated with the genotype-phenotype associations.

```stata
. mrmvegger chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1

                                       MVMR-Egger model oriented wrt: ldlcbeta
                                                      Number of genotypes = 73
                                                      Number of phenotypes = 3
─────────────┬────────────────────────────────────────────────────────────────
             │      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
─────────────┼────────────────────────────────────────────────────────────────
chdbeta      │
    ldlcbeta │   .5672993   .1002611     5.66   0.000      .370791    .7638075
    hdlcbeta │  -.1364113   .1332727    -1.02   0.306    -.3976209    .1247983
      tgbeta │   .2739803   .1246927     2.20   0.028     .0295871    .5183735
       _cons │  -.0093655   .0054187    -1.73   0.084     -.019986     .001255
─────────────┴────────────────────────────────────────────────────────────────
```


We can also orient the model wrt HDL-C instead of LDL-C.

```stata
. mrmvegger chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, ///
> orient(2)

                                       MVMR-Egger model oriented wrt: hdlcbeta
                                                      Number of genotypes = 73
                                                      Number of phenotypes = 3
─────────────┬────────────────────────────────────────────────────────────────
             │      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
─────────────┼────────────────────────────────────────────────────────────────
chdbeta      │
    ldlcbeta │   .4286398   .0614056     6.98   0.000      .308287    .5489926
    hdlcbeta │  -.1989637   .1541909    -1.29   0.197    -.5011723    .1032449
      tgbeta │   .2256794   .1243221     1.82   0.069    -.0179875    .4693463
       _cons │   .0002155   .0036218     0.06   0.953     -.006883    .0073141
─────────────┴────────────────────────────────────────────────────────────────
```


Or we can orient wrt triglycerides instead of LDL-C.

```stata
. mrmvegger chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, ///
> orient(3)

                                         MVMR-Egger model oriented wrt: tgbeta
                                                      Number of genotypes = 73
                                                      Number of phenotypes = 3
─────────────┬────────────────────────────────────────────────────────────────
             │      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
─────────────┼────────────────────────────────────────────────────────────────
chdbeta      │
    ldlcbeta │   .4203073   .0660026     6.37   0.000     .2909447      .54967
    hdlcbeta │  -.1903089   .1321536    -1.44   0.150    -.4493252    .0687075
      tgbeta │   .2065651   .1365427     1.51   0.130    -.0610537     .474184
       _cons │   .0013499    .003951     0.34   0.733    -.0063939    .0090936
─────────────┴────────────────────────────────────────────────────────────────
```


## References
