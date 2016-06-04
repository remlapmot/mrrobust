# mrrobust package: Stata commands for MR-Egger, IVW, and weighted median estimators
The `mrrobust` package contains several commands implementing estimators robust to certain proportions of invalid instrumental variables. Such estimators are becoming widely used, especially in Mendelian randomization studies in epidemiology.

In the package there are the following commands:

 - `mregger` implements the IVW and MR-Egger regression approaches introduced in Bowden et al., Int J Epi, 2015 <http://dx.doi.org/10.1093/ije/dyv080>. Use with summary data (i.e. per SNP/genotype associations with the disease outcome and exposure/phenotype).

 - `mrmedian` and `mrmedianobs` implement the unweighted, weighted, and penalized weighted median IV estimators robust to 50% invalid instruments in Bowden et al., Gen Epi, 2016 <http://dx.doi.org/10.1002/gepi.21965>. Use `mrmedian` with summary data and `mrmedianobs` with individual level data.

Installation
============

Installation in Stata (in versions 13 and above)
```
. net install mrrobust, from(https://raw.github.com/remlapmot/mrrobust/master/) replace
```

If you find that `net install` fails with an error message about their being two copies of the package installed run the following command in Stata to delete one of them:
```
. adoupdate
```

To uninstall issue in Stata:
```
. ado uninstall mrrobust
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
