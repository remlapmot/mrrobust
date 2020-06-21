* mregger cscript
* 04jun2016

cscript mrmvivw

*** load in dataset
use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear

*** ldlc - analysis 1
gen byte sel1 = (ldlcp2 < 1e-8)
