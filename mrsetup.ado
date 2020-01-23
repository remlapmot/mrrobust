*! version 0.1.0 Tom Palmer 23jan2020
program mrsetup
version 9.0
syntax varlist(min=2 numeric) [if] [in], gdse(varname numeric) [gxse(varname numeric) rsid(varname string)]

tokenize `varlist'

local npheno = wordcount("`varlist'") - 1

quietly {
    gen _gd = `1' `if'`in'
    forvalues i = 1/`npheno' {
        gen _gp = `=`i' + 1' `if'`in'
    }
    gen _gdse = `gdse' `if'`in'
    if "`gxse'" != "" {
        gen _gxse = `gxse' `if'`in'
    }
}

end
exit