*! version 0.1.0 04jun2016 Tom Palmer
program mregger, eclass
version 13
local version : di "version " string(_caller()) ", missing :"
if replay() {
        if _by() {
                error 190
        }
        `version' Display `0'
        exit
}

syntax varlist(min=2 max=2) [aweight] [if] [in] [, ivw fe re ///
        reslope recons *]

local callersversion = _caller()
tokenize `"`varlist'"'
/*
2 variables:
1: gd beta
2: gp beta
aw: gd SE
*/

if "`exp'" == "" {
        di as err "you must specify aweights"
        exit 198
}

if "`fe'" == "fe" & "`re'" == "re" {
        di as err "both fe and re not allowed"
        exit 198
}

tempvar invvar
qui gen double `invvar' `exp' `if' `in'

if "`ivw'" == "ivw" {
        qui reg `1' `2' [aw=`invvar'] `if' `in', nocons
        if "`fe'" == "fe" {
                qui glm `1' `2' [iw=`invvar'] `if' `in', scale(1) nocons
                // alt:
                // sem (`gdtr' <- `gptr', nocons), var(e.`gdtr'@1)
        }
        else if "`re'" == "re" {
                tempvar genoDisease slope
                cap gen double genoDisease = `1'*sqrt(`invvar')
                if _rc != 0 qui replace genoDisease = `1'*sqrt(`invvar')
                cap gen double slope = `2'*sqrt(`invvar')
                if _rc != 0 qui replace slope = `2'*sqrt(`invvar')
                cap gsem (genoDisease <- slope c.M#c.slope, nocons), ///
                        var(e.genoDisease@1)
        }
}
else {
        tempvar `1'2 `2'2
        qui gen double ``1'2' = `1'*sign(`2') `if' `in'
        qui gen double ``2'2' = abs(`2') `if' `in'
        if "`fe'" == "" & "`re'" == "" {
                qui reg ``1'2' ``2'2' [aw=`invvar'] `if' `in'
        }
        else if "`fe'" == "fe" {
                // alternative syntax:
                // sem (``1'2' <- ``2'2') [iw=`invvar'] `if' `in', ///
                //       var(e.``1'2'@1)
                qui glm ``1'2' ``2'2' [iw=`invvar'] `if' `in', scale(1)
        }
        else if "`re'" == "re" {
                tempvar gd2tr gp2tr
                cap gen double genoDisease = ``1'2'*sqrt(`invvar') `if' `in'
                if _rc != 0 qui replace genoDisease = ``1'2'*sqrt(`invvar') ///
                        `if' `in'
                cap gen double slope = ``2'2'*sqrt(`invvar') `if' `in'
                if _rc != 0 qui replace slope = ``2'2'*sqrt(`invvar') `if' `in'
                if "`reslope'" == "" & "`recons'" == "recons" {
                        cap gsem (genoDisease <- slope M@1) `if' `in', ///
                                var(e.genoDisease@1) `options'
                }
                else if "`reslope'" == "reslope" & "`recons'" == "" {
                        cap gsem (genoDisease <- slope c.slope#c.M@1) ///
                                `if' `in', var(e.genoDisease@1) `options'
                }  
                else if "`reslope'" == "reslope" & "`recons'" == "recons" {
                        cap gsem (genoDisease <- slope M1@1 ///
                                c.slope#c.M2@1) `if' `in', ///
                                        var(e.genoDisease@1) `options'
                }
                drop genoDisease
                drop slope
        }
}

if "`re'" == "" {
        mat b = e(b)
        mat V = e(V)
        if "`ivw'" == "" {
                local names `1'*sign(`2'):slope `1'*sign(`2'):_cons
                matrix colnames b = `names'
                matrix colnames V = `names' 
                matrix rownames V = `names'
        }
        ereturn post b V
}
Display, `re'

ereturn local cmd "mregger"
ereturn local cmdline `"mregger `0'"'
qui count `if' `in'
local k = r(N)
ereturn scalar k = `k'
end

program Display
syntax [, re]
if "`re'" == "" {
        ereturn display
}
else {
        gsem, noheader nocnsr
}
end
exit
