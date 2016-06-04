# mrmedian
The `mrmedian` package implements all 3 (unweighted, weighted, and penalized weighted) median IV estimators robust to 50% invalid instruments in Bowden et al., Gen Epi, 2016. <http://dx.doi.org/10.1002/gepi.21965>. 

These Stata programs are based on the R code given in the supplementary material of the paper.

There are two commands:
 - `mrmedian` for use with summary data (i.e. genotype-disease and genotype-phenotype associations and their standard errors)
 - `mrmedianobs` for use with individual level data.

Installation
============

Installation in Stata (in versions 13 and above)
```
. net install mrmedian, from(https://raw.github.com/remlapmot/mrmedian/master/) replace
```

To uninstall issue in Stata:
```
. ado uninstall mrmedian
```

If you find `net install` fails with an error message saying that you have two copies of the package installed simply run the following to delete one of them:
```
. adoupdate
```

Author
=======
Tom Palmer
