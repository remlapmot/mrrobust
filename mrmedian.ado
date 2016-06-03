*! version 0.1.0 3jun2016 Tom Palmer
program mrmedian
version 9.2 // maybe need 14.0 because of changes in seed
syntax varlist(min=2 max=4) [if] [in] [, Weighted PENWeighted seed(string)]
tempvar betaiv weights
tokenize `"`varlist'"'
/*
2 variables:
1: betaiv
2: weights

4 variables
1: gd beta
2: gd SE
3: gp beta
4: gp SE
*/
if "`4'" == "" & "`3'" != "" {
	di as err "Specifying 3 varnames is not allowed; " ///
		"please specify 2 or 4 varnames"
	exit 198
}
else if "`3'" != "" & "`4'" != "" {
	qui gen double `betaiv' = `1'/`3' `if'
	qui gen double `weights' = (`2'/`3')^-2 `if'
}
qui putmata `1' `2' `3' `4' `betaiv' `weights' `if', replace

** check if moremata installed
capt mata mata which mm_which()
if _rc {
	di as error "mm_which() from -moremata- is required; type -ssc ///
		install moremata- to obtain it"
	exit 499
}

** seed option
if "`seed'" == "" {
	local seed .
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
		`ones', seed=`seed')
}
else if "`weighted'" == "weighted" {
	mata `b1' = weighted_median(`betaiv', `weights')
	mata `s1' = weighted_median_boot(`1', `3', `2', `4', ///
		`weights', seed=`seed')
}
else if "`penweighted'" == "penweighted" {
	mata `pw' = pen_weights(`1', `3', `2')
	mata `b1' = weighted_median(`betaiv', `pw')
	mata `s1' = weighted_median_boot(`1', `3', `2', `4', ///
		`pw', seed=`seed')
}

mata st_matrix("b", `b1')
mata st_matrix("V", `s1'^2)	
local names beta
matrix colnames b = `names'
matrix colnames V = `names' 
matrix rownames V = `names'
ereturn post b V
ereturn display

mata mata drop `1' `2' `3' `4' `betaiv' `weights' seed `b1' `s1'
if "`weighted'" == "" & "`penweighted'" == "" mata mata drop `ones'
if "`penweighted'" == "penweighted" mata mata drop `pw'

end

mata
real scalar weighted_median(real colvector betaiv, real colvector weights) 
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
	| real scalar seed, real scalar reps)
{
	real scalar sd
	real colvector med, bxgboot, bygboot, bivboot
	if (seed != .) {
		rseed(seed)
	}
	if (reps == .) {
		reps = 1000
	}
	med = J(reps, 1, .)
	for (i=1; i<=reps; i++) {
		bxgboot = rnormal(1, 1, bxg, sebxg)
		bygboot = rnormal(1, 1, byg, sebyg)
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
