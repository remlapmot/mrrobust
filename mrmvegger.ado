*! version 0.1.0 23jun2020 Tom Palmer
program mrmvegger, eclass
version 9
local version : di "version " string(_caller()) ", missing :"
local replay = replay()
if replay() {
        if _by() {
                error 190
        }
        `version' Display `0', orientvar(`e(orientvar)') n(`e(N)') np(`e(Np)')
        exit
}

syntax varlist(min=2) [aweight] [if] [in] [, ///
	orient(integer 1) ///
	Level(cilevel) ///
    gxse(varlist numeric) ///
	*]

if `orient' < 1 {
	di as error "The orient() option cannot be negative"
	exit 198
}

local callersversion = _caller()

// number of genotypes (i.e. rows of data used in estimation)
qui count `if' `in'
local k = r(N)

tokenize `"`varlist'"'
/*
varlist should be specified as:
1: gd beta
2: gp beta1
3: gp beta2
...
aw: =1/gdSE^2
*/
local outcome `1'
local npheno = wordcount("`varlist'") - 1

if `orient' > `npheno' {
	di as error "The orient() option must be in the range of the number of phenotypes"
	exit 198
}

local orientvar ``=`orient' + 1''

tempvar invvar gyse
qui gen double `invvar' `exp' `if' `in'
qui gen double `gyse' = 1/sqrt(`invvar') `if' `in'

tempvar gdtr eggercons

qui gen double `gdtr' = `1'*sign(``=`orient'+1'') / `gyse' `if'`in'
qui gen double `eggercons' = sqrt(`invvar') `if'`in'

local phenovarlist 
local names
forvalues i = 1/`npheno' {
	tempvar pheno`i'
	qui gen double `pheno`i'' = ``=`i'+1'' * sign(``=`orient'+1'') / `gyse' `if'`in'
	local phenovarlist "`phenovarlist' `pheno`i''"
	local names `names' `outcome':``=`i'+1''
}
local names `names' `outcome':_cons

* fit model
 
qui regress `gdtr' `phenovarlist' `eggercons' `if'`in', ///
	nocons ///
	level(`level') `options'
	
mat b = e(b)
mat V = e(V)
mat colnames b = `names'
mat rownames V = `names'
mat colnames V = `names'
ereturn post b V
ereturn local orientvar = "`orientvar'"
ereturn scalar N = `k'
ereturn scalar Np = `npheno'

* display estimates
Display , level(`level') orientvar(`orientvar') n(`k') np(`npheno')

ereturn local cmd "mrmvegger"
ereturn local cmdline `"mrmvegger `0'"'

end

program Display, rclass
syntax , [Level(cilevel)] orientvar(varname) N(integer) np(integer)

local orienttext : strlen local orientvar
local colstart = 79 - 31 - `orienttext'
di _n(1) _col(`colstart') as txt "MVMR-Egger model oriented wrt:", as res "`orientvar'"

local nlength : strlen local n
local colstart = 79 - 21 - `nlength'
di _col(`colstart') as txt "Number of genotypes:", as res `n'

local nplength : strlen local np
local colstart = 79 - 22 - `nplength'
di _col(`colstart') as txt "Number of phenotypes:", as res `np'

ereturn display, level(`level') noomitted
return add // r(table)
end

exit
