*! version 0.1.0 Tom Palmer 15jun2017
program mrforest
version 12
local version : di "version " string(_caller()) ", missing :"
local callersversion = _caller()
syntax varlist(min=3 max=5) [if] [in] [, ///
	ivid(varname) ///
	models(integer 2) ///
	mrivestsopts(string asis) ///
	effect(string asis) ///
	ivwopts(string asis) ///
	mreggeropts(string asis) ///
	mrmedianopts(string asis) ///
	mrmodalopts(string asis) ///
	gsort(string) ///
	TEXTSize(real 0) ///
	ASTEXT(integer 0) ///
	zcis ///
	Level(cilevel) ///
	noNOTE ///
	ividlabel(string) /// 
	modelslabel(string) ///
	modelsonly ///
	noSTATS ///
	ivwlabel(string) ///
	mreggerlabel(string) ///
	mrmedianlabel(string) ///
	mrmodallabel(string) ///
	noFE * ]

// check metan is installed
capture which metan
if _rc {
	di as error "-metan- from SSC is required; install using"
        di "{stata ssc install metan}"
	exit 499
}

// check if metan9 is installed 
// - if not I assume the old version of metan installed, which is what is required
capture which metan9
if _rc {
	local metancmd metan
}
else {
	local metancmd metan9
}

// tokenize varlist
tempvar gd gdse gp gpse cov
local varlistlength : word count `varlist' 
tokenize `"`varlist'"'
qui gen double `gd' = `1' `if' `in'
qui gen double `gdse' = `2' `if' `in'
qui gen double `gp' = `3' `if' `in'
local mrivestscmd `gd' `gdse' `gp'
if `varlistlength' > 3 {
	qui gen double `gpse' = `4' `if' `in'
	local mrivestscmd `mrivestscmd' `gpse'
}
if `varlistlength' == 5 {
	qui gen double `cov' = `5' `if' `in'
	local mrivestscmd `mrivestscmd' `5'
}

// number of genotypes
qui count `if' `in'
local k = r(N)

// locals for confidence interval level
local leveltail = (100 - `level')/200
local levelupp = (100 - (100 - `level')/2)/100

// generate genotype specific estimates, SEs, and CI limits
tempvar ivest ivse ivcilow ivciupp
qui mrivests `mrivestscmd' `if' `in', `mrivestsopts' generate(`ivest' `ivse')
qui gen double `ivcilow' = `ivest' - invnormal(`levelupp')*`ivse' `if' `in'
qui gen double `ivciupp' = `ivest' + invnormal(`levelupp')*`ivse' `if' `in'

// check gsort option and set local for command
if !inlist("`gsort'", "ascending", "descending", "unsorted", "") {
	di as err "gsort() should be one of: ascending, descending, or unsorted"
	exit 198
}
if "`gsort'" == "" {
    local gsort ascending
}
if "`gsort'" == "ascending" {
    local gsortcmd qui gsort -`ivest'
}
else if "`gsort'" == "descending" {
    local gsortcmd qui gsort +`ivest'
}
else if "`gsort'" == "unsorted" {
	local gsortcmd 
}

// genotype id variable
tempvar ivid2
if "`ivid'" == "" {
	qui gen `ivid2' = "" `if' `in'
}
else {
	qui gen `ivid2' = `ivid' `if' `in'
}
if (`"`ividlabel'"' == "") | (`"`ividlabel'"' != "" & `models' > 0) {
	la var `ivid2' " "
}
if `"`ividlabel'"' != "" & `models' == 0 {
	la var `ivid2' `ividlabel'
}

// fit the summary data models
if `models' < 0 | `models' > 4 {
	di as err "models(#) should be between 0 and 4"
	exit 198
}
local nmodels `models'

// drop the observations not selected
preserve
if "`if'`in'" != "" {
	qui keep `if' `in'
}

// sort the genotypes if required to
`gsortcmd'

// make fe SEs the default for the IVW fit
if inlist(`"`ivwopts'"', "fe") & "`fe'" == "nofe" {
	di as err "Options ivwopts(fe) and nofe may not be specified together"
	exit 198
}

if !inlist(`"`ivwopts'"', "fe") & "`fe'" == "" local ivwopts "fe"

if `models' > 0 {
	if "`ivwlabel'" == "" local ivwlabel "IVW"
	if "`mreggerlabel'" == "" local mreggerlabel "MR-Egger"
	if "`mrmedianlabel'" == "" local mrmedianlabel "Median"
	if "`mrmodallabel'" == "" local mrmodallabel "Modal"
	tempvar group
	local n = _N
	qui set obs `=`n' + `nmodels''
	if `"`ividlabel'"' == "" {
		qui gen `group' = "{bf:Genotypes}"
	}
	else {
		qui gen `group' = "{bf:`ividlabel'}"
	}
	if `"`modelslabel'"' == "" {
		qui replace `group' = "{bf:Summary}" ///
			in `=`n' + 1'/`=`n' + `nmodels''
	}
	else {
		qui replace `group' = "{bf:`modelslabel'}" ///
			in `=`n' + 1'/`=`n' + `nmodels''
	}
	local bycmd by(`group') nosubgroup
	if `nmodels' >= 1 {
		qui replace `ivid2' = "`ivwlabel'" in `=`n' + 1'
		qui mregger `gd' `gp' [aw=1/(`gdse'^2)] in 1/`k', ///
			ivw `ivwopts'
		qui replace `ivest' = _b[`gp'] in `=`n' + 1'
		qui replace `ivse' = _se[`gp'] in `=`n' + 1'
		if "`zcis'" == "" {
			qui replace `ivcilow' = `ivest' - invttail(`=e(k) - 1', `leveltail')*`ivse' in `=`n' + 1'
			qui replace `ivciupp' = `ivest' + invttail(`=e(k) - 1', `leveltail')*`ivse' in `=`n' + 1'
		}
		else {
			qui replace `ivcilow' = `ivest' - invnormal(`levelupp')*`ivse' in `=`n' + 1'
			qui replace `ivciupp' = `ivest' + invnormal(`levelupp')*`ivse' in `=`n' + 1'
		}
	}
	if `nmodels' >= 2 {
		qui replace `ivid2' = "`mreggerlabel'" in `=`n' + 2'
		if `varlistlength' > 3 {
			local gxsecmd gxse(`gpse')
		}
		qui mregger `gd' `gp' [aw=1/(`gdse'^2)] in 1/`k', ///
			`mreggeropts' `gxsecmd'
		if `varlistlength' > 3 {
			local i2gx = e(I2GX)
		}
		qui replace `ivest' = _b[slope] in `=`n' + 2'
		qui replace `ivse' = _se[slope] in `=`n' + 2'
		if "`zcis'" == "" {
			qui replace `ivcilow' = `ivest' - invttail(`=e(k) - 2', `leveltail')*`ivse' in `=`n' + 2'
			qui replace `ivciupp' = `ivest' + invttail(`=e(k) - 2', `leveltail')*`ivse' in `=`n' + 2'
		}
		else {
			qui replace `ivcilow' = `ivest' - invnormal(`levelupp')*`ivse' in `=`n' + 2'
			qui replace `ivciupp' = `ivest' + invnormal(`levelupp')*`ivse' in `=`n' + 2'
		}
	}
    if `nmodels' >= 3 {
		qui replace `ivid2' = "`mrmedianlabel'" in `=`n' + 3'
		qui mrmedian `gd' `gdse' `gp' `gpse' in 1/`k', ///
		`mrmedianopts'
		qui replace `ivest' = _b[beta] in `=`n' + 3'
		qui replace `ivse' = _se[beta] in `=`n' + 3'
		qui replace `ivcilow' = `ivest' - invnormal(`levelupp')*`ivse' in `=`n' + 3'
		qui replace `ivciupp' = `ivest' + invnormal(`levelupp')*`ivse' in `=`n' + 3'                
	}
	if `nmodels' >= 4 {
		qui replace `ivid2' = "`mrmodallabel'" in `=`n' + 4'
		qui mrmodal `gd' `gdse' `gp' `gpse' in 1/`k', ///
			`mrmodalopts'
		qui replace `ivest' = _b[beta] in `=`n' + 4'
		qui replace `ivse' = _se[beta] in `=`n' + 4'
		qui replace `ivcilow' = `ivest' - invnormal(`levelupp')*`ivse' in `=`n' + 4'
		qui replace `ivciupp' = `ivest' + invnormal(`levelupp')*`ivse' in `=`n' + 4'
	}
}

// estimate title on plot
if "`effect'" == "" {
	local effect "Estimate"
}

// I2GX note
if (`models' > 1) & (`varlistlength' > 3) & ("`note'" == "") {
	local i2gxrnd : di %2.1f 100*`i2gx'
	local notecmd note("{it:I{sub:GX}{sup:2}}=`i2gxrnd'%", size(vsmall))
}

// modelsonly
if "`modelsonly'" != "" {
	local modelsin in `=`n' + 1'/`=`n' + `models''
}
else {
	local modelsin 
}

// guesses for text size and space for text
if "`modelsonly'" == "" {
	if "`stats'" == "" {
		if `k' < 30 {
			if `textsize' == 0 local textsize 110.0 
			if `astext' == 0 local astext 50 
		}
		else if `k' >= 30 & `k' < 50 {
			if `textsize' == 0 local textsize 150.0
			if `astext' == 0 local astext 40
		}
		else if `k' >= 50 {
			if `textsize' == 0 local textsize 200.0
			if `astext' == 0 local astext 30
		}
	}
	else {
		if `k' < 30 {
			if `textsize' == 0 local textsize 110.0 
			if `astext' == 0 local astext 50 
		}
		else if `k' >= 30 & `k' < 50 {
			if `textsize' == 0 local textsize 310.0
			if `astext' == 0 local astext 40
		}
		else if `k' >= 50 {
			if `textsize' == 0 local textsize 450.0
			if `astext' == 0 local astext 35
		}        
	}
}
else {
	if "`stats'" == "" {
		if `textsize' == 0 local textsize 150.0
		if `astext' == 0 local astext 50
	}
	else {
		if `textsize' == 0 local textsize 67.0
		if `astext' == 0 local astext 40                
	}
}

// call to metan
`metancmd' `ivest' `ivcilow' `ivciupp' `modelsin', ///
	notable nooverall nobox ///
	lcols(`ivid2') ///
	effect(`"`effect'"') ///
	graphregion(color(white)) ///
	texts(`textsize') ///
	astext(`astext') ///
	nokeep ///
	ilevel(`level') ///
	`notecmd' ///
	`stats' ///
	`options' ///
	`bycmd' nohet
    
// restore the observations that weren't selected - technically not needed
restore

end
exit
