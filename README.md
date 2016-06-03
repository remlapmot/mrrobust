# mrmedian
The `mrmedian` command implements all 3 median estimators in the paper; unweighted, weighted, and penalized weighted.

Stata module recreating the R code in the supplementary material of Bowden et al., Consistent estimation in Mendelian randomization with some invalid instruments using a weighted median estimator, Gen Epi, 2016. <http://dx.doi.org/10.1002/gepi.21965>.

Installation
============

Installation in Stata (in versions 13 and above)
```
. net install mrmedian, from(https://raw.github.com/remlapmot/stata.mrmedian/master/) replace force
```

To uninstall issue in Stata:
```
. ado uninstall mrmedian
```

Author
=======
Tom Palmer
