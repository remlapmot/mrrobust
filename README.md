# mrrobust: Stata package for two-sample Mendelian randomization analyses using summary data

## Short video introduction
[Click here for a short video demonstrating the use of the package.](https://drive.google.com/open?id=0B1owQlNgzNcPY0lMSGk0SnFfQWs)

[<img src="./img/mrconf2017_video_mrforest_screenshot.png" width="528" height="300" align="middle">](https://drive.google.com/open?id=0B1owQlNgzNcPY0lMSGk0SnFfQWs)

## Overview
The `mrrobust` package contains several commands implementing estimators robust to certain proportions of invalid instrumental variables. Such estimators are becoming widely used, especially in Mendelian randomization studies in epidemiology.

These commands are used with summary data of the genotype-phenotype and genotype-outcome associations. Such data can be obtained from MR-Base <http://www.mrbase.org> (Hemani et al. 2016).

In the package there are the following commands:
 - `mrratio` implements the standard instrumental variable ratio (Wald) estimate with a choice of standard errors/confidence intervals.
 - `mrivests` automates calling `mrratio` on all the selected genotypes in your dataset.
 - `mregger` implements the IVW and MR-Egger regression approaches introduced in Bowden et al. 2015. Use with summary data (per SNP/genotype associations with the disease outcome and exposure/phenotype).
 - `mrmedian` and `mrmedianobs` implement the unweighted, weighted, and penalized weighted median IV estimators robust to 50% invalid instruments in Bowden et al. 2016. Use `mrmedian` with summary data and `mrmedianobs` with individual level data.
 - `mrmodal` implements the zero modal estimator of Hartwig et al. 2017. Use with summary data.
 - `mreggerplot` implements a scatter plot with fitted line (either from IVW, MR-Egger, or weighted median estimators) and confidence interval.
 - `mrforest` implements a forest plot of genotype specific IV estimates and estimates from models (e.g. IVW and MR-Egger).

## Installation

This package uses Ben Jann's `addplot`, `kdens`, and `moremata` packages, the `heterogi` command by Orsini et al., the `metan` command (Harris et al.) and the `grc1leg` command (Wiggins). To install those use the following commands:
```
. ssc install addplot
. ssc install kdens
. ssc install moremata
. ssc install heterogi
. ssc install metan
. net install grc1leg, from(http://www.stata.com/users/vwiggins)
```

Then to install `mrrobust` issue in Stata (in versions 13 and above):
```
. net install mrrobust, from(https://raw.github.com/remlapmot/mrrobust/master/) replace
```

If you have previously installed the package and `net install` fails with an error message that there are two copies of the package installed simply run `adoupdate`. Also run `adoupdate` to check for updates. To update the package if you know an update is available run:
```
. adoupdate mrrobust, update
```

There is a summary helpfile listing the commands:
```
. help mrrobust
```

To view the helpfiles, which have examples near the end, for each command issue:
```
. help mrratio
. help mrivests
. help mregger
. help mrmedian
. help mrmedianobs
. help mrmodal
. help mreggerplot
. help mrforest
```

To uninstall the package, issue in Stata:
```
. ado uninstall mrrobust
```

### Stata version 12 and earlier
The `net install` syntax above does not work under Stata version 12 (and earlier versions) because this webpage has an address starting with https rather than http. In this case please download the files manually (either click the green "Clone or download" button above and then download as zip and then extract, or for each file right click over the filename above and click "Save link as..."). Then save the files on your adopath. 

In this case you also need to install the `addplot`, `kdens`, `moremata`, `heterogi`, and `metan` packages manually from SSC. 
 * The `moremata` package is available as a zip file here <http://fmwww.bc.edu/repec/bocode/m/moremata.zip>. 
 * The `addplot` package is available here <http://fmwww.bc.edu/repec/bocode/a/addplot.zip>. 
 * The `heterogi` command is available here <https://ideas.repec.org/c/boc/bocode/s449201.html>.
 * The `kdens` package is available here <http://fmwww.bc.edu/repec/bocode/k/kdens.zip>.
 * The `metan` command is available here <https://ideas.repec.org/c/boc/bocode/s456798.html>
 
Extract the zip archives and save all files on your adopath.

To uninstall a manual installation simply delete the files you placed on your adopath.

## Authors
Tom Palmer, Wesley Spiller, Neil Davies

## Citation
Spiller W, Davies NM, Palmer TM. Software Application Profile: mrrobust - A tool for performing two-sample summary Mendelian randomization analyses. bioRxiv, published online 25th May 2017. <https://doi.org/10.1101/142125>.

## References
 * Bowden J, Davey Smith G, Burgess S. Mendelian randomization with invalid instruments: effect estimation and bias detection through Egger regression. International Journal of Epidemiology, 2015, 44, 2, 512-525. <http://dx.doi.org/10.1093/ije/dyv080>
 * Bowden J, Davey Smith G, Haycock PC, Burgess S. Consistent estimation in Mendelian randomization with some invalid instruments using a weighted median estimator. Genetic Epidemiology, published online 7 April 2016. <http://dx.doi.org/10.1002/gepi.21965>
 * Hartwig FP, Davey Smith G, Bowden J. Robust inference in two-sample Mendelian randomisation via the zero modal pleiotropy assumption. bioRxiv. <http://dx.doi.org/10.1101/126102>
 * Hemani G et al. MR-Base: a platform for systematic causal inference across the phenome using billions of genetic associations. bioRxiv, 2016. <https://doi.org/10.1101/078972>

## Licence
CC-BY
