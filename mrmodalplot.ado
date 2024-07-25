*! 0.1.0 2aug2017 Tom Palmer
program mrmodalplot
version 9

syntax varlist(min=4 max=4) [if] [in] [, ///
	WEIGHTed NOME PHI(numlist) seed(string) reps(integer 1000) ///
	lp(string) lc(string) lw(string) *]

if "`phi'" == "" {
	local phi .25 .5 1
}
local nphi : word count `phi'

if "`seed'" != "" {
	local seedopt seed(`seed')
}
else {
	local seedopt 
}

if "`lp'" != "" {
	local nlp : word count `lp'
	if `nlp' != `nphi' {
		di as err "lp() must have same number of elements as phi()"
		exit 198
	}
	if `nphi' > 1 {
		forvalues i=1/`nphi' {
			local lpcmd`i' lp(`: word `i' of `lp'')
		}
	}
	else {
		local lpcmd1 lp(`lp')
	}
}
if "`lc'" != "" {
	local nlc : word count `lc'
	if `nlc' != `nphi' {
		di as err "lc() must have same number of elements as phi()"
		exit 198
	}
	if `nphi' > 1 {
		forvalues i=1/`nphi' {
			local lccmd`i' lc(`: word `i' of `lc'')
		}
	}
	else {
		local lccmd1 lc(`lc')
	}
}
if "`lw'" != "" {
	local nlw : word count `lw'
	if `nlw' != `nphi' {
		di as err "lw() must have same number of elements as phi()"
		exit 198
	}
	if `nphi' > 1 {
		forvalues i=1/`nphi' {
			local lwcmd`i' lw(`: word `i' of `lw'')
		}
	}
	else {
		local lwcmd1 lw(`lw')
	}
}

** fit mrmodal for each value of phi
local i = 1
foreach p of numlist `phi' {
	mrmodal `varlist' `if'`in', ///
		`weighted' `nome' phi(`p') `seedopt' reps(`reps')
	mata mrmodal_densityiv_`i' = mrmodal_densityiv
	mata mrmodal_g_`i' = mrmodal_g
	local i = `i' + 1
}

** plot of densities
preserve
drop _all
qui set obs 512
forvalues i=1/`nphi' {
	getmata (density`i')=mrmodal_densityiv_`i', double
	getmata (g`i')=mrmodal_g_`i', double
	if `i' == 1 {
		local legordercmd `"1 "{&phi} = `: word 1 of `phi''""'
		local legendtext on order(`legordercmd')
		if strpos(`"`options'"', "rows") == 0 local legendtext `legendtext' rows(1)
		if (_caller() >= 18.0) & (strpos(`"`options'"', "pos") == 0) local legendtext `legendtext' pos(6)
		twoway line density`i' g`i', `lpcmd`i'' ///
			`lccmd`i'' ///
			`lwcmd`i'' ///
			xtitle(IV estimates) ///
			ytitle(Density) ///
			legend(`legendtext') `options'
	}
	else {
		local legordercmd `"`legordercmd' `i' "{&phi} = `: word `i' of `phi''""'
		local legendtext on order(`legordercmd')
		if strpos(`"`options'"', "rows") == 0 local legendtext `legendtext' rows(1)
		if (_caller() >= 18.0) & (strpos(`"`options'"', "pos") == 0) local legendtext `legendtext' pos(6)
		addplot : line density`i' g`i', ///
			`lpcmd`i'' ///
			`lccmd`i'' ///
			`lwcmd`i'' ///
			legend(`legendtext') `options'
	}
}

restore

end
exit
