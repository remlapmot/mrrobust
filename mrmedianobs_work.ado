*! version 0.1.0 04jun2016 Tom Palmer
program mrmedianobs_work, eclass
_iv_parse `0'   // parses `0' of form: lhs exog (endog = inst)
local lhs `s(lhs)'
local endog `s(endog)'
local exog `s(exog)'
local inst `s(inst)'
local 0 `s(zero)'
local k = wordcount("`inst'") // no. instruments
tokenize `inst'
syntax [anything] [if] [in] [, PENWeighted Weighted reps(integer 50)]
mata gd = gdse = gp = gpse = J(`k', 1, .)
forvalues i=1/`k' {
	qui regress `lhs' ``i'' `exog' `if' `in'
	mata gd[`i'] = st_matrix("e(b)")[1]
	mata gdse[`i'] = sqrt(st_matrix("e(V)")[1,1])
	qui regress `endog' ``i'' `exog' `if' `in'
	mata gp[`i'] = st_matrix("e(b)")[1]
	mata gpse[`i'] = sqrt(st_matrix("e(V)")[1,1])
}
ereturn scalar k = `k'
preserve
drop _all
cap set obs `k'
qui getmata gd gdse gp gpse, double replace
ereturn scalar reps = e(reps)
qui mrmedian gd gdse gp gpse, `weighted' `penweighted' reps(`reps')
restore
end
