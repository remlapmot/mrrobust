*! version 0.1.0 04jun2016 Tom Palmer
program mregger, eclass
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

syntax varlist(min=2 max=2) [aweight] [if] [in] [, ivw fe re ///
        reslope recons HETerogi noRESCale PENWeighted Level(cilevel) ///
        gxse(varname numeric) tdist *]

local callersversion = _caller()

// number of genotypes (i.e. rows of data used in estimation)
qui count `if' `in'
local k = r(N)
if `k' < 3 {
        di as err "mregger requires a minimum of 3 genotypes"
        exit 2001
}

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

if "`heterogi'" != "" {
        // check if heterogi is installed
        capture which heterogi
        if _rc {
                di as error "-heterogi- from SSC is required; install using"
                di "{stata ssc install heterogi}"
                exit 499
        }
}

if "`penweighted'" == "penweighted" {
        tempvar pweights rweights
}

tempname phi // residual variance
tempname dfr // degrees of freedom of residuals

** estimation
if "`ivw'" == "ivw" {
        if "`heterogi'" != "" & "`penweighted'" == "" {
                tempname gdtr gptr invse 
                qui gen double `invse' = sqrt(`invvar') `if' `in'
                qui gen double `gdtr' = `1'*`invse' `if' `in'
                qui gen double `gptr' = `2'*`invse' `if' `in'
                qui sem (`gdtr' <- `gptr', nocons) `if' `in'
                // alternative: glm `gdtr' `gptr' `if' `in', nocons
                if e(converged) == 1 {
                        local df = e(N) - 1
                        local qstat = _b[var(e.`gdtr'):_cons]*e(N)
                        // if using glm: local qstat = e(phi)*(e(N) - 1)
                        scalar `dfr' = e(df)
                }
        }
        if "`fe'" == "" & "`re'" == "" {
                tempname betaivw
                // qui reg `1' `2' [aw=`invvar'] `if' `in', nocons
                qui glm `1' `2' [iw=`invvar'] `if' `in', nocons
                scalar `betaivw' = _b[`2']
                scalar `dfr' = e(df)
                if "`penweighted'" != "" {
                        qui gen double `pweights' = chi2tail(1, ///
                                (`2'^2*`invvar')* ///
                                (`1'/`2' - scalar(`betaivw'))^2) `if' `in'
                        qui gen double `rweights' = `pweights'*20 `if' `in'
                        qui replace `rweights' = 1 if `rweights' > 1
                        qui replace `rweights' = `invvar'*`rweights' `if' `in'
                        qui glm `1' `2' [iw=`rweights'] `if' `in', nocons
                        scalar `dfr' = e(df)
                }
                if e(phi) < 1 & "`rescale'" == "" {
                        di as txt _c "Residual variance =", e(phi) "; "
                        di as txt _c "rerunning with residual "
                        di as txt "variance set to 1"
                        if "`penweighted'" == "" {
                                qui glm `1' `2' [iw=`invvar'] `if' `in', ///
                                        nocons scale(1)
                                scalar `dfr' = e(df)
                        }
                        else {
                                qui glm `1' `2' [iw=`rweights'] ///
                                `if' `in', ///
                                nocons scale(1)                        
                                scalar `dfr' = e(df)
                        }
                }
                else if e(phi) < 1 & "`rescale'" != "" {
                        di as txt _c "Residual variance =", e(phi)
                        di as txt _c "; recommend refitting without "
                        di as txt "norescale option"
                }
        }
        else if "`fe'" == "fe" {
                qui glm `1' `2' [iw=`invvar'] `if' `in', scale(1) nocons
                scalar `dfr' = e(df)
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
        if "`heterogi'" != "" & "`penweighted'" == "" {
                tempname gdtr gptr invse
                qui gen double `invse' = sqrt(`invvar') `if' `in'
                qui gen double `gdtr' = ``1'2'*`invse' `if' `in'
                qui gen double `gptr' = ``2'2'*`invse' `if' `in'
                qui sem (`gdtr' <- `gptr' `invse', nocons) `if' `in'
                // alternative: glm `gdtr' `gptr' `invse' `if' `in', nocons 
                if e(converged) == 1 {
                        local df = e(N) - 2
                        local qstat = _b[var(e.`gdtr'):_cons]*e(N)
                        // if using glm: local qstat di e(phi)*(e(N) - 2)
                        scalar `dfr' = e(N) - (e(df_m) - 1)
                }
        }
        if "`fe'" == "" & "`re'" == "" {
                tempname betaegger interegger                
                // qui reg ``1'2' ``2'2' [aw=`invvar'] `if' `in'
                qui glm ``1'2' ``2'2' [iw=`invvar'] `if' `in'
                scalar `betaegger' = _b[``2'2']
                scalar `interegger'= _b[_cons]
                scalar `phi' = e(phi)
                scalar `dfr' = e(df)
                if "`penweighted'" != "" {
                        qui gen double `pweights' = chi2tail(1, ///
                                `invvar'*(``1'2' - scalar(`interegger') - ///
                                scalar(`betaegger')*``2'2')^2) `if' `in'
                        qui gen double `rweights' = `pweights'*20 `if' `in'
                        qui replace `rweights' = 1 if `rweights' > 1
                        qui replace `rweights' = `invvar'*`rweights' `if' `in' 
                        qui glm ``1'2' ``2'2' [iw=`rweights'] `if' `in'
                        scalar `phi' = e(phi)
                        scalar `dfr' = e(df)
                }
                if e(phi) < 1 & "`rescale'" == "" {
                        di as txt _c "Residual variance =", e(phi) "; "
                        di as txt _c "rerunning with residual "
                        di as txt "variance set to 1"
                        if "`penweighted'" == "" {
                                qui glm ``1'2' ``2'2' [iw=`invvar'] ///
                                        `if' `in', scale(1)
                                scalar `dfr' = e(df)
                        }
                        else {
                                qui glm ``1'2' ``2'2' [iw=`rweights'] ///
                                        `if' `in', scale(1)
                                scalar `dfr' = e(df)
                        }
                }
                else if e(phi) < 1 & "`rescale'" != "" {
                        di as txt _c "Residual variance =", e(phi)
                        di as txt _c "; recommend refitting without "
                        di as txt "norescale option"
                }
        }
        else if "`fe'" == "fe" {
                // alternative syntax:
                // sem (``1'2' <- ``2'2') [iw=`invvar'] `if' `in', ///
                //       var(e.``1'2'@1)
                qui glm ``1'2' ``2'2' [iw=`invvar'] `if' `in', scale(1)
                scalar `dfr' = e(df)
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

if "`penweighted'" != "" | "`heterogi'" == "" {
        local qstat 0
        local df 1
}

if "`tdist'" != "" {
        * use t-dist for ereturn display Wald test and CI limits
        ereturn scalar df_r  = `dfr'
}
else {
        ereturn scalar df_r = .
}

** start of displaying output
local digits : length local k
local colstart = 79 - (22 + `digits') 
di _n(1) _col(`colstart') "Number of genotypes = " as res %`digits'.0fc `k'

** display coefficient table
Display , `re' level(`level')
if "`ivw'" == "" & "`re'" == "" {
        if "`fe'" == "" {
                di as txt "Residual standard error:", %6.3f sqrt(`phi')
        }
        else {
                di as txt "Residual standard error:", 1
        }
}

if "`heterogi'" != "" & "`penweighted'" == "" & "`re'" == "" {
        di as txt "Heterogeneity/pleiotropy statistics:" _c
        heterogi `qstat' `df', level(`level')
}
if "`heterogi'" != "" & "`penweighted'" == "" & "`re'" == "" {
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

if "`gxse'" != "" & "`ivw'" == "" {
        ** I-squared GX
        tempname gammabar nobs qgx QGX I2GX
        
        if "`penweighted'" == "" {
                * weighted mean of genotype-exposure associations
                qui su ``2'2' [aw=1/(`gxse'^2)] `if' `in'
                scalar `nobs' = r(N)
                scalar `gammabar' = r(mean)
        
                * QGX
                qui gen double `qgx' = (``2'2' - `gammabar')^2/(`gxse'^2) `if' `in'
        }
        else {
                tempvar gxscaled segxscaled
                qui gen double `gxscaled' = ``2'2'*sqrt(`invvar') `if' `in'
                qui gen double `segxscaled' = `gxse'*sqrt(`invvar') `if' `in'
                qui su `gxscaled' [aw=1/(`segxscaled'^2)] `if' `in'
                scalar `nobs' = r(N)
                scalar `gammabar' = r(mean)
                
                * QGX
                qui gen double `qgx' = ///
                        (`gxscaled' - `gammabar')^2/(`segxscaled'^2) `if' `in'
        }
        qui su `qgx' `if' `in'
        scalar `QGX' = r(sum)
        
        * I2GX
        scalar `I2GX' = (`QGX' - (`nobs' - 1))/`QGX'
        scalar `I2GX' = max(0, `I2GX')
        
        di as txt "I^2_GX statistic:", %6.2f 100*`I2GX' "%"
        ereturn scalar I2GX = `I2GX'
        // heterogi `QGX' `nobs', level(`level')
}

if "`re'" == "" {
        ereturn local cmd "mregger"
        ereturn local cmdline `"mregger `0'"'
}
ereturn scalar k = `k'
end

program Display, rclass
syntax [, re Level(cilevel)]
if "`re'" == "" {
        // regression output
        ereturn display, level(`level')
}
else {
       `version' gsem, noheader nocnsr nodvhead level(`level')
}
end
exit
