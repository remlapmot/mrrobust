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
		cap confirm matrix e(Qx)
		if _rc == 0 local qxopts qx(e(Qx))
		cap confirm matrix e(Fx)
		if _rc == 0 local fxopts fx(e(Fx))
        `version' Display `0', n(`e(N)') setype(`e(setype)') np(`e(Np)') ///
			`qopts' `qxopts' `fxopts'
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
local phenovarlist ""
forvalues i = 1/`npheno' {
	tempvar pheno`i'
	local phenoname`i' ``=`i' + 1''
	qui gen double `pheno`i'' = `=`i' + 1' `if'`in'
	local phenovarlist `phenovarlist' ``=`i' + 1''
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

** ereturn
** collect b and V
mat b = e(b)
mat V = e(V)


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
		local sephenoname`i' "``i''"
		tempvar sepheno`i'
		qui gen double `sepheno`i'' = ``i'' `if'`in'
		qui replace `weight' = `weight' + _b[`phenoname`i'']^2 * `sepheno`i''^2 `if'`in'
	}
	qui replace `weight' = `weight' + `gyse'^2 `if'`in'
	
	** Q_A - equation 13 - test of instrument validity
	*** weights
	tempvar fitted qa
	qui predict double `fitted', xb
	*** test statistic
	qui egen `qa' = sum(((`outcome' - `fitted')^2) / `weight') `if'`in'
	tempname qares
	qui tab `qa', matrow(`qares')
	tempname qap qadf
	scalar `qadf' = `k' - `npheno'
	scalar `qap' = chi2tail(`qadf', `qares'[1,1])
	local qopts qa(`=`qares'[1,1]') qadf(`=`qadf'') qap(`=`qap'')
	
	** Equation 12 - test of instrument strength
	tempname qxmat fxmat
	matrix `qxmat' = J(`npheno',1,.)
	matrix `fxmat' = J(`npheno',1,.)
	
	** Estimate delta for each phenotype
	** Regress each genotype-phenotype association on the other exposure effects
	forvalues i = 1/`npheno' {
		tempname delta`i'
		
		// other phenos without i
		local phenoswithouti : subinstr local phenovarlist "`phenoname`i''" ""
		local phenoswithouti = stritrim(strtrim("`phenoswithouti'"))
		
		// sephenos without i
		local sephenoswithouti : subinstr local gxse "`sephenoname`i''" ""
		local sephenoswithouti = stritrim(strtrim("`sephenoswithouti'"))
		
		qui regress `phenoname`i'' `phenoswithouti' `if'`in', noc // TODO: does this need weighting??
		tempvar res`i'
		qui predict double `res`i'' `if'`in', residual
		tempvar vx`i' qx`i'
		qui gen double `vx`i'' = `sephenoname`i''^2 `if'`in'
		tokenize "`sephenoswithouti'"
		local j = 1
		foreach phenovar of varlist `phenoswithouti' {
			qui replace `vx`i'' = `vx`i'' + (``j''*_b[`phenovar'])^2 `if'`in'
			local j = `j' + 1
		}
		qui gen double `qx`i'' = `res`i''^2 / `vx`i'' `if'`in'
		qui su `qx`i''
		tempname qxsc`i'
		scalar `qxsc`i'' = r(sum)
		mat `qxmat'[`i',1] = scalar(`qxsc`i'')
		mat `fxmat'[`i',1] = scalar(`qxsc`i'') / (`k' - (`npheno' - 1))
	}
	mat colnames `qxmat' = Qx
	mat colnames `fxmat' = Fx
	mat rownames `qxmat' = `phenovarlist'
	mat rownames `fxmat' = `phenovarlist'
	local qxopts "qx(`qxmat')"
	local fxopts "fx(`fxmat')"
}

** display estimates
ereturn post b V // from the mvivw fit way above (otherwise e(b) and e(V) taken from subsequent fits)
Display , level(`level') n(`k') setype(`setype') np(`npheno') ///
	`qopts' `qxopts' `fxopts'

** ereturn additional items
eret scalar N = `k'
eret scalar Np = `npheno'
eret local setype = "`setype'"
if "`gxse'" != "" {
	eret scalar Qa = `qares'[1,1]
	eret scalar Qadf = scalar(`qadf')
	eret scalar Qap = scalar(`qap')	
	eret matrix Qx = `qxmat'
	eret matrix Fx = `fxmat'
}
ereturn local cmd "mrmvivw"
ereturn local cmdline `"mrmvivw `0'"'

end

program Display, rclass
syntax , [Level(cilevel) qa(real 0) qadf(integer 0) qap(real 0) ///
	qx(string asis) fx(string asis) ] ///
	n(integer) setype(string) np(integer)

local nlength : strlen local n
local colstart = 79 - 22 - `nlength'
di _n(1) _col(`colstart') as txt "Number of genotypes =", as res `n'

local nplength : strlen local np
local colstart = 79 - 23 - `nplength'
di _col(`colstart') as txt "Number of phenotypes =", as res `np'

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
	di _col(2) as txt "Q_A statistic for instrument validity; chi2(" ///
		as res `qadf' as txt ") =", ///
		as res %5.2f `qa', as txt "(p = ", as res %5.4f `qap' as txt ")"
}

if "`fx'" != "" {
	tempname fxmatname
	mat `fxmatname' = `fx'
	local fxrownames : rownames `fx'
	tokenize `fxrownames'
	di _col(2) as txt "Conditional F-statistics for instrument strength:"
	forvalues i = 1/`np' {
		di _col(2) as txt "F_x`i' =", as res %5.2f `fxmatname'[`i',1], ///
			_col(18) as txt "(" as res "``i''" as txt ")"
	}
}

end

exit
