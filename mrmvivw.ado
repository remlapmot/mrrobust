*! version 0.1.0 22jun2020 Tom Palmer
program mrmvivw, eclass
version 9
local version : di "version " string(_caller()) ", missing :"
local replay = replay()
if replay() {
        if _by() {
                error 190
        }
		if "`e(Qa)'" != "" {
			local qopts "qa(`e(Qa)') qadf(`e(Qadf)') qap(`e(Qap)')"
		}
        `version' Display `0', n(`e(N)') setype(`e(setype)') ///
			`qopts'
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

** ereturn some items
mat b = e(b)
mat V = e(V)
ereturn post b V
eret scalar N = `k'
eret local setype = "`setype'"

if "`gxse'" != "" {
	** error check length of gxse
	local gxselength : word count `gxse'
	if `gxselength' != `npheno' {
		di as err "The number of variables in gxse() does not match the number of genotype-phenotype variables"
		exit 198
	}

	** Sanderson Q-statistics
	tempvar weight
	qui gen double `weight' = 0 `if'`in'
	tokenize `gxse'
	forvalues i=1/`npheno' {
		tempvar sepheno`i'
		qui gen double `sepheno`i'' = ``i'' `if'`in'
		qui replace `weight' = `weight' + _b[`phenoname`i'']^2 * `sepheno`i''^2 `if'`in'
	}
	qui replace `weight' = `weight' + `gyse'^2 `if'`in'
	
	** QA, equation 13
	*** weights
	tempvar fitted qa
	qui predict double `fitted', xb
	*** test statistic
	qui egen `qa' = sum(((`outcome' - `fitted')^2) / `weight') `if'`in'
	tempname qares
	qui tab `qa', matrow(`qares')
	eret scalar Qa = `qares'[1,1]
	tempname qap qadf
	scalar `qadf' = `k' - `npheno'
	scalar `qap' = chi2tail(`qadf', `qares'[1,1])
	eret scalar Qadf = scalar(`qadf')
	eret scalar Qap = scalar(`qap')
	local qopts qa(`=`qares'[1,1]') qadf(`=`qadf'') qap(`=`qap'')
}

** display estimates
Display , level(`level') n(`k') setype(`setype') `qopts'
ereturn local cmd "mrmvivw"
ereturn local cmdline `"mrmvivw `0'"'

end

program Display, rclass
syntax , [Level(cilevel) qa(real 0) qadf(integer 0) qap(real 0)] ///
	n(integer) setype(string)

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

if `qa' != 0 {
	di _col(2) "Q_A statistic for instrument validity; chi2(" `qadf' ") =", ///
		%5.2f `qa', "(p = ", %5.4f `qap' ")"
}

end

exit
