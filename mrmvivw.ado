*! version 0.1.0 22jun2020 Tom Palmer
program mrmvivw, eclass
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

* display estimates
di ""
Display , level(`level')

end

program Display, rclass
ereturn display, level(`level') noomitted
return add // r(table)
end

exit
