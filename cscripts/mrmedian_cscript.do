* mrmedian test code
* 3jun2016

cscript

** view helpfile
*view mrmedian.sthlp

which mrmedian

use dodata, clear

*** test error messages
rcof "noi mrmedian chdbeta" == 102
rcof "noi mrmedian chdbeta chdse" == 102
rcof "noi mrmedian chdbeta chdse ldlcbeta" == 102
rcof "noi mrmedian chdbeta chdse ldlcbeta ldlcse hdlcbeta" == 103

rcof "noi mrmedian chdbeta chdse ldlcbeta ldlcse, weighted penweighted" == 198

*** ldlc - analysis 1
gen byte sel1 = (ldlcp2 < 1e-8)

** unweighted median
mrmedian chdbeta chdse ldlcbeta ldlcse if sel1
assert abs(_b[beta] - .429) < 1e-3
assert abs(_se[beta] - .07) < 1e-2

mrmedian chdbeta chdse ldlcbeta ldlcse if sel1, seed(12345)
scalar b1 = _b[beta]
scalar s1 = _se[beta]

mrmedian chdbeta chdse ldlcbeta ldlcse if sel1, seed(12345)
assert abs(_b[beta] - scalar(b1)) < 1e-7
assert abs(_se[beta] - scalar(s1)) < 1e-7


** weighted median
mrmedian chdbeta chdse ldlcbeta ldlcse if sel1, weighted
assert abs(_b[beta] - .458) < 1e-3
assert abs(_se[beta] - .06) < 1e-2

** penalized weighted
mrmedian chdbeta chdse ldlcbeta ldlcse if sel1, penweighted
assert abs(_b[beta] - .457) < 1e-3
assert abs(_se[beta] - .06) < 1e-2

*** test ereturn results
mrmedian chdbeta chdse ldlcbeta ldlcse if sel1
assert e(cmd) == "mrmedian"
assert e(cmdline) == "mrmedian chdbeta chdse ldlcbeta ldlcse if sel1"
assert e(k) == 73
assert e(properties) == "b V"

*** test in condition
gen int order = _n
gsort -sel1

mrmedian chdbeta chdse ldlcbeta ldlcse in 1/73, seed(12345)
scalar b2 = _b[beta]
scalar s2 = _se[beta]

mrmedian chdbeta chdse ldlcbeta ldlcse in 1/73, seed(12345)
assert e(k) == 73
assert abs(_b[beta] - scalar(b2)) < 1e-7
assert abs(_se[beta] - scalar(s2)) < 1e-7


*** test reps option
sort order
mrmedian chdbeta chdse ldlcbeta ldlcse if sel1, seed(12345) reps(50)
scalar b3 = _b[beta]
scalar s3 = _se[beta]

mrmedian chdbeta chdse ldlcbeta ldlcse if sel1, seed(12345) reps(50)
assert abs(_b[beta] - scalar(b3)) < 1e-7
assert abs(_se[beta] - scalar(s3)) < 1e-7

*** test replay
discard
mrmedian chdbeta chdse ldlcbeta ldlcse if sel1
mrmedian

*** test by: fails with error
rcof "bysort a2: mrmedian chdbeta chdse ldlcbeta ldlcse if sel1" == 190

*** test if and in give same SE with same seed and same sort order of the dataset
keep if sel1
mrmedian chdbeta chdse ldlcbeta ldlcse if sel1, seed(12345)
scalar b4 = _b[beta]
scalar s4 = _se[beta]

mrmedian chdbeta chdse ldlcbeta ldlcse in 1/73, seed(12345)
assert abs(_b[beta] - scalar(b4)) < 1e-7
assert abs(_se[beta] - scalar(s4)) < 1e-7

** disallow 2 and 1 genotypes - although median is defined for N=1 and N=2
rcof "mrmedian chdbeta chdse ldlcbeta ldlcse in 1/2" == 2001
rcof "mrmedian chdbeta chdse ldlcbeta ldlcse in 1" == 2001

** test level option
mrmedian chdbeta chdse ldlcbeta ldlcse if sel1, seed(12345) level(95)
assert abs(_b[beta] - .429) < 1e-3
assert abs(_se[beta] - .07) < 1e-2
mrmedian, level(90)

mrmedian chdbeta chdse ldlcbeta ldlcse if sel1, seed(12345) level(90)
assert abs(_b[beta] - .429) < 1e-3
assert abs(_se[beta] - .07) < 1e-2
mrmedian, level(80)
