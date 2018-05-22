# mrrobust: Stata package for two-sample Mendelian randomization analyses using summary data

[Short video introduction](#short-video-introduction)<br>
[Helpfil examples](#helpfile-examples)<br>
[Overview](#overview)<br>
[Installation](#installation)<br>
[Authors](#authors)<br>
[How to cite the mrrobust package](#how-to-cite-the-mrrobust-package)<br>
[References](#references)<br>
[Acknowledgements](#acknowledgements)

## Short video introduction
[Click here for a short video demonstrating the use of the package.](https://drive.google.com/open?id=0B1owQlNgzNcPY0lMSGk0SnFfQWs)

[<img src="./img/mrconf2017_video_mrforest_screenshot.png" width="528" height="300">](https://drive.google.com/open?id=0B1owQlNgzNcPY0lMSGk0SnFfQWs)

## Helpfile examples
[Click here for some of the code and output for the examples in the helpfile.](./mrrobust-examples/mrrobust-examples.html)

## Overview
The `mrrobust` package is a collection of commands for performing two-sample Mendelian randomization analyses using summary data of genotype-phenotype and genotype-outcome associations. 

Such data can be obtained from repositories such as MR-Base <http://www.mrbase.org> (Hemani et al. 2016).

The package contains the following commands:
 - `mrratio` implements the standard instrumental variable ratio (Wald) estimate with a choice of standard errors/confidence intervals.
 - `mrivests` automates calling `mrratio` on all the selected genotypes in your dataset.
 - `mregger` implements the IVW and MR-Egger regression approaches introduced in Bowden et al. 2015.
 - `mreggersimex` implements the simulation extrapolation algorithm for the MR-Egger model.
 - `mreggerplot` implements a scatter plot with fitted line (either from IVW, MR-Egger, or weighted median estimators) and confidence interval.
 - `mrmedian` and `mrmedianobs` implement the unweighted, weighted, and penalized weighted median IV estimators robust to 50% invalid instruments in Bowden et al. 2016.
 - `mrmodal` implements the zero modal estimator of Hartwig et al. 2017.
 - `mrmodalplot` plot of density used in modal estimator.
 - `mrforest` implements a forest plot of genotype specific IV estimates and estimates from models (e.g. IVW and MR-Egger).
 - `mrfunnel` funnel plot of genotype specific IV estimates.

## Installation
### Stata version 13 and later

First install the dependencies. The package uses Ben Jann's `addplot`, `kdens`, and `moremata` packages, the `heterogi` command (Orsini et al.), the `metan` command (Harris et al.), and the `grc1leg` command (Wiggins). Install those using the following commands:
```
ssc install addplot
ssc install kdens
ssc install moremata
ssc install heterogi
ssc install metan
net install grc1leg, from(http://www.stata.com/users/vwiggins)
```

To install `mrrobust` issue in Stata (in versions 13 and above):
```
net install mrrobust, from(https://raw.github.com/remlapmot/mrrobust/master/) replace
```

If you have previously installed the package and the `net install` command above fails with an error message that there are two copies of the package installed simply run `adoupdate`. Also run `adoupdate` to check for updates. To update the package if you know an update is available run:
```
adoupdate mrrobust, update
```

There is a summary helpfile:
```
help mrrobust
```

The helpfile for each command has an example near the end:
```
help mrratio
help mrivests
help mregger
help mreggersimex
help mreggerplot
help mrmedian
help mrmedianobs
help mrmodal
help mrmodalplot
help mrforest
help mrfunnel
```

To uninstall the package, issue in Stata:
```
ado uninstall mrrobust
```
If this fails with an error mentioning multiple citations/instances of the package being installed simply issue `adoupdate mrrobust` which will leave you with just one instance of the package (which can then be uninstalled).

### Stata version 12 and earlier
The `net install` syntax for installing `mrrobust` above does not work under Stata version 12 (and earlier versions) because this webpage has an address starting with https rather than http. However, the installation commands for the other dependencies should work.

To download `mrrobust` manually click the green "Clone or download" button above and then download as a zip archive. Then extract the zip archive on your computer. Then move the extracted files to your `adopath`. 

If you need to install the other commands manually: 
 * The `moremata` package is available as a zip file here <http://fmwww.bc.edu/repec/bocode/m/moremata.zip>. 
 * The `addplot` package is available here <http://fmwww.bc.edu/repec/bocode/a/addplot.zip>. 
 * The `heterogi` command is available here <https://ideas.repec.org/c/boc/bocode/s449201.html>.
 * The `kdens` package is available here <http://fmwww.bc.edu/repec/bocode/k/kdens.zip>.
 * The `metan` command is available here <https://ideas.repec.org/c/boc/bocode/s456798.html>.
 * The `grc1leg` ado-file is here <http://www.stata.com/users/vwiggins/grc1leg/grc1leg.ado> and the helpfile is here <http://www.stata.com/users/vwiggins/grc1leg/grc1leg.hlp>
 
Extract the zip archives and save all files on your `adopath`.

To uninstall a manual installation simply delete the files you placed on your adopath.

## Authors
Tom Palmer, Wesley Spiller, Neil Davies

## How to cite the mrrobust package
Spiller W, Davies NM, Palmer TM. Software Application Profile: mrrobust - A tool for performing two-sample summary Mendelian randomization analyses. bioRxiv, published online 25th May 2017. <https://doi.org/10.1101/142125>

## References
 * Bowden J, Davey Smith G, Burgess S. Mendelian randomization with invalid instruments: effect estimation and bias detection through Egger regression. International Journal of Epidemiology, 2015, 44, 2, 512-525. <http://dx.doi.org/10.1093/ije/dyv080>
 * Bowden J, Davey Smith G, Haycock PC, Burgess S. Consistent estimation in Mendelian randomization with some invalid instruments using a weighted median estimator. Genetic Epidemiology, published online 7 April 2016. <http://dx.doi.org/10.1002/gepi.21965>
 * Hartwig FP, Davey Smith G, Bowden J. Robust inference in two-sample Mendelian randomisation via the zero modal pleiotropy assumption. bioRxiv. <http://dx.doi.org/10.1101/126102>
 * Hemani G et al. MR-Base: a platform for systematic causal inference across the phenome using billions of genetic associations. bioRxiv, 2016. <https://doi.org/10.1101/078972>

## Acknowledgements
Thanks to Michael Holmes, Caroline Dale, Amy Taylor, Rebecca Richmond, Judith Brand, Yanchun Bao, Kawthar Al-Dabhani, Michalis Katsoulis, and Ghazaleh Fatemifar for helpful feedback and suggestions.
