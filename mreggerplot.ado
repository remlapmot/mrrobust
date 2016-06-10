*! version 0.1.0 Tom Palmer 06jun2016
program mreggerplot
version 12
local version : di "version " string(_caller()) ", missing :"

syntax varlist(min=4 max=4) [if] [in] [, ivw fe re ///
        reslope recons median egger noline ///
        nomcis nolci errorbars Level(cilevel) wmarkers ///
        PENWeighted reps(integer 50) seed(string) Weighted ///
        ellipses mlabel(varname) legend(string) ///
         *]

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
        la var `eggery' `""`1'{char 215}sign(`3')""'
        la var `eggerx' "abs(`3')"
}
        
// set up the plot using a scatter plot with invisible markers
if ("`ivw'" == "ivw" | "`median'" == "median") & "`egger'" == "" {
        twoway scatter `1' `3' `if' `in', mc(none)
}
else if "`egger'" == "egger" {
        twoway scatter `eggery' `eggerx' `if' `in', mc(none)
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

// plot confidence intervals around fitted line
if "`lci'" == "" {
        // code for cis around lines
        if "`egger'" == "egger" {
                addplot : lfitci `eggery' `eggerx' `if' `in' ///
                        [aw=1/(`2'^2)], nofit fcolor("204 204 204") /// // gs12
                        fintensity(inten50) level(`level')
        }
        if "`ivw'" == "ivw" {
                addplot : lfitci `1' `3' `if' `in' [aw=1/(`2'^2)], ///
                        estopts(nocons) nofit fcolor("204 204 204") /// // gs12
                        fintensity(inten50) level(`level')
        }
}

// plot fitted line
if "`line'" == "" {
        if "`egger'" == "egger" {
                addplot : line `eggerline' `eggerx' `if' `in', ///
                        lc(gs0) sort ///
                         // legend(order(3 4 2) rows(1))
        }
        if "`ivw'" == "ivw" {
                addplot : line `ivwline' `3' `if' `in', ///
                        lc(gs0) sort ///
                         // legend(order(3 4 2) rows(1))
        }
        if "`median'" == "median" {
                addplot : line `medianline' `3' `if' `in', ///
                        lc(gs0) sort ///
                        // legend(`legend')
        }
}

// plot 95% cis around markers
if "`ellipses'" == "" & "`errorbars'" == "" {
        // set default as errobars
        local errorbars errorbars
}
if "`ellipses'" == "ellipses" & "`mcis'" == "" {
        // ellipses code
        tempvar x y
        if "`egger'" == "egger" {
                qui gen double `y' = `eggery' `if' `in'
                qui gen double `x' = `eggerx' `if' `in'
                la var `y' "`1'{char 215}sign(`3')"
                la var `x' "abs(`3')"
                
        }
        else {
                qui gen double `y' = `1' `if' `in' 
                qui gen double `x' = `3' `if' `in'
                la var `x' `1'
                la var `y' `3'
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
                        "`twycmd' line `y`i'' `x`i'', lc(gs8) || "
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
        local rcgd rcap `gdcilow' `gdciupp' `x' `if' `in', lc(gs8)
        local rcgp rcap `gpcilow' `gpciupp' `y' `if' `in', lc(gs8) horizontal 
        addplot : `rcgd' || `rcgp' , legend(`legend')
}

// replot the markers with colour
if "`egger'" == "egger" {
        addplot : scatter `eggery' `eggerx' `if' `in' `weight', ///
                m(s) mc(gs6) mlabel(`mlabel') ///
                legend(`legend')
}
else {
        addplot : scatter `1' `3' `if' `in' `weight', ///
                m(s) mc(gs6) mlabel(`mlabel') ///
                legend(`legend')
}

end
exit
