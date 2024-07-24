*! version 0.1.0 Tom Palmer 06jun2016
program mreggerplot
version 12
local version : di "version " string(_caller()) ", missing :"

syntax varlist(min=4 max=4) [if] [in] [, ivw fe re ///
	reslope recons median egger noLINE ///
	noMCIS noLCI errorbars Level(cilevel) wmarkers ///
	PENWeighted reps(integer 50) seed(string) Weighted ///
	ellipses mlabel(varname) legend(string asis) ///
	linetop GPCI ///
	mleglabel(string) * ]

local callersversion = _caller()

// weighted or penweighted specified with median
if "`median'" == "" & ("`weighted'" != "" | "`penweighted'" != "") {
	di as err "Please specify median with weighted or penweighted options"
	exit 198
}

// check only one of "", egger, ivw, median specified
if "`ivw'" == "ivw" & "`egger'" == "egger" {
	di as err "only one of options `ivw' or `egger' allowed"
	exit 198
}
else if "`ivw'" == "ivw" & "`median'" == "median" {
	di as err "only one of options `ivw' or `median' allowed"
	exit 198
}
else if "`egger'" == "egger" & "`median'" == "median" {
	di as err "only one of options `egger' or `median' allowed"
	exit 198
}

if "`ivw'" == "" & "`median'" == "" & "`egger'" == "" {
	local egger egger
}

if `"`mleglabel'"' == "" {
	local mleglabel Instruments
}

if "`errorbars'" == "errorbars" & "`ellipses'" == "ellipses" {
	di as err "Options ellipses and errorbars cannot both be specified"
	exit 198
}

tokenize `"`varlist'"'
/*
4 variables:
1: gd beta
2: gd SE
3: gp beta
4: gp SE
*/

// check if addplot is installed
capture which addplot
if _rc {
	di as error "-addplot- from SSC is required; install using"
    di "{stata ssc install addplot}"
	exit 499
}

// count no. instruments
qui count `if' `in'
local k = r(N)

local percentile = 1 - (1 - `level'/100)/2

if "`gpci'" == "gpci" & "`mcis'" == "nomcis" {
	di as err "nomcis and gpci options may not be specified together"
	exit 198
}

local legendwc : word count `legend'
if `legendwc' == 0 {
	local legend on
}

// copy contents of legend option
local legendusertext `legend'

if "`median'" == "median" {
	local lci nolci
}

if "`ellipses'" == "" & "`errorbars'" == "" {
	// set default as errobars
	local errorbars errorbars
}

// set-up local for legend
if `"`legend'"' != "off" {
	if "`egger'" == "egger" {
		local lname MR-Egger
	}
	if "`median'" == "median" {
		local lname Median
	}
	if "`ivw'" == "ivw" {
		local lname IVW
	}
	if "`lci'" == "" & "`gpci'" == "" & ///
		"`mcis'" == "" {
		if "`line'" == "" {
			local lleg 3 "`lname'"
		}
		else {
			local lleg ""
		}
		if "`linetop'" == "" {
			if "`errorbars'" == "errorbars" {
				local mlabn 5
			}
			else {
				local mlabn = 4 + `k'
			}
			local legend `"order(`mlabn' "`mleglabel'" 4 "`level'% CIs" `lleg' 2 "`lname' `level'% CI") rows(1) size(small)"'
		}
		else {
			local legend `"order(3 "`mleglabel'" 2 "`level'% CIs" 5 "`lname'" 4 "`lname' `level'% CI") rows(1) size(small)"'
		}
	}
	if "`line'" == "" & "`lci'" == "" & "`gpci'" == "gpci" & ///
		"`mcis'" == "" {
		if "`linetop'" == "" {
			local legend `"order(6 "`mleglabel'" 4 "`level'% CIs" 3 "`lname'" 2 "`lname' `level'% CI") rows(1) size(small)"'
		}
		else {
			local legend `"order(4 "`mleglabel'" 2 "`level'% CIs" 6 "`lname'" 5 "`lname' `level'% CI") rows(1) size(small)"'
		}
	}
	if "`line'" == "" & "`lci'" == "" & "`gpci'" == "" & ///
		"`mcis'" == "nomcis" {
		if "`linetop'" == "" {
			local legend `"order(4 "`mleglabel'" 3 "`lname'" 2 "`lname' `level'% CI") rows(1) size(small)"'
		}
		else {
			local legend `"order(2 "`mleglabel'" 4 "`lname'" 3 "`lname' `level'% CI") rows(1) size(small)"'
		}
	}
	if "`line'" == "" & "`lci'" == "nolci" & "`gpci'" == "" & ///
		"`mcis'" == "" {
		if "`linetop'" == "" {
			local legend `"order(4 "`mleglabel'" 3 "`level'% CIs" 2 "`lname'") rows(1) size(small)"'
		}
		else {
			local legend `"order(3 "`mleglabel'" 2 "`level'% CIs" 4 "`lname'") rows(1) size(small)"'
		}
	}
	if "`line'" == "" & "`lci'" == "nolci" & ///
		"`gpci'" == "gpci" & "`mcis'" == "" {
		if "`linetop'" == "" {
			local legend `"order(5 "`mleglabel'" 4 "`level'% CIs" 2 "`lname'") rows(1) size(small)"'
		}
		else {
			local legend `"order(4 "`mleglabel'" 2 "`level'% CIs" 5 "`lname'") rows(1) size(small)"'
		}
	}
	if "`line'" == "" & "`lci'" == "nolci" & "`gpci'" == "" & ///
	"`mcis'" == "nomcis" {
		if "`linetop'" == "" {
			local legend `"order(3 "`mleglabel'" 2 "`lname'") rows(1) size(small)"'
		}
		else {
			local legend `"order(2 "`mleglabel'" 3 "`lname'") rows(1) size(small)"'
		}
	}
	local legend `legendusertext' `legend'
}

// weighted markers
if "`wmarkers'" == "wmarkers" {
	tempvar weightvar
	qui gen double `weightvar' = 1/(`2'^2) `if' `in'
	qui su `weightvar'
	local weightvarsum = r(sum)
	qui replace `weightvar' = `weightvar'/`weightvarsum' `if' `in'
	local weight [aw=`weightvar']
}

// variables for mr-egger
if "`egger'" == "egger" {
tempvar eggery eggerx
	qui gen double `eggery' = `1'*sign(`3') `if' `in'
	qui gen double `eggerx' = abs(`3') `if' `in'
	la var `eggery' `"Instrument-outcome associations"'
	// la var `eggery' `""`1'{char 215}sign(`3')""'
	la var `eggerx' `"Instrument-exposure associations"' 
	// la var `eggerx' "abs(`3')"
}
        
// set up the plot using a scatter plot with invisible markers
if ("`ivw'" == "ivw" | "`median'" == "median") & "`egger'" == "" {
	la var `3' `"Instrument-exposure associations"'
	la var `1' `"Instrument-outcome associations"'
	twoway scatter `1' `3' `if' `in', mc(none) ///
		graphregion(color(white)) `options' legend(`legend')
}
else if "`egger'" == "egger" {
	twoway scatter `eggery' `eggerx' `if' `in', mc(none) ///
		graphregion(color(white)) `options' legend(`legend')
}

// fit ivw, mr-egger, or weighted median
if "`egger'" == "egger" {
	// mr-egger
	qui mregger `1' `3' [aw=1/(`2'^2)] `if' `in', ///
		`fe' `re' `reslope' `recons'
	tempvar eggerline
	qui gen double `eggerline' = _b[_cons] + _b[slope]*`eggerx' `if' `in'
	la var `eggerline' "MR-Egger"
}
if "`ivw'" == "ivw" {
	// ivw
	qui mregger `1' `3' [aw=1/(`2'^2)] `if' `in', ///
		`ivw' `fe' `re' `reslope' `recons'
	tempvar ivwline
	local ivwslope = _b[`3']
	qui gen double `ivwline' = _b[`3']*`3' `if' `in'
	la var `ivwline' "IVW"
}
if "`median'" == "median" {
	// median
	qui mrmedian `1' `2' `3' `4' `if' `in', ///
		`penweighted' reps(`reps') ///
		seed(`seed') `weighted'
	local medianslope = _b[beta]
	tempvar medianline
	qui gen double `medianline' = _b[beta]*`3' `if' `in'
	la var `medianline' "Median"
}

if "`linetop'" == "" {
	// plot confidence intervals around fitted line
	if "`lci'" == "" {
		// code for cis around lines
		if "`egger'" == "egger" {
			addplot : lfitci `eggery' `eggerx' `if' `in' ///
				[aw=1/(`2'^2)], nofit ///
				fcolor("204 204 204") ///
				fintensity(inten50) level(`level') ///
				alwidth(vthin) legend(`legend')
		}
		if "`ivw'" == "ivw" {
			addplot : lfitci `1' `3' `if' `in' ///
				[aw=1/(`2'^2)], ///
				estopts(nocons) nofit ///
				fcolor("204 204 204") ///
				fintensity(inten50) level(`level') ///
				alwidth(vthin) legend(`legend')
		}
	}
	
	// plot fitted line
	if "`line'" == "" {
		if "`egger'" == "egger" {
			addplot : line `eggerline' `eggerx' `if' `in', ///
				lc(gs0) sort ///
				legend(`legend')
		}
		if "`ivw'" == "ivw" {
			addplot : line `ivwline' `3' `if' `in', ///
				lc(gs0) sort ///
				legend(`legend')
		}
		if "`median'" == "median" {
			addplot : line `medianline' `3' `if' `in', ///
				lc(gs0) sort ///
				legend(`legend')
		}
	}
}

// plot 95% cis around markers
if "`ellipses'" == "ellipses" & "`mcis'" == "" {
	// ellipses code
	tempvar x y
	if "`egger'" == "egger" {
		qui gen double `y' = `eggery' `if' `in'
		qui gen double `x' = `eggerx' `if' `in'
		la var `y' "Instrument-outcome associations"
		// la var `y' "`1'{char 215}sign(`3')"
		la var `x' "Instrument-exposure associations"
		//la var `x' "abs(`3')"
	}
	else {
		qui gen double `y' = `1' `if' `in' 
		qui gen double `x' = `3' `if' `in'
		// la var `x' `1'
		la var `x' "Instrument-exposure associations"
		// la var `y' `3'
		la var `y' "Instrument-outcome associations"
	}
	tempvar t
	local obs = _N
	qui range `t' 0 `=2*_pi' 400
	tempname sqrtc
	scalar `sqrtc' = sqrt(invchi2(2, `=`level'/100'))
	local twycmd ""
	tempname X gdval gdseval gpval gpseval
	qui putmata `X'=(`y' `2' `x' `4') `if' `in', replace
	forvalues i = 1/`k' {
		tempvar y`i' x`i'
		mata st_numscalar("`gdval'", `X'[`i', 1])
		mata st_numscalar("`gdseval'", `X'[`i', 2])
		mata st_numscalar("`gpval'", `X'[`i', 3])
		mata st_numscalar("`gpseval'", `X'[`i', 4])
		qui gen double `x`i'' = `gpval' + ///
				`gpseval'*`sqrtc'*cos(`t')
		qui gen double `y`i'' = `gdval' + `gdseval'*`sqrtc'* ///
				cos(`t' + acos(0))
		local twycmd ///
			"`twycmd' line `y`i'' `x`i'', lc(gs8) lw(vthin) || "
	}
	addplot : `twycmd', legend(`legend')
	if `obs' < 400 {
		qui drop in `=`obs'+1'/400 
	}
}
if "`errorbars'" == "errorbars" & "`mcis'" == "" {
	// confidence intervals as capped lines
	tempvar gdciupp gdcilow gpciupp gpcilow x y
	if "`egger'" == "egger" {
		qui gen double `y' = `eggery' `if' `in' 
		qui gen double `x' = `eggerx' `if' `in'
	}
	else {
		qui gen double `y' = `1' `if' `in' 
		qui gen double `x' = `3' `if' `in'                
	}
	qui gen double `gdcilow' = `y' - invnormal(`percentile')*`2'
	qui gen double `gdciupp' = `y' + invnormal(`percentile')*`2'
	qui gen double `gpcilow' = `x' - invnormal(`percentile')*`4'
	qui gen double `gpciupp' = `x' + invnormal(`percentile')*`4'
	local rcgd rcap `gdcilow' `gdciupp' `x' `if' `in', lc(gs0) ///
		lwidth(vthin) msize(vsmall) mfcolor(gs0) mlcolor(gs0) ///
		mcolor(gs0)
	local rcgp rcap `gpcilow' `gpciupp' `y' `if' `in', lc(gs0) ///
		lwidth(vthin) msize(vsmall) mfcolor(gs0) mlcolor(gs0) ///
		mcolor(gs0) horizontal
	addplot : `rcgd' , legend(`legend')
	if "`gpci'" == "gpci" {
		addplot : `rcgp' , legend(`legend')
	}
}

// replot the markers with colour
if "`egger'" == "egger" {
	addplot : scatter `eggery' `eggerx' `if' `in' `weight', ///
		m(s) mc(gs0) mlabel(`mlabel') mlabcolor(black) ///
		mlabsize(vsmall) msize(vsmall) ///
		legend(`legend')
}
else {
	addplot : scatter `1' `3' `if' `in' `weight', ///
		m(s) mc(gs0) mlabel(`mlabel') mlabcolor(black) ///
		mlabsize(vsmall) msize(vsmall) ///
		legend(`legend')
}

// draw fitted line (and ci) on top
if "`linetop'" != "" {
	// plot confidence intervals around fitted line
	if "`lci'" == "" {
		// code for cis around lines
		if "`egger'" == "egger" {
			addplot : lfitci `eggery' `eggerx' `if' `in' ///
				[aw=1/(`2'^2)], nofit ///
				fcolor("204 204 204") ///
				fintensity(inten50) level(`level') ///
				alwidth(vthin) legend(`legend')
		}
		if "`ivw'" == "ivw" {
			addplot : lfitci `1' `3' `if' `in' [aw=1/(`2'^2)], ///
				estopts(nocons) nofit ///
				fcolor("204 204 204") ///
				fintensity(inten50) level(`level') ///
				alwidth(vthin) legend(`legend')
		}
	}
	
	// plot fitted line
	if "`line'" == "" {
		if "`egger'" == "egger" {
			addplot : line `eggerline' `eggerx' `if' `in', ///
				lc(gs0) sort legend(`legend')
		}
		if "`ivw'" == "ivw" {
			addplot : line `ivwline' `3' `if' `in', ///
				lc(gs0) sort legend(`legend')
		}
		if "`median'" == "median" {
			addplot : line `medianline' `3' `if' `in', ///
				lc(gs0) sort legend(`legend')
		}
	}
}

end
exit
