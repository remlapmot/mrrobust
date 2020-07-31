*! version 0.1.0 31jul2020 Tom Palmer
program mrleaveoneout, rclass
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

syntax varlist(min=2) [if] [in] , ///
	gyse(varname) ///
	[Method(string) ///
	gxse(varlist) ///
	noPRINT ///
	genotype(varname) ///
	noPLOT ///
	metanopts(string asis) ///
	TEXTSize(real 0) ///
	ASTEXT(integer 0) ///
	*]

local callersversion = _caller()

local nvarlist = wordcount("`varlist'")
local npheno = `nvarlist' - 1

tokenize "`varlist'"
local gd `1'
if `nvarlist' == 2 {
	local gp `2'
}
local phenovarlist : subinstr local varlist "`gd' " ""

// set default method
if "`method'" == "" local method ivw
// check method
if !inlist("`method'", "ivw", "egger", "mregger", "mrivw", ///
	"median" "mrmedian", "mrmodal", "modal", "mode") & ///
	!inlist("`method'", "mvmr", "mvivw", "mvegger") {
	di as error "method should be one of: ivw, egger, mregger," ///
		"mrivw, median, mrmedian, mrmodal, modal, mode, mvmr, mvivw, mvegger"
	exit 198
}

// number of genotypes (i.e. rows of data used in estimation)
qui count `if' `in'
local k = r(N)

tempname table

// preserve 
preserve
if "`if'`in'" != "" qui keep `if'`in'

local tempvarlist b se z pvalue ll ul df crit eform
tempvar `tempvarlist'
foreach var in `tempvarlist' {
	qui gen double ``var'' = .
}

if "`print'" == "noprint" local qui qui

if "`genotype'" == "" {
	tempvar genotype
	qui gen str `genotype' = ""
	qui forvalues i = 1/`k' {
		replace `genotype' = "`i'" in `i'
	}
	label variable `genotype' "Genotypes"
}

`qui' forvalues i = 1/`=_N' {
	di _n as txt "Model fitted without genotype:", as res `genotype'[`i']
	
	if inlist("`method'", "ivw", "mrivw") {
		mregger `varlist' [aw=1/`gyse'^2] if _n != `i', ivw fe `options'
	}
	else if inlist("`method'", "egger", "mregger") {
		mregger `varlist' [aw=1/`gyse'^2] if _n != `i', `options'
	}
	else if inlist("`method'", "median", "mrmedian") {
		mrmedian `gd' `gyse' `gp' `gxse' if _n != `i', `options'
	}
	else if inlist("`method'", "mrmodal", "modal", "mode") {
		mrmodal `gd' `gyse' `gp' `gxse' if _n != `i', `options'
	}
	else if inlist("`method'", "mvmr", "mvivw") {
		mrmvivw `varlist' [aw=1/`gyse'^2] if _n != `i', `options'
	}
	else if "`method'" == "mvegger" {
		mrmvegger `varlist' [aw=1/`gyse'^2] if _n != `i', `options'
	}
	mat `table' = r(table)
	local j = 1
	foreach var in `tempvarlist' {
		qui replace ``var'' = `table'[`j',1] in `i'
		local j = `j' + 1
	}
}

if "`plot'" != "noplot" {
	
	if "`print'" != "noprint" di _n as txt "Model fitted to all genotypes"
	
	if inlist("`method'", "ivw", "mrivw") {
		`qui' mregger `varlist' [aw=1/`gyse'^2], ivw fe `options'
		local methodstring IVW
	}
	else if inlist("`method'", "egger", "mregger") {
		`qui' mregger `varlist' [aw=1/`gyse'^2], `options'
		local methodstring MR-Egger
	}
	else if inlist("`method'", "median", "mrmedian") {
		`qui' mrmedian `gd' `gyse' `gp' `gxse', `options'
		local methodstring Median
	}
	else if inlist("`method'", "mrmodal", "modal", "mode") {
		`qui' mrmodal `gd' `gyse' `gp' `gxse', `options'
		local methodstring Modal
	}
	else if inlist("`method'", "mvmr", "mvivw") {
		`qui' mrmvivw `varlist' [aw=1/`gyse'^2], `options'
		local methodstring MVMR
	}
	else if "`method'" == "mvegger" {
		`qui' mrmvegger `varlist' [aw=1/`gyse'^2], `options'
		local methodstring MVMR-Egger
	}
	mat `table' = r(table)

	qui set obs `=_N+1'
	local nnew = _N

	local j = 1
	foreach var in `tempvarlist' {
		qui replace ``var'' = `table'[`j',1] in `nnew'
		local j = `j' + 1
	}
	qui replace `genotype' = "`methodstring'" in `nnew'

	tempvar group
	qui gen `group' = "{bf:Omitted genotype}"
	qui replace `group' = "{bf:All genotypes}" in `=_N'
	local bycmd by(`group') nosubgroup

	if `k' < 30 {
		if `textsize' == 0 local textsize 110.0 
		if `astext' == 0 local astext 50 
    }
    else if `k' >= 30 & `k' < 50 {
		if `textsize' == 0 local textsize 310.0
		if `astext' == 0 local astext 50
    }
    else if `k' >= 50 {
		if `textsize' == 0 local textsize 350.0
		if `astext' == 0 local astext 50
	}

	metan `b' `se', ///
		fixedi ///
		notable ///
		nowt ///
		nobox ///
		texts(`textsize') ///
		astext(`astext') ///
		nooverall lcols(`genotype') ///
		effect("Estimate") ///
		graphregion(color(white)) ///
		nohet ///
		`bycmd' ///
		nokeep ///
		`metanopts'

}

// restore
restore

end
exit