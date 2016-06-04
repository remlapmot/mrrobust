# Stata commands for MR-Egger and weighted Median estimators
This package contains several commands implementing estimators robust to certain proportions of invalid instrumental variables. Such estimators are becoming widely used, especially in Mendelian randomization studies.

`mregger` implements the IVW and MR-Egger regression approaches introduced in Bowden et al., Int J Epi, 2015 <http://dx.doi.org/10.1093/ije/dyv080>.

`mrmedian` and `mrmedianobs` implement all 3 (unweighted, weighted, and penalized weighted) median IV estimators robust to 50% invalid instruments in Bowden et al., Gen Epi, 2016 <http://dx.doi.org/10.1002/gepi.21965>. These Stata programs are based on the R code given in the supplementary material of the paper.

The commands are for use with individual and summary level data as follows:
 - `mregger` for use with summary data (i.e. genotype-disease and genotype-phenotype associations and their standard errors)
 - `mrmedian` for use with summary data (i.e. genotype-disease and genotype-phenotype associations and their standard errors)
 - `mrmedianobs` for use with individual level data.

Installation
============

Installation in Stata (in versions 13 and above)
```
. net install mrmedian, from(https://raw.github.com/remlapmot/mrmedian/master/) replace
```

If you find that `net install` fails with an error message about their being two copies of the package installed run the following command in Stata to delete one of them:
```
. adoupdate
```

To uninstall issue in Stata:
```
. ado uninstall mrmedian
```

To view the helpfiles which have examples at towards the end, issue:
```
. help mregger
. help mrmedian
. help mrmedianobs
```

Author
=======
Tom Palmer
