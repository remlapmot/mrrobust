*! version 0.1.0 03jun2016 Tom Palmer
program mrmedian, eclass
version 9
local version : di "version " string(_caller()) ", missing :"
if replay() {
	if _by() {
		error 190
	}
	`version' Display `0'
	exit
}

syntax varlist(min=4 max=4) [if] [in] [, Weighted PENWeighted seed(string) ///
	reps(integer 1000) Level(cilevel)]

local callersversion = _caller()
tokenize `"`varlist'"'
/*
4 variables
1: gd beta
2: gd SE
3: gp beta
4: gp SE
*/

tempvar betaiv weights
qui gen double `betaiv' = `1'/`3' `if' `in'
qui gen double `weights' = (`2'/`3')^-2 `if' `in'

** number of instruments
tempname k
qui count `if' `in' // TODO: missing data patterns??
scalar `k' = r(N)
if scalar(`k') < 3 {
	di as err "mrmedian requires a minimum of 3 genotypes"
	exit 2001
}

** put variables into Mata
qui putmata `1' `2' `3' `4' `betaiv' `weights' `if' `in', replace

** check if moremata installed
capt mata mata which mm_which()
if _rc {
	di as err "The -moremata- package is required; install using"
        di "{stata ssc install moremata}"
	exit 499
}

** seed option
if "`seed'" != "" {
	version `callersversion': set seed `seed'
}

** weighted options
if "`weighted'" == "weighted" & "`penweighted'" == "penweighted" {
	di as err "Specify both weighted and penweighted options " ///
		"is not allowed."
	exit 198
}

** tempnames
tempname b1
tempname s1
tempname ones
tempname pw

** unweighted median
if "`weighted'" == "" & "`penweighted'" == "" {
	mata `ones' = J(rows(`1'), 1, 1)
	mata `b1' = weighted_median(`betaiv', `ones')
	mata `s1' = weighted_median_boot(`1', `3', `2', `4', ///
		`ones', reps=`reps')
}
else if "`weighted'" == "weighted" {
	mata `b1' = weighted_median(`betaiv', `weights')
	mata `s1' = weighted_median_boot(`1', `3', `2', `4', ///
		`weights', reps=`reps')
}
else if "`penweighted'" == "penweighted" {
	mata `pw' = pen_weights(`1', `3', `2')
	mata `b1' = weighted_median(`betaiv', `pw')
	mata `s1' = weighted_median_boot(`1', `3', `2', `4', ///
		`pw', reps=`reps')
}

mata st_matrix("b", `b1')
mata st_matrix("V", `s1'^2)	
local names beta
matrix colnames b = `names'
matrix colnames V = `names' 
matrix rownames V = `names'
ereturn post b V
local ngeno = scalar(`k')
Display, k(`ngeno') reps(`reps') level(`level')

mata mata drop `1' `2' `3' `4' `betaiv' `weights' `b1' `s1' reps
if "`weighted'" == "" & "`penweighted'" == "" mata mata drop `ones'
if "`penweighted'" == "penweighted" mata mata drop `pw'

ereturn local cmd "mrmedian"
ereturn local cmdline `"mrmedian `0'"'
ereturn scalar k = scalar(`k')
ereturn scalar reps = `reps'
end

program Display, rclass
version 9
syntax , [K(integer 0) reps(integer 0) Level(cilevel)] 
if "`k'" == "0" {
	local k = e(k)
}
if "`reps'" == "0" {
	local reps = e(reps)
}
local digits : length local k
local colstart = 79 - (22 + `digits') 
di _n(1) _col(`colstart') as txt "Number of genotypes = " as res %`digits'.0fc `k'
local digits2 : length local reps
local colstart2 = 79 - (15 + `digits2')
di _col(`colstart2') as txt "Replications = " as res %`digits2'.0fc `reps'
ereturn display, level(`level')
return add // r(table)
end

mata
mata set matastrict on
real scalar weighted_median(real colvector betaiv, 
	real colvector weights) 
{
	real colvector order, betaivorder, weightsorder, weightssum
	real scalar below, weightedest
	order = order(betaiv,1)
	betaivorder = betaiv[order]
	weightsorder = weights[order]
	weightssum = mm_colrunsum(weightsorder) - 0.5*weightsorder
	weightssum = weightssum/sum(weightsorder)
	below = max(mm_which(weightssum :< 0.5))
	weightedest = betaivorder[below] + (betaivorder[below + 1] - ///
		betaivorder[below])*(0.5 - weightssum[below])/ ///
		(weightssum[below + 1] - weightssum[below])
	return(weightedest)
}

real scalar weighted_median_boot(real colvector byg,
	real colvector bxg,
	real colvector sebyg,
	real colvector sebxg,
	real colvector weights, 
	real scalar reps)
{
	real scalar sd, k
	real colvector med, bxgboot, bygboot, bivboot
	k = rows(byg)
	med = J(reps, 1, .)
	bivboot = J(k, 1, .)
	for (i=1; i<=reps; i++) {
		bygboot = rnormal(1, 1, byg, sebyg)
		bxgboot = rnormal(1, 1, bxg, sebxg)
		bivboot = bygboot :/ bxgboot
		med[i] = weighted_median(bivboot, weights)
	}
	sd = sqrt(variance(med))
	return(sd)
}

real colvector pen_weights(real colvector byg, 
	real colvector bxg,
	real colvector sebyg)
{
	real scalar betaivw
	real colvector betaiv, weights, penweights, penalty
	betaiv = byg :/ bxg
	weights = (sebyg :/ bxg):^-2
	betaivw = sum(byg:*bxg:*sebyg:^-2)/sum(bxg:^2:*sebyg:^-2)
	penalty = chi2tail(1, weights:*(betaiv :- betaivw):^2)
	penweights = weights:*rowmin((J(rows(byg),1,1), penalty*20))
	return(penweights)
}
end
exit
