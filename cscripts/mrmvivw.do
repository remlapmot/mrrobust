* mrmvivw cscript
* 22jun2020

cscript mrmvivw adofiles mrmvivw mvivw mvmr

about

* load in dataset
use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear

* ldlc - analysis 1
gen byte sel1 = (ldlcp2 < 1e-8)

* check univariate estimate

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw fe

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw 

discard
mrmvivw chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, fe
assert abs(_b[ldlcbeta] - .482) < 1e-3
assert abs(_se[ldlcbeta] - .038) < 1e-3

* r(table)
mat list r(table)

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

* eret list
eret list

* ret list
ret list

* Display
discard
mrmvivw chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, fe
mrmvivw

assert `e(N)' == 73
assert "`e(setype)'" == "fe"

discard
mrmvivw chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1
mrmvivw
assert "`e(setype)'" == "re"

* e(cmd), e(cmdline)
discard
mrmvivw chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1
di e(cmd)
assert "`e(cmd)'" == "mrmvivw"
di e(cmdline)
assert "`e(cmdline)'" == "mrmvivw chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1"

* gxse() for Q-statistics
discard
mrmvivw chdbeta ldlcbeta hdlcbeta [aw=1/(chdse^2)] if sel1==1, ///
	gxse(ldlcse hdlcse)
assert e(Qa) - 159.888 < 1e-3
assert e(Qadf) == 71
assert e(Qap) - 8.41e-9 < 1e-6

discard
mrmvivw chdbeta ldlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, ///
	gxse(ldlcse tgse)
	
discard
mrmvivw chdbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, ///
	gxse(hdlcse tgse)

discard
mrmvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, ///
	gxse(ldlcse hdlcse tgse)
eret list
di e(Qa), e(Qadf), e(Qap)
mrmvivw
eret list
di e(Qa), e(Qadf), e(Qap)
assert e(Qa) - 152.877 < 1e-3
assert e(Qadf) == 70
assert e(Qap) - 4.108e-8 < 1e-6

discard
mvmr chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, ///
	gxse(ldlcse hdlcse tgse)
eret list

discard
mvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, ///
	gxse(ldlcse hdlcse tgse)
eret list

// check for too few SEs specified in gxse()
discard
rcof "noi mrmvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, gxse(ldlcse hdlcse)" == 198
discard
rcof "noi mrmvivw chdbeta ldlcbeta hdlcbeta [aw=1/(chdse^2)] if sel1==1, gxse(ldlcse hdlcse tgse)" == 198

// eret Np - No. phenotypes
discard
mrmvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1
eret list
assert e(Np) == 3
mrmvivw

discard
mrmvivw chdbeta ldlcbeta hdlcbeta [aw=1/(chdse^2)] if sel1==1
eret list
assert e(Np) == 2

discard
mrmvivw chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1
eret list
assert e(Np) == 1
mrmvivw
mat list r(table)

// qxi ereturned items
discard
mvmr chdbeta ldlcbeta hdlcbeta [aw=1/(chdse^2)] if sel1==1, ///
	gxse(ldlcse hdlcse)
mat qx = e(Qx)
mat list qx
assert qx[1,1] - 9672.67 < 1e-2
assert qx[2,1] - 3151.87 < 1e-2
mat fx = e(Fx)
mat list fx
assert fx[1,1] - 134.34 < 1e-2
assert fx[2,1] - 43.78 < 1e-2

discard
mrmvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, ///
	gxse(ldlcse hdlcse tgse)
eret list
mat qx = e(Qx)
mat list qx
mat fx = e(Fx)
mat list fx
assert qx[1,1] - 9252.3618 < 1e-2
assert qx[2,1] - 2576.8537 < 1e-2
assert qx[3,1] - 2870.8934 < 1e-2
assert fx[1,1] - 130.31495 < 1e-2
assert fx[2,1] - 36.2937 < 1e-2
assert fx[3,1] - 40.435 < 1e-2

mrmvivw
eret list
assert e(N) == 73
assert e(Np) == 3
assert e(Qa) - 152.877 < 1e-3
assert e(Qadf) == 70
mat qx = e(Qx)
mat list qx
mat fx = e(Fx)
mat list fx
assert qx[1,1] - 9252.3618 < 1e-2
assert qx[2,1] - 2576.8537 < 1e-2
assert qx[3,1] - 2870.8934 < 1e-2
assert fx[1,1] - 130.31495 < 1e-2
assert fx[2,1] - 36.2937 < 1e-2
assert fx[3,1] - 40.435 < 1e-2

discard
mrmvivw chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ///
	gxse(ldlcse)
assert e(Qa) - 173.66 < 1e-2
assert e(Np) == 1
assert e(Qadf) == 72

// tdist
discard
mrmvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, ///
	gxse(ldlcse hdlcse tgse) tdist
di e(df_r)
assert e(df_r) == 70
mat rtable = r(table)
assert rtable[7,1] == 70
mrmvivw

discard
mrmvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, ///
	gxse(ldlcse hdlcse tgse)
mat rtable = r(table)
assert rtable[7,1] == .

discard
mrmvivw chdbeta ldlcbeta hdlcbeta [aw=1/(chdse^2)] if sel1==1, ///
	gxse(ldlcse hdlcse) tdist
di e(df_r)
assert e(df_r) == 71
mat rtable = r(table)
assert rtable[7,1] == 71
mrmvivw

discard
mrmvivw chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ///
	gxse(ldlcse) tdist
di e(df_r)
assert e(df_r) == 72
mat rtable = r(table)
assert rtable[7,1] == 72
mrmvivw

// e(phi)
discard
mrmvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1
assert e(phi) - 1.490 < 1e-3

discard
mrmvivw chdbeta ldlcbeta hdlcbeta [aw=1/(chdse^2)] if sel1==1
assert e(phi) - 1.514 < 1e-3
mrmvivw
assert e(phi) - 1.514 < 1e-3
