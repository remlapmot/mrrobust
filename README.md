# mrrobust: Stata package for two-sample Mendelian randomization analyses

* [Latest updates](#latest-updates)
* [Short video introduction](#short-video-introduction)
* [Helpfile examples](#helpfile-examples)
* [Overview](#overview)
* [Installing and updating mrrobust](#installing-and-updating-mrrobust)
* [Unit tests](#unit-tests)
* [Authors](#authors)
* [How to cite the mrrobust package](#how-to-cite-the-mrrobust-package)
* [References](#references)
* [Collaboration](#collaboration)
* [Acknowledgements](#acknowledgements)

## Latest updates

To obtain the latest update please see the instructions [below](#installing-and-updating-mrrobust).

* May 2025:
  - Reran certification scripts (a.k.a. tests) on StataNow 18.5
* July 2024:
  - Updated website to mention [OpenGWAS](https://api.opengwas.io/) instead of MR-Base
  - In Stata 18 on a `graph twoway` plot the default legend position appears to have changed from the 6 o'clock to the 3 o'clock position. Amendments have been made to `mreggerplot`, `mrfunnel`, and `mrmodalplot` to use the 6 o'clock position as the default again.
* January 2024:
  - Reran certification scripts under Stata 18.0
* August 2023:
  - Added a record of the Stata version in the certification scripts
* April 2023:
  - Improved the alt text descriptions for the images in the *README* and package website, and also centred the images
  - Remade the **mrrobust** website using [**Quarto**](https://quarto.org/)
  - Updated the Sanderson et al., bioRxiv, 2020, [doi](https://doi.org/10.1101/2020.04.02.021980) reference to its published version Sanderson et al., Statistics in Medicine, 2021, [doi](https://doi.org/10.1002/sim.9133)
  - Reran certification scripts under latest Stata 17.0
* February 2023:
  - Updated R Markdown example to use the CRAN version of the [**Statamarkdown**](https://cran.r-project.org/package=Statamarkdown) package
* September 2022:
  - Updated manual installation instructions
* February 2022:
  - Ran cscripts under Stata 17.0
  - Updated website examples to run under Stata 17.0
* September 2021:
  - Changed relevant `http:` URLs to `https:`
  - Minor edits to the helpfiles
* June 2021:
  - Published an interactive Code Ocean capsule demonstrating the use of the **mrrobust** package 
  [here](https://doi.org/10.24433/CO.0587524.v1)
  - By default `mrforest` now specifies a fixed effect standard error for its IVW estimate 
* April 2021:
  - Added the I-squared statistic and its 95% CI to the `mregger ..., heterogi` output
* February 2021:
  - Fixes to `mrforest` and `mrleaveoneout` related to the recent update to `metan`. 
  `mrforest` and `mrleaveoneout` now use `metan9` instead of `metan` because of the changes to 
  `metan` syntax. No change was necessary in the dependency scripts because `metan9` is also 
  installed with `ssc install metan`
  - Checked cscripts pass
  - Checked examples on website run. And changed the 2 examples which use the **TwoSampleMR** R
  package to use the new ID code for the exposure data
  - Updated `dependency.do` to make it more robust to the more frequent updates to `metan`
  - Updated `mrdeps` to make it more robust to the more frequent updates to `metan`
* October 2020:
  - `dependency.do` and `mrdeps` now install the updated version of the `moremata` package
  - Checked the cscripts run under Stata 16.1
  - Added description of Q-statistic as Cochran's and Ruecker's for the IVW and MR-Egger models 
  respectively
  - In various helpfiles added clarification that genotype-disease stands for SNP-outcome 
  (or indeed instrument-outcome) and that genotype-phenotype stands for SNP-exposure (or indeed 
  instrument-exposure) respectively; i.e. the estimates required for the top and bottom of the IV 
  Wald ratio estimate
* August 2020:
  - Added html versions of the helpfiles to the website. These are available from the *Helpfiles* website 
  menu bar item
  - Added extra decimal places examples to helpfiles of `mrforest` and `mrleaveoneout`
  - `mrfunnel` now includes a legend on its plot
* July 2020:
  - Added `gxse()` option to `mrmvivw` to return instrument strength Q<sub>A</sub> statistic for 
  instrument validity in `e(Qa)` ([Sanderson et al. 2019](#references))
  - The `gxse()` option additionally returns the Q<sub>x</sub> and conditional F-statistics for 
  each phenotype for instrument strength in `e(Qx)` and `e(Fx)` 
  ([Sanderson et al. 2020](#references))
  - Added `tdist` option to `mrmvivw` and `mrmvegger`
  - `mrmvivw` and `mrmvegger` now ereturn the RMSE in `e(phi)`
  - `mregger, ivw` now displays the square root of the residual variance (residual standard error) 
  and ereturns this is `e(phi)`
  - Checked that examples on website still run
  - Added `mrleaveoneout` command to perform leave one out analysis
* June 2020:
  - Simplified the outcome variable name in `mregger` `b` and `V` e-returned matrices. Turn this off 
  with new `oldnames` option
  - Added basic multivariable MR-Egger command, `mrmvegger`
  - Added basic multivariable IVW command, `mrmvivw` (currently command names `mvmr` and `mvivw` 
  also work)
* February 2020:
  - Updated contact details
  - Minor edits to helpfiles, to show examples setting `seed()` option where helpful
  - Fixed `mregger` bug where `r(table)` was not returned with the `gxse` or `heterogi` options. 
  The output for these options now appears before the coefficient table.
  - Minor amendments to formatting of `mregger` `gxse` output
  - `mregger` now ereturns `e(phi)`, the scale parameter, in some cases
* January 2020:
  - `mregger` now additionally returns `r(table)`
  - Certification scripts: added `master.do` and renamed and edited a few scripts
  - Added `mr` command. Commands may now be run as either `mr egger ...` or as previously 
  `mregger ...`.
  - [*Best of IJE 2019*!](https://academic.oup.com/ije/pages/the_best_of_ije)
  - `mrmedian`, `mrmedianobs`, `mreggersimex`, `mrmodal`, and `mrratio` now additionally return 
  the `r(table)` matrix (the information from the coefficient table)
  - Added an example showing how you can save and export your estimates using `r(table)`, see 
  [here](https://remlapmot.github.io/mrrobust/examples/save-estimates/index.html)
* December 2019:
  - Added `Q_GX` to ereturn and display output when `gxse()` option specified to `mregger`
  - Changed `Q_GX` and `I^2_GX` output to use first order weights in `mregger` output. This matches 
  the output from the `mr_egger()` function in the **MendelianRandomization** R package. Use the 
  `unwi2gx` option to report the unweighted statistics.
* July 2019:
  - Checked that examples on website still run
* December 2018: 
  - Improved compatibility with the [**github**](https://haghish.github.io/github/) Stata package,
  i.e., **mrrobust** and its dependencies can be installed simply by issuing: `gitget mrrobust`,
  if you have the **github** package installed. 
  [See below for instructions](#2-use-the-github-package).
  - `mrdeps` command added for conveniently installing dependencies
* November 2018:
  - Example showing the use of the **TwoSampleMR** R package and **mrrobust** in the same 
  [R Markdown script](https://rmarkdown.rstudio.com/) (`.Rmd` file) is 
  [here](https://remlapmot.github.io/mrrobust/examples/rmarkdown-call-stata-example/index.html)
  - Example showing the use of the **TwoSampleMR** R package and **mrrobust** in the same 
  [Stata Markdown](https://data.princeton.edu/stata/markdown) script (`.stmd` file) is 
  [here](https://remlapmot.github.io/mrrobust/examples/markstat-call-R-example/index.html)
* September 2018: 
  - IJE paper published online [here](https://doi.org/10.1093/ije/dyy195)
* August 2018:
  - Click [here](https://remlapmot.github.io/mrrobust/examples/spiller-ije-2018-examples/index.html) for the 
  example code and output from our IJE article
* May 2018: 
  - Click [here](https://remlapmot.github.io/mrrobust/examples/mrrobust-examples/index.html) for code and output 
  from the examples in the helpfiles
  - This page is now rendered on GitHub Pages [here](https://remlapmot.github.io/mrrobust/)
* April 2018: 
  - `mregger` now has option `radial` which implements the radial formulation of the MR-Egger 
  model, and of the IVW model when used with option `ivw`

## Short video introduction
Click [here](https://drive.google.com/open?id=0B1owQlNgzNcPY0lMSGk0SnFfQWs) for a short video 
demonstrating the use of the package.

<p align="center"><a href="https://drive.google.com/open?id=0B1owQlNgzNcPY0lMSGk0SnFfQWs"><img src="./img/mrconf2017_video_mrforest_screenshot.png" width="528" height="300" alt="A screenshot of a video demonstrating the use of the mrrobust package."></a></p>

## Helpfile examples
Click [here](https://remlapmot.github.io/mrrobust/examples/mrrobust-examples/index.html) for some of the code and 
output from the examples in the helpfiles.

Once the package is installed, there is a summary helpfile which can be viewed in Stata with:
```stata
help mrrobust
```
This has links to the helpfile for each command, which has an example near the bottom. In these 
examples you can click on the code to run it.

## Overview
The **mrrobust** package is a collection of commands for performing two-sample Mendelian randomization 
analyses using summary data of genotype-phenotype and genotype-outcome associations. 

Such data can be obtained from repositories such as MR-Base <https://www.mrbase.org> 
([Hemani et al. 2016](#references)).

The package contains the following commands:

 - `mrdeps` installs dependencies for the package
 - `mrratio` implements the standard instrumental variable ratio (Wald) estimate with a choice of 
 standard errors/confidence intervals
 - `mrivests` automates calling `mrratio` on all the selected genotypes in your dataset
 - `mregger` implements the IVW and MR-Egger regression approaches introduced in 
 [Bowden et al. (2015)](#references)
 - `mreggersimex` implements the simulation extrapolation algorithm for the MR-Egger model
 - `mreggerplot` implements a scatter plot with fitted line (either from IVW, MR-Egger, or weighted 
 median estimators) and confidence interval
 - `mrmedian` and `mrmedianobs` implement the unweighted, weighted, and penalized weighted median 
 IV estimators robust to 50% invalid instruments in [Bowden et al. (2016)](#references)
 - `mrmodal` implements the zero modal estimator of [Hartwig et al. (2017)](#references)
 - `mrmodalplot` plot of density used in modal estimator
 - `mrforest` implements a forest plot of genotype specific IV estimates and estimates from models 
 (e.g. IVW and MR-Egger)
 - `mrfunnel` funnel plot of genotype specific IV estimates
 - `mr` acts as a primary command, e.g. so the other commands can be run as `mr egger ...` as well 
 as `mregger ...`
 - `mrmvivw` (`mvmr`, `mvivw`) implements the multivariable IVW model
 - `mrmvegger` implements the multivariable MR-Egger model
 - `mrleaveoneout` implements leave one (genotype) out analysis

## Installing and updating mrrobust
To install **mrrobust** in Stata versions 13 and later you have two choices.

### 1. Use `net install`

``` stata
net install mrrobust, from("https://raw.github.com/remlapmot/mrrobust/master/") replace
mrdeps
```
In this code `mrdeps` installs the dependencies. These are `addplot`, `kdens`, and `moremata` 
packages (all by Ben Jann), the `heterogi` command (Orsini et al.), the `metan` command (Harris et 
al.), and the `grc1leg` command (Wiggins).

If you have previously installed the package and the `net install` command above fails with an error
message that there are two copies of the package installed simply run `adoupdate`.

To check if there is an update available to any of your user-written Stata packages run `adoupdate`.
To update **mrrobust** run:
``` stata
adoupdate mrrobust, update
```

To uninstall **mrrobust**, issue in Stata:
``` stata
ado uninstall mrrobust
```
If this fails with an error message mentioning that you have *"multiple citations/instances of the 
package installed"* simply issue `adoupdate mrrobust`. This should leave you with the most recent 
version of the package you previously installed. You can then run `ado uninstall mrrobust`.

### 2. Use the `github` package

``` stata
net install github, from("https://haghish.github.io/github/")
gitget mrrobust
```
This automatically installs the dependencies.

To update the package issue:
``` stata
github update mrrobust
```

To uninstall mrrobust issue:
``` stata
github uninstall mrrobust
```

### Installation instructions for Stata version 12 and earlier versions (and perhaps Stata version 13)
The `net install` syntax for installing `mrrobust` does not work under Stata version 12 and earlier 
because this webpage has an address starting with https rather than http. In such cases you need to 
do a manual installation.

#### To download and install mrrobust manually:

* Click the green "Clone or download" button at the top of the GitHub repository 
[here](https://github.com/remlapmot/mrrobust) and download as a zip archive or click this direct [link](https://github.com/remlapmot/mrrobust/archive/refs/heads/master.zip).
* In your file explorer extract the zip archive and find its filepath, e.g. `C:\Users\tom\Downloads\mrrobust-master\mrrobust-master`
* In Stata run
  ```stata
  net install mrrobust, from("C:\Users\tom\Downloads\mrrobust-master\mrrobust-master") replace
  ```

The installation commands for the other dependencies should work. However, if you need to install 
them manually their zip archives are available at the following links (extract the files from the downloaded zip archives and place them in your `PERSONAL` directory on your `adopath`): 

 * the **moremata** package is available as a zip file 
 [here](http://fmwww.bc.edu/repec/bocode/m/moremata.zip)
 * the `addplot` command is available [here](http://fmwww.bc.edu/repec/bocode/a/addplot.zip) 
 * the `heterogi` command is available [here](https://ideas.repec.org/c/boc/bocode/s449201.html)
 * the `kdens` command is available [here](http://fmwww.bc.edu/repec/bocode/k/kdens.zip)
 * the `metan` command is available [here](https://ideas.repec.org/c/boc/bocode/s456798.html)
 * the `grc1leg` command can be installed with
   ``` stata
   net install grc1leg, from("https://www.stata.com/users/vwiggins")
   ```

## Unit tests
As far as I know, and unlike R which has the **testthat** package (and other testing packages),
there is no recognised standard for writing unit tests for Stata commands.
StataCorp. refer to do-files with tests as cscripts (certification scripts).
I publish my cscripts (and their log files of output) in the
[cscripts directory](https://github.com/remlapmot/mrrobust/tree/master/cscripts). 

## Authors
Tom Palmer <tom.palmer@bristol.ac.uk>, Wesley Spiller, Neil Davies

## How to cite the mrrobust package
Spiller W, Davies NM, Palmer TM. Software Application Profile: mrrobust &mdash; A tool for performing 
two-sample summary Mendelian randomization analyses. International Journal of Epidemiology, 2019, 
48, 3, 684&ndash;690. <https://doi.org/10.1093/ije/dyy195>.

Thank you to all our users who have cited **mrrobust**. We made 
[*The Best of IJE 2019*](https://academic.oup.com/ije/pages/the_best_of_ije)!

## Collaboration
If you would like to extend the code or add new commands I am open to receiving pull requests on 
GitHub or send me an email to <tom.palmer@bristol.ac.uk>.

## References

<div class="hanging-indent">

Bowden J, Davey Smith G, Burgess S. Mendelian randomization with invalid instruments: effect
estimation and bias detection through Egger regression. International Journal of Epidemiology,
2015, 44, 2, 512&ndash;525. <https://dx.doi.org/10.1093/ije/dyv080>.

Bowden J, Davey Smith G, Haycock PC, Burgess S. Consistent estimation in Mendelian randomization
with some invalid instruments using a weighted median estimator. Genetic Epidemiology, 2016, 40, 4,
304&ndash;314. <https://dx.doi.org/10.1002/gepi.21965>.

Hartwig FP, Davey Smith G, Bowden J. Robust inference in two-sample Mendelian randomisation via
the zero modal pleiotropy assumption. International Journal of Epidemiology, 2017, 46, 6,
1985&ndash;1998. <https://doi.org/10.1093/ije/dyx102>.

Hemani G et al. The MR-Base platform supports systematic causal inference across the human
phenome. eLife, 2018, 7:e34408. <https://doi.org/10.7554/eLife.34408.001>.

Sanderson E, Davey Smith G, Windmeijer F, Bowden J. An examination of multivariable Mendelian
randomization in the single-sample and two-sample summary data settings. International Journal of
Epidemiology, 2019, 48, 3, 713&ndash;727. <https://doi.org/10.1093/ije/dyy262>.

Sanderson E, Spiller W, Bowden J. Testing and correcting for weak and pleiotropic instruments in
two-sample multivariable Mendelian randomization. Statistics in Medicine, 2021, 40, 25, 5434&ndash;5452.
<https://doi.org/10.1002/sim.9133>.
</div>

## Acknowledgements
Thanks for helpful feedback and suggestions to (in no particular order): Jasmine Khouja, 
Michael Holmes, Caroline Dale, Amy Taylor, Rebecca Richmond, Judith Brand, Yanchun Bao, 
Kawthar Al-Dabhani, Michalis Katsoulis, Ghazaleh Fatemifar, Lai-Te Chen, Sean Harrison,
Emma Anderson, Cassianne Robinson-Cohen, Alisa Kjaergaard, and Steve Burgess.
