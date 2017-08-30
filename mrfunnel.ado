*! 0.1.0 Tom Palmer 29aug2017
program mrfunnel
syntax varlist [if] [in] [, Metric(string) ///
        noivw nomregger ///
        MRIVESTSopts(string) ///
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

if "`ivw'" == "" {
        qui mregger `gdbeta' `gpbeta' [aw=1/`segdbeta'^2] `if'`in', ivw fe
        local ivw = _b[`gdbeta':`gpbeta']
        local ivwaddplot addplot: , xline(`ivw', lp(dash) lc(gs0)) norescaling
}

if "`mregger'" == "" {
        qui mregger `gdbeta' `gpbeta' [aw=1/`segdbeta'^2] `if'`in'
        local mregger = _b[slope]
        local mreggeraddplot addplot: , xline(`mregger', lp(longdash) lc(gs0)) norescaling
}

// plot
twoway scatter `yvar' `iv' `if'`in', ///
        mc(gs0) ///
        xtitle("{&beta}{sub:IV}") ///
        ytitle(`ytitle') ///
        `options'
`ivwaddplot'
`mreggeraddplot'

end
