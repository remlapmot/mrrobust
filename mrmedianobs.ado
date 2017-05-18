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
        PENWeighted Weighted all]
        
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

mrmedianobs_work `beforeopts' `if' `in', `weighted' `penweighted'

mat b = e(b)
tempname k
scalar `k' = e(k)
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
        di _n
}
ereturn post b V
local ngeno = scalar(`k')
Display, k(`ngeno') n(`nobs')
ereturn local cmd "mrmedianobs"
ereturn local cmdline `"mrmedianobs `0'"'
ereturn scalar k = scalar(`k')
ereturn scalar N = `nobs'
end

program Display
version 9
syntax [, K(integer 0) N(integer 0)]
if "`k'" == "0" {
        local k = e(k)
}
if "`n'" == "0" {
        local n = e(N)
}
local digits1 : length local k
local digits2 : length local n
local colstart1 = 79 - (22 + `digits1')
local colstart2 = 79 - (16 + `digits2')
di _n(1) _col(`colstart1') "Number of genotypes = " as res %`digits1'.0fc `k'
di _col(`colstart2') "Number of obs = " as res %`digits2'.0fc `n'
ereturn display
end
exit
