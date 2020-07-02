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
	gxse(varlist) ///
	*]

local callersversion = _caller()

/*
varlist should be specified as:
1: gd beta
2: gp beta1
3: gp beta2
...
aw: =1/gdSE^2
*/

// number of genotypes (i.e. rows of data used in estimation)
qui count `if' `in'
local k = r(N)

// number of phenotypes
local npheno = wordcount("`varlist'") - 1
tokenize `"`varlist'"'
tempvar outcome
qui gen double `outcome' = `1' `if'`in'
forvalues i = 1/`npheno' {
	tempvar pheno`i'
	local phenoname`i' ``=`i' + 1''
	qui gen double `pheno`i'' = `=`i' + 1' `if'`in'
}

// genotype-disease standard errors
tempvar invvar gyse
qui gen double `invvar' `exp' `if' `in'
qui gen double `gyse' = sqrt(1/`invvar') `if' `in'

* Fixed effect SEs
local scale ""
if "`fe'" == "fe" {
	local scale "scale(1)"
	local setype "fe"
}
else {
	local setype "re"
}

** fit mvivw model
if "`fe'" == "fe" {
	qui glm `varlist' [iw=`invvar'] `if' `in', nocons ///
		`scale' level(`level') `options'
}
else {
	qui regress `varlist' [aw=`invvar'] `if' `in', nocons ///
		level(`level') `options'
}

mat b = e(b)
mat V = e(V)
ereturn post b V
eret scalar N = `k'
eret local setype = "`setype'"

* display estimates
Display , level(`level') n(`k') setype(`setype')

ereturn local cmd "mrmvivw"
ereturn local cmdline `"mrmvivw `0'"'

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
