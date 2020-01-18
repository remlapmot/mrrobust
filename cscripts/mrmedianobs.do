* mrmedianobs cscript
* 4jun2016

cscript mrmedianobs adofiles mrmedianobs mrmedianobs_work

** simulate data
set seed 12345

set obs 1000
local zformula
forvalues i=1/20 {
	gen int z`i' = rbinomial(2,`=runiform()')
}
egen double x = rowtotal(z*)
replace x = x + rnormal()
gen double y = x + rnormal()

*** test replay
mrmedianobs y (x = z*)
mrmedianobs

*** test seed
mrmedianobs y (x = z*), seed(3456)
scalar b1 = _b[beta]
scalar s1 = _se[beta]
mrmedianobs y (x = z*), seed(3456)
assert abs(_b[beta] - scalar(b1)) < 1e-7
assert abs(_se[beta] - scalar(s1)) < 1e-7

*** test reps()
mrmedianobs y (x = z*), obsboot reps(10) seed(12345)
scalar b2 = _b[beta]
scalar s2 = _se[beta]

mrmedianobs y (x = z*), obsboot reps(10) seed(12345)
assert abs(_b[beta] - scalar(b2)) < 1e-7
assert abs(_se[beta] - scalar(s2)) < 1e-7

mrmedianobs

*** test weights
mrmedianobs y (x = z*), reps(10) seed(12345) weighted

mrmedianobs y (x = z*), reps(10) seed(12345) penweighted

*** test obsboot and weights
mrmedianobs y (x = z*), obsboot reps(10) seed(12345)

mrmedianobs y (x = z*), obsboot reps(10) seed(12345)

mrmedianobs y (x = z*), obsboot reps(10) seed(12345) weighted

mrmedianobs y (x = z*), obsboot reps(10) seed(12345) penweighted

*** test percentile ci limits
mrmedianobs y (x = z*), obsboot reps(10) seed(12345) all

rcof "mrmedianobs y (x = z*), reps(10) seed(12345) all" == 198

rcof "mrmedianobs y (x = z1-z2), reps(10) seed(12345)" == 2001
rcof "mrmedianobs y (x = z1), reps(10) seed(12345)" == 2001
rcof "mrmedianobs y (x = z1-z20) in 1/2, reps(10) seed(12345)" == 2001
rcof "mrmedianobs y (x = z1-z20) in 1, reps(10) seed(12345)" == 2001

mrmedianobs y (x = z1-z3), reps(10) seed(12345) level(90)
mrmedianobs, level(95)
