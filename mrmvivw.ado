*! version 0.1.0 22jun2020 Tom Palmer
program mrmvivw, eclass
version 9
local version : di "version " string(_caller()) ", missing :"
local replay = replay()
if replay() {
        if _by() {
                error 190
        }
        `version' Display `0', n(`e(N)') setype(`e(setype)')
        exit
}

syntax varlist(min=2) [aweight] [if] [in] [, ///
	fe ///
    Level(cilevel) ///
	*]

local callersversion = _caller()

// number of genotypes (i.e. rows of data used in estimation)
qui count `if' `in'
local k = r(N)

/*
tokenize `"`varlist'"'
varlist should be specified as:
1: gd beta
2: gp beta1
3: gp beta2
...
aw: =1/gdSE^2
*/
local npheno = wordcount("`varlist'") - 1

tempvar invvar // gyse
qui gen double `invvar' `exp' `if' `in'
// qui gen double `gyse' = 1/sqrt(`invvar') `if' `in'

* Fixed effect SEs
local scale ""
if "`fe'" == "fe" {
	local scale "scale(1)"
	local setype "fe"
}
else {
	local setype "re"
}

* mvivw
qui glm `varlist' [iw=`invvar'] `if' `in', nocons ///
	`scale' level(`level') `options'

/*
regress `varlist' [aw=`invvar'] `if' `in', nocons ///
	level(`level') `options'
*/

mat b = e(b)
mat V = e(V)
ereturn post b V
eret scalar N = `k'
eret local setype = "`setype'"

* display estimates
Display , level(`level') n(`k') setype(`setype')

end

program Display, rclass
syntax , [Level(cilevel)] n(integer) setype(string)

local nlength : strlen local n
local colstart = 79 - 21 - `nlength'
di _n(1) _col(`colstart') as txt "Number of genotypes:", as res `n'

if "`setype'" == "fe" {
	local semessage "Fixed effect"
}
else {
	local semessage "Random effect"
}

local setypelength : strlen local semessage
local colstart = 79 - 17 - `setypelength'
di _col(`colstart') as txt "Standard errors:", as res "`semessage'"

ereturn display, level(`level') noomitted
return add // r(table)
end

exit
