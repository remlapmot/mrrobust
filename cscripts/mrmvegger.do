* mrmvegger cscript
* 22un2020

cscript mrmvegger adofiles mrmvegger

* load in dataset
use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear

* ldlc - analysis 1
gen byte sel1 = (ldlcp2 < 1e-8)

* check univariate estimate

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1

* check univariate

discard
mrmvegger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1

mat b = e(b)
mat V = e(V)
assert b[1,1] - .617 < 1e-3
assert b[1,2] - -.008 < 1e-3
assert sqrt(V[1,1]) - .103 < 1e-3
assert sqrt(V[2,2]) - .0054 < 1e-3

* check trivariate

discard
mrmvegger chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1

* check orient option
discard
mrmvegger chdbeta ldlcbeta hdlcbeta [aw=1/(chdse^2)] if sel1==1, orient(2)

* check orient not greater than no phenotypes
rcof "noi mrmvegger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, orient(2)" == 198

* check orient not negative
discard
rcof "noi mrmvegger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, orient(-1)" == 198
