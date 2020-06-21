* mregger cscript
* 04jun2016

cscript mrmvivw

* load in dataset
use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear

* ldlc - analysis 1
gen byte sel1 = (ldlcp2 < 1e-8)

* check univariate estimate

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw fe

discard
mrmvivw chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, fe
assert abs(_b[ldlcbeta] - .482) < 1e-3
assert abs(_se[ldlcbeta] - .038) < 1e-3

discard
mvivw chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, fe
assert abs(_b[ldlcbeta] - .482) < 1e-3
assert abs(_se[ldlcbeta] - .038) < 1e-3

discard
mvmr chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, fe
assert abs(_b[ldlcbeta] - .482) < 1e-3
assert abs(_se[ldlcbeta] - .038) < 1e-3

* fit a multivariate estimate

** without FE SEs
discard
mrmvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1
assert abs(_b[ldlcbeta] - .429) < 1e-3
assert abs(_se[ldlcbeta] - .061) < 1e-3
assert abs(_b[hdlcbeta] - -.194) < 1e-3
assert abs(_se[hdlcbeta] - .131) < 1e-3
assert abs(_b[tgbeta] - .226) < 1e-3
assert abs(_se[tgbeta] - .123) < 1e-3

discard
mvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1
assert abs(_b[ldlcbeta] - .429) < 1e-3
assert abs(_se[ldlcbeta] - .061) < 1e-3
assert abs(_b[hdlcbeta] - -.194) < 1e-3
assert abs(_se[hdlcbeta] - .131) < 1e-3
assert abs(_b[tgbeta] - .226) < 1e-3
assert abs(_se[tgbeta] - .123) < 1e-3

discard
mvmr chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1
assert abs(_b[ldlcbeta] - .429) < 1e-3
assert abs(_se[ldlcbeta] - .061) < 1e-3
assert abs(_b[hdlcbeta] - -.194) < 1e-3
assert abs(_se[hdlcbeta] - .131) < 1e-3
assert abs(_b[tgbeta] - .226) < 1e-3
assert abs(_se[tgbeta] - .123) < 1e-3

** with FE SEs
discard
mrmvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, fe
assert abs(_b[ldlcbeta] - .429) < 1e-3
assert abs(_se[ldlcbeta] - .041) < 1e-3
assert abs(_b[hdlcbeta] - -.194) < 1e-3
assert abs(_se[hdlcbeta] - .088) < 1e-3
assert abs(_b[tgbeta] - .226) < 1e-3
assert abs(_se[tgbeta] - .083) < 1e-3

discard
mvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, fe
assert abs(_b[ldlcbeta] - .429) < 1e-3
assert abs(_se[ldlcbeta] - .041) < 1e-3
assert abs(_b[hdlcbeta] - -.194) < 1e-3
assert abs(_se[hdlcbeta] - .088) < 1e-3
assert abs(_b[tgbeta] - .226) < 1e-3
assert abs(_se[tgbeta] - .083) < 1e-3

discard
mvmr chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, fe
assert abs(_b[ldlcbeta] - .429) < 1e-3
assert abs(_se[ldlcbeta] - .041) < 1e-3
assert abs(_b[hdlcbeta] - -.194) < 1e-3
assert abs(_se[hdlcbeta] - .088) < 1e-3
assert abs(_b[tgbeta] - .226) < 1e-3
assert abs(_se[tgbeta] - .083) < 1e-3

** 90% CI
discard
mrmvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, level(90)
mat table = r(table)
assert abs(_b[ldlcbeta] - invnorm(.95)*_se[ldlcbeta] - .328) < 1e-3
assert abs(_b[ldlcbeta] + invnorm(.95)*_se[ldlcbeta] - .529) < 1e-3

discard
mvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, level(90)
mat table = r(table)
assert abs(_b[ldlcbeta] - invnorm(.95)*_se[ldlcbeta] - .328) < 1e-3
assert abs(_b[ldlcbeta] + invnorm(.95)*_se[ldlcbeta] - .529) < 1e-3

discard
mvmr chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, level(90)
mat table = r(table)
assert abs(_b[ldlcbeta] - invnorm(.95)*_se[ldlcbeta] - .328) < 1e-3
assert abs(_b[ldlcbeta] + invnorm(.95)*_se[ldlcbeta] - .529) < 1e-3