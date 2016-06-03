# mrmedian
The `mrmedian` command implements all 3 (unweighted, weighted, and penalized weighted) median IV estimators robust to 50% invalid instruments in Bowden et al., Gen Epi, 2016. <http://dx.doi.org/10.1002/gepi.21965>. 

This Stata program is based on the R code given in the supplementary material of the paper.

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

Author
=======
Tom Palmer
