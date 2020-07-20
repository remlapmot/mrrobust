* mregger cscript
* 04jun2016

cscript mregger adofiles mregger

*** load in dataset
use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear

*** ldlc - analysis 1
gen byte sel1 = (ldlcp2 < 1e-8)

*** ivw
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw
assert abs(_b[ldlcbeta] - .482) < 1e-3
assert abs(_se[ldlcbeta] - 0.060) < 1e-3

* r(table)
mat list r(table)

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1
mat list r(table)

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, heterogi
mat list r(table)

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, gxse(ldlcse) heterogi
mat list r(table)

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, gxse(ldlcse)
mat list r(table)

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, radial
mat list r(table)

version 12: mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw
assert abs(_b[ldlcbeta] - .482) < 1e-3
assert abs(_se[ldlcbeta] - 0.060) < 1e-3

* check directional adjustment does not affect estimates
gen double ycheck = chdbeta*sign(ldlcbeta)
gen double xcheck = abs(ldlcbeta)
regress ycheck xcheck [aw=1/(chdse^2)] if sel1==1, nocons
assert abs(_b[xcheck] - .482) < 1e-3
assert abs(_se[xcheck] - 0.060) < 1e-3

*** mregger
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1
assert abs(_b[slope] - .617) < 1e-3
assert abs(_b[_cons] - -.009) < 1e-3
eret list
mregger
eret list

version 12: mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1
assert abs(_b[slope] - .617) < 1e-3
assert abs(_b[_cons] - -.009) < 1e-3

*** test replay
mregger

** ci level
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, level(90)

*** fe standard errors (default is multiplicative)
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, fe

version 12: mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, fe

*** re
/*
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, re noestimate
mat b = e(b)
mat b[1,1] = .575
mat b[1,2] = -.0065
mat b[1,6] = .0046
mat b[1,7] = .0026
mat b[1,8] = -.00067
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, re from(b)
eret list
*/

*** ivw fe SEs
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw fe

version 12: mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw fe

*** ivw re
/*
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw re noestimate
mat b = e(b)
mat b[1,1] = .417
mat b[1,4] = .218
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw re from(b)
*/

rcof "version 12: noi mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, re" ///
        == 9

rcof "noi mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw recons" ///
        == 198

rcof "noi mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw reslope" ///
        == 198

rcof "noi mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw recons reslope" ///
        == 198

rcof "noi mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw re recons" == 198

* mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, re recons

*** reslope
* mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, re reslope

*** both
/*
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, re recons reslope noestimate
mat b = e(b)
mat b[1,1] = .575
mat b[1,2] = -.0065
mat b[1,6] = .0046
mat b[1,7] = .0026
mat b[1,8] = -.00067
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, re recons reslope from(b)
*/

*** gsemopts
* mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, re recons vce(robust)

* level
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, level(90)
mregger
mregger, level(90)

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, tdist level(90) 
mregger, level(95)

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, tdist ivw
mregger, level(90)

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, tdist ivw level(90)
mregger, level(95)

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, tdist ivw fe
mregger, level(90)

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, tdist ivw penw

/*
*** hdlc exposure
gen byte sel2 = (hdlcp2 < 1e-8)
mregger chdbeta hdlcbeta [aw=1/(chdse^2)] if sel2==1, re recons reslope

*** trigs exposure
gen byte sel3 = (tgp2 < 1e-8)
mregger chdbeta tgbeta [aw=1/(chdse^2)] if sel3==1, re recons reslope
*/

*** ivw fe SEs
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw fe

*** heterogi option - changed from noheterogi
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, heterogi
mregger

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, het
mregger

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw heterogi
mregger

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw het
mregger

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, heterogi penweighted

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw heterogi penweighted

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1
mregger

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw
eret list
mregger

*** check the i^2 and q stats for this example
cap noi which tsci
if _rc != 0 {
	net install tsci, from(https://raw.github.com/remlapmot/tsci/master)
}

gen double ivests = chdbeta/ldlcbeta if sel1==1
gen double se = .
local n = _N
qui forvalues i = 1/`n' {
        tsci chdbeta[`i'] chdse[`i'] ldlcbeta[`i'] ldlcse[`i']
        replace se = r(seratio) in `i'
}
replace se = . if sel1==0
gen double sefdm = chdse/abs(ldlcbeta) if sel1==1 
list se sefdm if sel1==1
metan ivests se if sel1==1, nograph
metan ivests sefdm if sel1==1, nograph

metan ivests se if sel1==1, random nograph
metan ivests se if sel1==1, randomi nograph

** norescale
mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, ivw
mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, ivw norescale

mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1
mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, norescale

gen double chdbeta2 = chdbeta/100
mregger chdbeta2 ldlcbeta [aw=1/chdse^2] if sel1==1, ivw
mregger chdbeta2 ldlcbeta [aw=1/chdse^2] if sel1==1, ivw norescale
mregger chdbeta2 ldlcbeta [aw=1/chdse^2] if sel1==1
mregger chdbeta2 ldlcbeta [aw=1/chdse^2] if sel1==1, norescale

** penweighted
mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, ivw penweighted
mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, penweighted

** penweighted norescale
mregger chdbeta2 ldlcbeta [aw=1/chdse^2] if sel1==1, ivw penweighted
mregger chdbeta2 ldlcbeta [aw=1/chdse^2] if sel1==1, ivw penweighted norescale
mregger chdbeta2 ldlcbeta [aw=1/chdse^2] if sel1==1, penweighted
mregger chdbeta2 ldlcbeta [aw=1/chdse^2] if sel1==1, penweighted norescale

** gxse
mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, gxse(ldlcse)
mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, gxse(ldlcse) ivw
* mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, gxse(ldlcse) penweighted // TODO bugfix
mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, gxse(ldlcse) ///
        ivw penweighted

* testing less than 3 observations error message        
rcof "mregger chdbeta ldlcbeta [aw=1/(chdse^2)] in 1/2" == 2001 
rcof "mregger chdbeta ldlcbeta [aw=1/(chdse^2)] in 1" == 2001 

// radial IVW
mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, ivw radial
assert abs(_b[radialGP] - .482) < 1e-3
assert abs(_se[radialGP] - 0.059) < 1e-3

// radial IVW fe SEs
mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, ivw radial fe
assert abs(_b[radialGP] - .482) < 1e-3
assert abs(_se[radialGP] - .038) < 1e-3
eret list

// radial IVW re
/*
mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, ivw radial re
//assert abs(_b[radialGP] - .417) < 1e-3
//assert abs(_se[radialGP] - .076) < 1e-3
eret list
*/

// radial MR-Egger
mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, radial
assert abs(_b[radialGP] - .642) < 1e-3
assert abs(_se[radialGP] - .115) < 1e-3
assert abs(_b[_cons] - -.573) < 1e-3
assert abs(_se[_cons] - .354) < 1e-3

// radial MR-Egger fe
mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, radial fe
assert abs(_b[radialGP] - .642) < 1e-3
assert abs(_se[radialGP] - .074) < 1e-3
assert abs(_b[_cons] - -.573) < 1e-3
assert abs(_se[_cons] - .229) < 1e-3

// radial MR-Egger re
/*
mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, radial re
assert abs(_b[radialGP] - .623) < 1e-3
assert abs(_se[radialGP] - .106) < 1e-3
assert abs(_b[_cons] - -.523) < 1e-3
assert abs(_se[_cons] - .342) < 1e-3
*/

// disallow penweighted and radial for now
rcof "noi mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, radial penweighted" ///
	== 198

// mregger with radial formulation and tdist
mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, radial tdist
assert abs(_b[radialGP] - .642) < 1e-3
assert abs(_se[radialGP] - .115) < 1e-3
assert abs(_b[_cons] - -.573) < 1e-3
assert abs(_se[_cons] - .354) < 1e-3

// radial and heterogi
mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, radial heterogi
assert abs(e(Q) - 169.97) < 1e-2

// radial and i2gx
mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, radial gxse(ldlcse)
//assert abs(e(Q) - 169.97) < 1e-2

// oldnames
discard
mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1
mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, oldnames
mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, ivw
mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, ivw oldnames

qui mregger chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, radial heterogi gxse(ldlcse)
mregger

// ivw e(phi)
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw
assert e(k) == 73
assert e(phi) - 1.565 < 1e-3

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw fe
assert e(phi) == 1

// mregger e(phi)
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1
assert e(phi) - 1.548 < 1e-3

mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, fe
assert e(phi) == 1
