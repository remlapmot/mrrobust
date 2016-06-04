*! version 0.1.0 04jun2016 Tom Palmer
program mrmedianobs, eclass
version 9
local version : di "version " string(_caller()) ", missing :"
if replay() {
        if _by() {
                error 190
        }
        `version' Display `0'
        exit
}

tokenize `"`0'"', parse(",")
local beforeopts `1'

syntax [anything] [if] [in] [, obsboot seed(string) reps(integer 50)]

local callersversion = _caller()
** seed option
if "`seed'" != "" {
	version `callersversion': set seed `seed'
}

mrmedianobs_work `beforeopts' `if' `in'
mat b = e(b)
scalar k = e(k)
if "`obsboot'" == "" {
        mat V = e(V)
}
else {
        bootstrap beta=_b[beta], reps(`reps') notable noheader nolegend: ///
                mrmedianobs_work `1' `if'
        mat b = e(b)
        mat V = e(V)
        di _n
}
ereturn post b V
Display
ereturn local cmd "mrmedianobs"
ereturn local cmdline `"mrmedianobs `0'"'
ereturn scalar k = scalar(k)
end

program Display
ereturn display
end
exit
