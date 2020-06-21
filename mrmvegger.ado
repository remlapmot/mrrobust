*! version 0.1.0 20jan2020 Tom Palmer
program mrmvegger, eclass
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

syntax varlist(min=3) [aweight] [if] [in] [, fe ///
        Level(cilevel) ///
        gxse(varlist numeric) tdist RADial *]

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
local npheno = wordcount("`varlist'") - 1
di `npheno'

* mvegger
tempvar eggercons
qui gen double `eggercons' `exp' `if'`in'
sem (`gdtr' <- `gpvarstr' `eggercons', nocons) `if'`in'

end
exit
