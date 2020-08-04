*! 0.1.0 23jul2017 Tom Palmer
program mreggersimexonce, rclass
syntax varlist(min=2 max=2) [aweight] [if] [in] , gxse(varname numeric) ///
	[ivw fe re ///
	reslope recons HETerogi noRESCale PENWeighted Level(cilevel) ///
	tdist lambda(numlist) seed(string) simreps(int 100) *]

tokenize `"`varlist'"'
/*
2 variables:
1: gd beta
2: gp beta
aw: gd SE
*/
tempvar mreggery mreggerx
qui gen double `mreggery' = `1'*sign(`2') `if' `in'
qui gen double `mreggerx' = abs(`2') `if' `in'        

** values of lambda to loop through
if "`lambda'" == "" {
	local lambda ".5 1 1.5 2"
}

** number of genotypes
qui count `if' `in'
local n = r(N)

** id variable
tempvar id
qui gen `id' = _n
    
tempvar xunknown
qui putmata `mreggerx' `gxse' `id' `if' `in', replace
tempvar res
tempname slope cons
local lambdalength = wordcount("`lambda'")
local nres = `simreps'*`lambdalength'
mata `res' = J(`nres', 3, .)

** lambda = 0: implies original data
tempname slopelambda0 conslambda0
qui mregger `mreggery' `mreggerx' [aw `exp'] `if' `in', ///
	`ivw' `fe' `re' ///
	`reslope' `recons' `heterogi' `rescale' ///
	`penweighted' level(`level') ///
	`tdist' `options'
scalar `slopelambda0' = _b[slope]
scalar `conslambda0' = _b[_cons]
local j = 0
foreach lam of numlist `lambda' {
	local j = `j' + 1
	forvalues i=1/`simreps' {
		** the new variable with measurement error
		mata `xunknown' = `mreggerx' + sqrt(`lam'):*`gxse':*rnormal(`n', 1, 0, 1)
		qui getmata `xunknown', double replace id(`id')
		qui mregger `mreggery' `xunknown' [aw `exp'] `if' `in', ///
			`ivw' `fe' `re' ///
			`reslope' `recons' `heterogi' `rescale' ///
			`penweighted' level(`level') ///
			`tdist' `options'
		scalar `slope' = _b[slope]
		scalar `cons' = _b[_cons]
		local resrow = `i' + (`j' - 1)*`simreps'
		mata `res'[`resrow',] = (`lam', st_numscalar("`slope'"), st_numscalar("`cons'"))
	}
}

preserve
drop _all
qui set obs `nres'
getmata (lambda slope cons)=`res', double
collapse (mean) slope cons, by(lambda)
local colln = _N
qui set obs `=_N+1'
gsort -lambda
qui replace lambda = 0 in `=_N'
qui replace slope = `slopelambda0' in `=_N'
qui replace cons = `conslambda0' in `=_N'
qui gen double lambda2 = lambda*lambda
qui putmata simexests=(lambda slope cons), replace

mata simexests2 = J(6,3,.)
mata simexests2[1..5,] = simexests
qui regress slope lambda lambda2
local ext -1
local pred = _b[lambda]*`ext' + _b[lambda2]*`ext'*`ext' + _b[_cons]
mata simexests2[6,1..2] = (-1, `pred')
ret sca slope = `pred'

qui regress cons lambda lambda2
local pred = _b[lambda]*`ext' + _b[lambda2]*`ext'*`ext' + _b[_cons]
mata simexests2[6,3] = (`pred')
ret sca cons = `pred'

mata st_matrix("simexests2", simexests2)
local names "lambda slope cons"
mat colnames simexests2 = `names'
return matrix simexests = simexests2

qui mata mata drop simexests simexests2 `gxse' `mreggerx' `id' `res' `xunknown'
end
