*! version 0.1.0 02jun2017 Tom Palmer
program mrmodal, eclass
version 9
local version : di "version " string(_caller()) ", missing :"
local replay = replay()
if replay() {
	if _by() {
		error 190
	}
	`version' Display `0'
	exit
}

syntax varlist(min=4 max=4) [if] [in] [, Level(cilevel) ///
	WEIGHTed NOME PHI(real 1) seed(string) reps(integer 1000) nosave]

local callersversion = _caller()

// check if kdens package installed
capt mata mata which kdens()
if _rc {
	di as err "The -kdens- package is required; install using"
        di "{stata ssc install kdens}"
	exit 499
}

** seed option
if "`seed'" != "" {
	version `callersversion': set seed `seed'
}

// number of genotypes (i.e. rows of data used in estimation)
qui count `if' `in'
local k = r(N)
if `k' < 3 {
	di as err "mrmodal requires a minimum of 3 genotypes"
	exit 2001
}

tokenize `"`varlist'"'
/*
4 variables:
1: gd beta
2: gd se
3: gp beta
4: gp se
*/

tempvar BetaYG seBetaYG BetaXG seBetaXG betaiv sebetaiv
qui gen double `BetaYG' = `1' `if' `in'
qui gen double `seBetaYG' = `2' `if' `in'
qui gen double `BetaXG' = `3' `if' `in'
qui gen double `seBetaXG' = `4' `if' `in'
qui gen double `betaiv' = `1'/`3' `if' `in'

if "`nome'" == "" {
	qui gen double `sebetaiv' = sqrt((`seBetaYG'^2)/(`BetaXG'^2) + ///
		((`BetaYG'^2)*(`seBetaXG'^2))/(`BetaXG'^4)) `if' `in'
}
else {
	qui gen double `sebetaiv' = `seBetaYG'/abs(`BetaXG') `if' `in'
}

tempvar sebetaivw
if "`weighted'" == "" {
	qui gen double `sebetaivw' = 1 `if' `in'
	local weightind 0
}
else {
	qui gen double `sebetaivw' = `sebetaiv' `if' `in'
	local weightind 1
}


** estimation
mata phi = strtoreal(st_local("phi"))
qui putmata `betaiv' `sebetaiv' `sebetaivw', replace omitmissing
mata densityiv = g = .
mata mrmodal_beta = mrmodal_beta(`betaiv', `sebetaivw', phi, densityiv, g)
if "`save'" == "" {
	mata mrmodal_densityiv = densityiv
	mata mrmodal_g = g
}
mata reps = strtoreal(st_local("reps"))
mata densityiv = g = .
mata mrmodal_se = mrmodal_se(`betaiv', `sebetaiv', `sebetaivw', ///
	phi, reps, `weightind', densityiv, g)
mata mata drop densityiv g 
mata st_matrix("b", mrmodal_beta)
mata st_matrix("V", mrmodal_se^2)	
local names beta
matrix colnames b = `names'
matrix colnames V = `names' 
matrix rownames V = `names'
ereturn post b V

** display coefficient table
Display , level(`level') k(`k') reps(`reps') phi(`phi')

mata mata drop `betaiv' `sebetaiv' `sebetaivw' 
mata mata drop phi mrmodal_beta mrmodal_se reps
ereturn local cmd "mrmodal"
ereturn local cmdline `"mrmodal `0'"'
ereturn scalar k = scalar(`k')
ereturn scalar reps = `reps'
ereturn scalar phi = `phi'
end

program Display, rclass
syntax , [K(integer 0) reps(integer 0) Level(cilevel) PHI(real 0)]
if "`k'" == "0" {
	local k = e(k)
}
if "`reps'" == "0" {
	local reps = e(reps)
}
if "`phi'" == "0" {
	local phi = e(phi)
}
local digits : length local k
local colstart = 79 - (22 + `digits') 
di _n(1) _col(`colstart') as txt "Number of genotypes = " as res %`digits'.0fc `k'
local digits2 : length local reps
local colstart2 = 79 - (15 + `digits2')
di _col(`colstart2') as txt "Replications = " as res %`digits2'.0fc `reps'
local digits3 : length local phi // version 13 strlen bug was here
local colstart3 = 79 - (6 + `digits3')
di _col(`colstart3') as txt "Phi = " as res `phi'
ereturn display, level(`level')
return add // r(table)
end

mata 
real scalar function mrmodal_mad(real colvector x) 
{
	real scalar median
	real scalar mad
	median = mm_median(1.4826*x)  // constant as used in R
	mad = mm_median(abs(1.4826*x :- median))
	return(mad)
}

real scalar function mrmodal_beta(real colvector betaiv,
	real colvector sebetaiv,
	real scalar phi,
	densityiv, g)
{
	real colvector weights
	real scalar sd, mad, min, max, m, cut, pos, maxd, h, s
	
	mad = mrmodal_mad(betaiv)
	sd = sqrt(variance(betaiv))
	s = 0.9*(min((sd, mad)'))/length(betaiv)^(1/5)
	weights = sebetaiv:^(-2) / sum(sebetaiv:^(-2))
	h = s*phi
	cut = 3 // default from R density()
	m = 512 // default from R density()
	min = min(betaiv) - cut*h // as per R density()
	max = max(betaiv) + cut*h // as per R density()
	g = kdens_grid(betaiv, weights, h, "gaussian", m, min, max)
	densityiv = kdens(betaiv, weights, g, h, "gaussian")
	maxd = max(densityiv)
	
	// check if only 1 point gives max density
	if (sum(densityiv :== maxd) != 1) {
		stata(`"di as err "Density of IV estimates has >1 maxima.""')
		stata(`"exit 498"')
	}
	
	pos = mm_which(densityiv :== maxd)
	return(g[pos])
}

real scalar function mrmodal_se(real colvector betaiv,
	real colvector sebetaiv,
	real colvector sebetaivw,
	real scalar phi,
	real scalar reps,
	real scalar weightind,
	densityiv, g)
{
	real colvector res, betaivboot
	real scalar n
	
	res = J(reps, 1, .)
	for (i=1; i<=reps; i++) {
		betaivboot = rnormal(1, 1, betaiv, sebetaiv)
		if (weightind == 0) {
			res[i] = mrmodal_beta(betaivboot, sebetaivw, phi, densityiv, g)
		}
		else if (weightind == 1) {
			res[i] = mrmodal_beta(betaivboot, sebetaivw, phi,
				densityiv, g)
		}
	}
	return(sqrt(variance(res)))
}
end
exit
