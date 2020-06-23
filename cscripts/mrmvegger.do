* mrmvegger cscript
* 22un2020

cscript mrmvegger adofiles mrmvegger

* load in dataset
use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear

* ldlc - analysis 1
gen byte sel1 = (ldlcp2 < 1e-8)

* check univariate estimate

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw fe
