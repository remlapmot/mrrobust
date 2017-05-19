# mrrobust package: Stata commands for MR-Egger, IVW, and weighted median estimators
The `mrrobust` package contains several commands implementing estimators robust to certain proportions of invalid instrumental variables. Such estimators are becoming widely used, especially in Mendelian randomization studies in epidemiology.

In the package there are the following commands:

 - `mregger` implements the IVW and MR-Egger regression approaches introduced in Bowden et al., Int J Epi, 2015 <http://dx.doi.org/10.1093/ije/dyv080>. Use with summary data (i.e. per SNP/genotype associations with the disease outcome and exposure/phenotype).

 - `mrmedian` and `mrmedianobs` implement the unweighted, weighted, and penalized weighted median IV estimators robust to 50% invalid instruments in Bowden et al., Gen Epi, 2016 <http://dx.doi.org/10.1002/gepi.21965>. Use `mrmedian` with summary data and `mrmedianobs` with individual level data.

 - `mreggerplot` implements a scatter plot with fitted line (either from IVW, MR-Egger, or weighted median estimators) and confidence interval.

Installation
============

This package uses functions in Ben Jann's `moremata` and `addplot` packages and the `heterogi` command by Orsini et al., so install those first with:
```
. ssc install addplot
. ssc install moremata
. ssc install heterogi
```

Then to install `mrrobust` issue in Stata (in versions 13 and above)
```
. net install mrrobust, from(https://raw.github.com/remlapmot/mrrobust/master/) replace
```

If `net install` fails with an error message that there are two copies of the package installed run `adoupdate` in Stata to delete one of them. Also run `adoupdate` to check for updates, or to update the package if you know an update is available run:
```
. adoupdate mrrobust, update
```

To uninstall the package, issue in Stata:
```
. ado uninstall mrrobust
```

To view the helpfiles which have examples near the end, issue:
```
. help mregger
. help mrmedian
. help mrmedianobs
. help mreggerplot
```

## Stata version 12 and earlier
The `net install` syntax above does not work under Stata version 12 (and earlier versions) because this webpage has an address starting with https rather than http. In this case please download the files manually (either click the green "Clone or download" button above and then download as zip and then extract, or for each file right click over the filename above and click "Save link as..."). Then save the files on your adopath. 

In this case you also need to install the `addplot`, `moremata`, and `heterogi` packages manually from SSC. 
 * The `moremata` package is available as a zip file here <http://fmwww.bc.edu/repec/bocode/m/moremata.zip>. 
 * The `addplot` package is available here <http://fmwww.bc.edu/repec/bocode/a/addplot.zip>. 
 * The `heterogi` command is available here <https://ideas.repec.org/c/boc/bocode/s449201.html>.

Extract the zip archives and save all files on your adopath.

Authors
=======
Tom Palmer, Wesley Spiller, Neil Davies

Licence
=======
CC-BY

