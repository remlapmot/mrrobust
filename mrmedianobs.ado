*! version 0.1.0 04jun2016 Tom Palmer
program mrmedianobs, eclass
version 9
local version : di "version " string(_caller()) ", missing :"
if replay() {
	if _by() {
		error 190
	}
	`version' Display `0'
	exit
}

tokenize `"`0'"', parse(",")
local beforeopts `1'

syntax [anything] [if] [in] [, obsboot seed(string) reps(integer 50) ///
	PENWeighted Weighted all Level(cilevel)]
    
** weighted options
if "`weighted'" == "weighted" & "`penweighted'" == "penweighted" {
	di as err "Specify both weighted and penweighted options " ///
		"is not allowed."
	exit 198
}

** all requires obsboot
if "`all'" == "all" & "`obsboot'" == "" {
	di as err "all requires obsboot is specified"
	exit 198
}

local callersversion = _caller()
** seed option
if "`seed'" != "" {
	version `callersversion': set seed `seed'
}

qui count `if' `in' // !missing(`lhs',`endog',) // and all instruments
local nobs = r(N)
if `nobs' < 3 {
	di as err "mrmedianobs needs a minimum of 3 observations"
	exit 2001
}

mrmedianobs_work `beforeopts', `weighted' `penweighted' reps(`reps')
mat b = e(b)
tempname k
scalar `k' = e(k)
local nreps = e(reps)

if "`obsboot'" == "" {
	mat V = e(V)
}
else {
	bootstrap beta=_b[beta], reps(`reps') notable noheader nolegend: ///
		mrmedianobs_work `1' `if', `weighted' `penweighted'
	if "`all'" == "all" {
		estat bootstrap, all noheader
	}
	mat b = e(b)
	mat V = e(V)
	local nreps = e(N_reps)
}
ereturn post b V
local ngeno = scalar(`k')
Display, k(`ngeno') n(`nobs') reps(`nreps') level(`level')
ereturn local cmd "mrmedianobs"
ereturn local cmdline `"mrmedianobs `0'"'
ereturn scalar k = scalar(`k')
ereturn scalar N = `nobs'
ereturn scalar reps = `nreps'
end

program Display
version 9
syntax [, K(integer 0) N(integer 0) reps(integer 0) Level(cilevel)]
if "`k'" == "0" {
	local k = e(k)
}
if "`n'" == "0" {
	local n = e(N)
}
if "`reps'" == "0" {
	local reps = e(reps)
}
local digits1 : length local k
local digits2 : length local n
local digits3 : length local reps
local colstart1 = 79 - (22 + `digits1')
local colstart2 = 79 - (16 + `digits2')
local colstart3 = 79 - (15 + `digits3')
di _n(1) _col(`colstart1') as txt "Number of genotypes = " as res %`digits1'.0fc `k'
di _col(`colstart2') as txt "Number of obs = " as res %`digits2'.0fc `n'
di _col(`colstart3') as txt "Replications = " as res %`digits3'.0fc `reps'
ereturn display, level(`level')
end
exit
