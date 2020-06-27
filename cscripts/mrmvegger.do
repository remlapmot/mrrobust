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

* check bivariate

discard
mrmvegger chdbeta ldlcbeta hdlcbeta [aw=1/(chdse^2)] if sel1==1

assert _b[ldlcbeta] - .572 < 1e-3
assert _b[hdlcbeta] - -.267 < 1e-3
assert _b[_cons] - -.007 < 1e-3
assert _se[ldlcbeta] - .103 < 1e-3
assert _se[hdlcbeta] - .123 < 1e-3
assert _se[_cons] - .005 < 1e-3

* check r(table)
mat list r(table)

discard
mrmvegger chdbeta ldlcbeta hdlcbeta [aw=1/(chdse^2)] if sel1==1, orient(2)

assert _b[ldlcbeta] - .467 < 1e-3
assert _b[hdlcbeta] - -.305 < 1e-3
assert _b[_cons] - .001 < 1e-3
assert _se[ldlcbeta] - .059 < 1e-3
assert _se[hdlcbeta] - .145 < 1e-3
assert _se[_cons] - .004 < 1e-3

* check trivariate

discard
mrmvegger chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1

assert _b[ldlcbeta] - .567 < 1e-3
assert _b[hdlcbeta] - -.136 < 1e-3
assert _b[tgbeta] - .273 < 1e-3
assert _b[_cons] - -.009 < 1e-3
assert _se[ldlcbeta] - .100 < 1e-3
assert _se[hdlcbeta] - .133 < 1e-3
assert _se[tgbeta] - .124 < 1e-3
assert _se[_cons] - .005 < 1e-3

* check orient option
discard
mrmvegger chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, orient(2)

assert _b[ldlcbeta] - .428 < 1e-3
assert _b[hdlcbeta] - -.198 < 1e-3
assert _b[tgbeta] - .225 < 1e-3
assert _b[_cons] - -.0002 < 1e-3
assert _se[ldlcbeta] - .061 < 1e-3
assert _se[hdlcbeta] - .154 < 1e-3
assert _se[tgbeta] - .124 < 1e-3
assert _se[_cons] - .0036 < 1e-3

discard
mrmvegger chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, orient(3)

assert _b[ldlcbeta] - .420 < 1e-3
assert _b[hdlcbeta] - -.190 < 1e-3
assert _b[tgbeta] - .206 < 1e-3
assert _b[_cons] - .0013 < 1e-3
assert _se[ldlcbeta] - .066 < 1e-3
assert _se[hdlcbeta] - .132 < 1e-3
assert _se[tgbeta] - .136 < 1e-3
assert _se[_cons] - .0039 < 1e-3

* check orient not greater than no. phenotypes
rcof "noi mrmvegger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, orient(2)" == 198

* check orient not negative
discard
rcof "noi mrmvegger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, orient(-1)" == 198

* test replay
discard
mrmvegger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1
mrmvegger

* eret list
discard
mrmvegger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1
eret list

* ret list
ret list

* e(N)
assert `e(N)' == 73

* e(orientvar)
assert "`e(orientvar)'" == "ldlcbeta"
