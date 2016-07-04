*! version 0.1.0 04jun2016 Tom Palmer
program mregger, eclass
version 9
local version : di "version " string(_caller()) ", missing :"
if replay() {
        if _by() {
                error 190
        }
        `version' Display `0'
        exit
}

syntax varlist(min=2 max=2) [aweight] [if] [in] [, ivw fe re ///
        reslope recons noHETerogi *]

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

// re option only under version 13 and above
if "`re'" == "re" & `callersversion' < 13 {
        di as err "option re requires Stata version 13 or higher"
        exit 9
}

tempvar invvar
qui gen double `invvar' `exp' `if' `in'

// sort out the re options
if "`re'" == "" & ("`recons'" != "" | "`reslope'" != "") {
        di as err "option `reslope' `recons' must be specified with option re"
        exit 198
}
if "`ivw'" == "ivw" & "`re'" == "re" & "`recons'" == "recons" {
        di as err _c "For IVW estimator option recons not allowed "
        di as err "for re estimation (as there is no constant)"
        exit 198
}
if "`ivw'" == "" & "`re'" == "re" & "`reslope'" == "" & "`recons'" == "" {
        // by default include both random _cons and slope
        local reslope reslope
        local recons recons
}

if "`heterogi'" == "" {
        // check if heterogi is installed
        capture which heterogi
        if _rc {
                di as error "-heterogi- from SSC is required; install using"
                di "{stata ssc install heterogi}"
                exit 499
        }
}

if "`ivw'" == "ivw" {
        if "`heterogi'" == "" {
                tempname gdtr gptr invse 
                qui gen double `invse' = sqrt(`invvar') `if' `in'
                qui gen double `gdtr' = `1'*`invse' `if' `in'
                qui gen double `gptr' = `2'*`invse' `if' `in'
                qui sem (`gdtr' <- `gptr', nocons) `if' `in'
                if e(converged) == 1 {
                        local qstat = _b[var(e.`gdtr'):_cons]*e(N)
                        local df = e(N) - 1
                }
        }

        if "`fe'" == "" & "`re'" == "" {
                qui reg `1' `2' [aw=`invvar'] `if' `in', nocons
        }
        else if "`fe'" == "fe" {
                qui glm `1' `2' [iw=`invvar'] `if' `in', scale(1) nocons
                // alt:
                // sem (`gdtr' <- `gptr', nocons) `if' `in', var(e.`gdtr'@1)
        }
        else if "`re'" == "re" {
                tempvar genoDisease slope
                cap gen double genoDisease = `1'*sqrt(`invvar') `if' `in'
                if _rc != 0 qui replace genoDisease = `1'*sqrt(`invvar') ///
                        `if' `in'
                cap gen double slope = `2'*sqrt(`invvar') `if' `in'
                if _rc != 0 qui replace slope = `2'*sqrt(`invvar') `if' `in'
                cap `version' gsem (genoDisease <- slope c.M#c.slope, nocons) ///
                        `if' `in', ///
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
                // tempvar gd2tr gp2tr
                cap gen double genoDisease = ``1'2'*sqrt(`invvar') `if' `in' 
                if _rc != 0 qui replace genoDisease= ``1'2'*sqrt(`invvar') ///
                        `if' `in'
                cap gen double slope = ``2'2'*sqrt(`invvar') `if' `in'
                if _rc != 0 qui replace slope= ``2'2'*sqrt(`invvar') `if' `in'
                cap gen double cons = sqrt(`invvar') `if' `in'
                if _rc != 0 qui replace cons = sqrt(`invvar') `if' `in'
                if "`reslope'" == "" & "`recons'" == "recons" {
                        cap `version' gsem (genoDisease <- slope ///
                                cons c.cons#M@1) ///
                                `if' `in', nocons ///
                                var(e.genoDisease@1) `options'
                }
                else if "`reslope'" == "reslope" & "`recons'" == "" {
                        cap `version' gsem ///
                                (genoDisease <- slope cons c.slope#c.M@1) ///
                                `if' `in', nocons var(e.genoDisease@1) ///
                                `options'
                }  
                else if "`reslope'" == "reslope" & "`recons'" == "recons" {
                        cap `version' gsem (genoDisease <- slope cons ///
                                c.cons#M1@1 c.slope#c.M2@1) `if' `in', ///
                                nocons var(e.genoDisease@1) `options'
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
        }
        else {
                local names `1':`2'
        }
        mat colnames b = `names'
        mat colnames V = `names' 
        mat rownames V = `names'
        ereturn post b V
}

if "`ivw'" == "" {
        local qstat 0
        local df 1
}

Display, `re' qstat(`qstat') df(`df') `heterogi' `ivw'
if "`heterogi'" == "" {
        ereturn scalar I2 = r(I2)
        ereturn scalar ub_I2_M1 = r(ub_I2_M1)
        ereturn scalar lb_I2_M1 = r(lb_I2_M1)
        ereturn scalar ub_H_M1 = r(ub_H_M1)
        ereturn scalar lb_H_M1 = r(lb_H_M1)
        ereturn scalar H = r(H)
        ereturn scalar pval = r(pval)
        ereturn scalar df = r(df)
        ereturn scalar Q = r(Q)
}

if "`re'" == "" {
        ereturn local cmd "mregger"
        ereturn local cmdline `"mregger `0'"'
}
qui count `if' `in'
local k = r(N)
ereturn scalar k = `k'
end

program Display, rclass
syntax [, re qstat(real 0) df(integer 1) Level(cilevel) noHETerogi IVW]
if "`re'" == "" {
        ereturn display
        if "`heterogi'" == "" & "`ivw'" == "ivw" {
                di _n as txt _c "Heterogeneity/pleiotropy statistics"
                heterogi `qstat' `df', level(`level')
                return add
        }
}
else {
       `version' gsem, noheader nocnsr nodvhead
}
end
exit
