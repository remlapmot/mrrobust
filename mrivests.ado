*! 0.1.0 Tom Palmer 10jun2017
program mrivests
version 9
syntax varlist(min=3 max=5) [if] [in] , ///
	Generate(string asis) [REPLACE * ]

local varlistlength : word count `varlist'
tokenize `"`varlist'"'
/*
1: gd beta
2: gd SE
3: gp beta
4: gp SE
5: cov between estimates
*/
local gdbeta `1'
local gdse `2'
local gpbeta `3'
if `varlistlength' == 4 {
	local gpse `4'
}
else if `varlistlength' == 5 {
	local gpse `4'
	local cov `5'
}

// work out whether fieller is in `options'
local fmatch = strmatch("`options'","fieller")
if `fmatch' == 1 {
	local fieller fieller
}
else {
	local fieller ""
}

qui count `if' `in'
local selnmax = r(N)
tempvar obsn
qui gen `obsn' = _n 
qui levelsof `obsn' `if' `in'
local selobs "`r(levels)'"

tokenize `"`generate'"', parse(",")
local genvarlist `1'
local genopts `3'
local genvarlistlength : word count `genvarlist'
if `genvarlistlength' != 2 & "`fieller'" == "" {
	di as err "Please specify 2 variable names, " ///
	"which are for the IV estimates and their SEs."
	exit 198
}
if `genvarlistlength' != 3 & "`fieller'" == "fieller" {
	di as err "Please specify 3 variable names, " ///
	"which are for the IV estimates and their lower and upper CI limits."
	exit 198
}

tokenize "`genvarlist'"
local ivest `1'
if "`fieller'" == "" {
	local ivestse `2'
}
else {
	local ivcilow `2'
	local ivciupp `3'
}
if "`genopts'" == "replace" {
	qui replace `ivest' = . `if' `in'
	if "`fieller'" == "" {
		qui replace `ivestse' = . `if' `in'
	}
	else {
		qui replace `ivcilow' = . `if' `in'
		qui replace `ivciupp' = . `if' `in'
	}
}
else {
	qui gen double `ivest' = .
	if "`fieller'" == "" {
		qui gen double `ivestse' = .
	}
	else {
		qui gen double `ivcilow' = .
		qui gen double `ivciupp' = .
	}
}

foreach i of numlist `selobs' {
	local one : di `gdbeta'[`i']
	local two : di `gdse'[`i']
	local thr : di `gpbeta'[`i']
	if `varlistlength' == 3 {
		qui mrratio `one' `two' `thr', `options'
	}
	else if `varlistlength' == 4 {
		local fou : di `gpse'[`i']
		qui mrratio `one' `two' `thr' `fou', `options'
	}
	else if `varlistlength' == 5 {
		local fiv : di `cov'[`i']
		qui mrratio `one' `two' `thr' `fou' `fiv', `options'
	}
	qui replace `ivest' = _b[beta] if _n == `i'
	if "`fieller'" == "" {
		qui replace `ivestse' = _se[beta] if _n == `i'
	}
	else if "`fieller'" == "fieller" & e(fiellerres) == 1 {
		qui replace `ivcilow' = e(lowerci) if _n == `i'
		qui replace `ivciupp' = e(upperci) if _n == `i'
	}
	else if "`fieller'" == "fieller" & e(fiellerres) > 1 {
		qui replace `ivcilow' = . if _n == `i'
		qui replace `ivciupp' = . if _n == `i'               
	}
}

end
exit
