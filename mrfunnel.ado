*! 0.1.0 Tom Palmer 29aug2017
program mrfunnel
version 9
syntax varlist [if] [in] [, Metric(string) ///
	noivw nomregger ///
	MRIVESTSopts(string) ///
	EXTRAPlots(string asis) ///
	XLRange(numlist min=2 max=2) ///
	scatteropts(string asis) ///
	*]

if !inlist("`metric'","gpbeta","gpbetastd","invse","") {
	di as error "metric must be one of #"
	exit 198
}
if "`metric'" == "" {
	local metric gpbetastd
}

tokenize `"`varlist'"'
local gdbeta `1'
local segdbeta `2'
local gpbeta `3'
local segpbeta `4'

tempvar iv ivse

mrivests `varlist' `if'`in', `mrivestsopts' g(`iv' `ivse')

if "`metric'" == "gpbeta" {
	tempvar absgpbeta
	qui gen double `absgpbeta' = abs(`gpbeta') `if'`in'
	local yvar `absgpbeta'
	local ytitle "Instrument strength (abs({it:{&gamma}}{sub:j}))"
}
else if "`metric'" == "gpbetastd" {
	tempvar absgpbetastd
	// note: divides by segdbeta rather than segpbeta
	qui gen double `absgpbetastd' = abs(`gpbeta')/`segdbeta' `if'`in'
	local yvar `absgpbetastd'
	local ytitle "Instrument strength (abs({it:{&gamma}}{sub:j})/{it:{&sigma}}{sub:Yj})"
}
else if "`metric'" == "invse" {
	tempvar invivse
	qui gen double `invivse' = 1/`ivse' `if'`in'
	local yvar `invivse'
	local ytitle "Instrument strength (1/{it:{&sigma}}{sub:IV})"
}

local legend legend(on order(1 "Genotypes") rows(1))

if "`ivw'" == "" {
	qui mregger `gdbeta' `gpbeta' [aw=1/`segdbeta'^2] `if'`in', ivw fe
	local ivwest = _b[`gdbeta':`gpbeta']
	if "`xlrange'" == "" local range range(`yvar')
	else local range range(`xlrange')
	local ivwaddplot function `ivwest', lp(dash) lc(gs0) hor `range' || 
	local legend legend(on order(1 "Genotypes" 2 "IVW") rows(1))
}

if "`mregger'" == "" {
	qui mregger `gdbeta' `gpbeta' [aw=1/`segdbeta'^2] `if'`in'
	local mreggerest = _b[slope]
	if "`xlrange'" == "" local range range(`yvar')
	else local range range(`xlrange')
	local mreggeraddplot function `mreggerest', lp(longdash) lc(gs0) hor `range' || 
	if "`ivw'" == "" local legend legend(on order(1 "Genotypes" 2 "IVW" 3 "MR-Egger") rows(1))
	else local legend legend(on order(1 "Genotypes" 2 "MR-Egger") rows(1))	
}

// plot
twoway scatter `yvar' `iv' `if'`in', ///
	mc(gs0) ///
	xtitle("{&beta}{sub:IV}") ///
	ytitle(`ytitle') ///
	`scatteropts' || ///
	`ivwaddplot' ///
	`mreggeraddplot' ///
	`extraplots', ///
	`legend' ///
	`options'

end
