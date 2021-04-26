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
	gxse(varname numeric) tdist RADial unwi2gx oldnames *]

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

tempvar invvar gyse
qui gen double `invvar' `exp' `if' `in'
qui gen double `gyse' = 1/sqrt(`invvar') `if' `in'

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

// temp variables for radial estimation
if "`radial'" == "radial" {
	tempvar wrad wrady wradx
	qui gen double `wrad' = sqrt(`invvar') `if'`in'
	qui gen double `wrady' = `wrad'*sign(`2')*`1' `if'`in'
	qui gen double `wradx' = `wrad'*abs(`2') `if'`in'
}

// prevent option combinations I am uncertain of
if "`radial'" != "" & "`penweighted'" != "" {
	di as err "Options radial and penweighted currently not supported."
	exit 198
}

** estimation
if "`ivw'" == "ivw" {
	if "`heterogi'" != "" & "`penweighted'" == "" {
		tempname gdtr gptr invse 
		qui gen double `invse' = sqrt(`invvar') `if' `in'
		qui gen double `gdtr' = `1'*`invse' `if' `in'
		qui gen double `gptr' = `2'*`invse' `if' `in'
		if "`radial'" == "" {
			qui sem (`gdtr' <- `gptr', nocons) `if' `in'
			// alternative: glm `gdtr' `gptr' `if' `in', nocons
			if e(converged) == 1 {
				local df = e(N) - 1
				local qstat = _b[var(e.`gdtr'):_cons]*e(N)
				// if using glm: local qstat = e(phi)*(e(N) - 1)
				scalar `dfr' = e(df)
			}
		}
		else {
			qui sem (`wrady' <- `wradx', nocons) `if'`in'
			if e(converged) == 1 {
				local df = e(N) - 1
				local qstat = _b[var(e.`wrad'):_cons]*e(N)
				// if using glm: local qstat = e(phi)*(e(N) - 1)
				scalar `dfr' = e(df)
			}
		}
	}
	if "`fe'" == "" & "`re'" == "" {
		tempname betaivw
		// qui reg `1' `2' [aw=`invvar'] `if' `in', nocons
		qui glm `1' `2' [iw=`invvar'] `if' `in', nocons
		scalar `betaivw' = _b[`2']
		scalar `dfr' = e(df)
		scalar `phi' = e(phi)
		if "`penweighted'" != "" {
			qui gen double `pweights' = chi2tail(1, ///
				(`2'^2*`invvar')* ///
				(`1'/`2' - scalar(`betaivw'))^2) `if' `in'
			qui gen double `rweights' = `pweights'*20 `if' `in'
			qui replace `rweights' = 1 if `rweights' > 1
			qui replace `rweights' = `invvar'*`rweights' `if' `in'
			qui glm `1' `2' [iw=`rweights'] `if' `in', nocons
			scalar `dfr' = e(df)
			scalar `phi' = e(phi)
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
			scalar `phi' = 1
		}
		else if e(phi) < 1 & "`rescale'" != "" {
			di as txt _c "Residual variance =", e(phi)
			di as txt _c "; recommend refitting without "
			di as txt "norescale option"
		}
	}
	else if "`fe'" == "fe" {
		if "`radial'" == "" {
			qui glm `1' `2' [iw=`invvar'] `if' `in', scale(1) nocons
			scalar `dfr' = e(df)
			scalar `phi' = e(phi)
			// alt:
			// sem (`gdtr' <- `gptr', nocons) `if' `in', var(e.`gdtr'@1)
		}
		else {
			qui glm `wrady' `wradx' `if'`in', scale(1) nocons
			scalar `dfr' = e(df)
			scalar `phi' = e(phi)
		}
	}
	else if "`re'" == "re" {
		tempvar genoDisease slope
		cap gen double `genoDisease' = `1'*sqrt(`invvar') `if' `in'
		if _rc != 0 {
			qui replace `genoDisease' = `1'*sqrt(`invvar') `if' `in'
		}
		cap gen double `slope' = `2'*sqrt(`invvar') `if' `in'
		if _rc != 0 {
			qui replace `slope' = `2'*sqrt(`invvar') `if' `in'
		}
		if "`radial'" == "" {
			cap `version' gsem (`genoDisease' <- `slope' c.M#c.`slope', nocons) ///
				`if' `in', ///
				var(e.`genoDisease'@1)
		}
		else {
			cap `version' gsem (`wrady' <- `wradx' c.M#c.`wradx', nocons) ///
				`if' `in', ///
				var(e.`wrady'@1)
		}
	}
}
else { // MR-Egger
	tempvar `1'2 `2'2
	qui gen double ``1'2' = `1'*sign(`2') `if' `in'
	qui gen double ``2'2' = abs(`2') `if' `in'
	if "`heterogi'" != "" & "`penweighted'" == "" {
		tempname gdtr gptr invse
		qui gen double `invse' = sqrt(`invvar') `if' `in'
		qui gen double `gdtr' = ``1'2'*`invse' `if' `in'
		qui gen double `gptr' = ``2'2'*`invse' `if' `in'
		
		if "`radial'" == "" {
		qui sem (`gdtr' <- `gptr' `invse', nocons) `if' `in'
		// alternative: glm `gdtr' `gptr' `invse' `if' `in', nocons 
			if e(converged) == 1 {
				local df = e(N) - 2
				local qstat = _b[var(e.`gdtr'):_cons]*e(N)
				// if using glm: local qstat di e(phi)*(e(N) - 2)
				scalar `dfr' = e(N) - (e(df_m) - 1)
			}
		}
		else {
			qui sem (`wrady' <- `wradx') `if' `in'
			if e(converged) == 1 {
				local df = e(N) - 2
				local qstat = _b[var(e.`wrady'):_cons]*e(N)
				// if using glm: local qstat di e(phi)*(e(N) - 2)
				scalar `dfr' = e(N) - (e(df_m) - 1)
			}
		}
		
	}
	if "`fe'" == "" & "`re'" == "" {
		tempname betaegger interegger
		if "`radial'" == "" {
			// qui reg ``1'2' ``2'2' [aw=`invvar'] `if' `in'
			qui glm ``1'2' ``2'2' [iw=`invvar'] `if' `in'
			scalar `betaegger' = _b[``2'2']
		}
		else {
			qui glm `wrady' `wradx' `if' `in'
			scalar `betaegger' = _b[`wradx']
		}
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
			if "`radial'" == "" {
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
			else {
				qui glm `wrady' `wradx' `if'`in', scale(1)
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
		if "`radial'" == "" {
			qui glm ``1'2' ``2'2' [iw=`invvar'] `if' `in', scale(1)
		}
		else {
			qui glm `wrady' `wradx' `if' `in', scale(1)
		}
		scalar `dfr' = e(df)
	}
	else if "`re'" == "re" {
		tempvar genoDisease slope cons
		cap gen double `genoDisease' = ``1'2'*sqrt(`invvar') `if' `in' 
		if _rc != 0 qui replace `genoDisease' = ``1'2'*sqrt(`invvar') ///
			`if' `in'
		cap gen double `slope' = ``2'2'*sqrt(`invvar') `if' `in'
		if _rc != 0 qui replace `slope' = ``2'2'*sqrt(`invvar') `if' `in'
		if "`radial'" == "" {
			cap gen double `cons' = sqrt(`invvar') `if' `in'
		}
		else {
			cap gen byte `cons' = 1 `if' `in'
		}
		if _rc != 0 qui replace `cons' = sqrt(`invvar') `if' `in'
		if "`reslope'" == "" & "`recons'" == "recons" {
			if "`radial'" == "" {
				cap `version' gsem (`genoDisease' <- `slope' ///
					`cons' c.`cons'#M@1) ///
					`if' `in', nocons ///
					var(e.`genoDisease'@1) `options'
			}
			else {
				cap `version' gsem (`wrady' <- `wradx' ///
					`cons' c.`cons'#M@1) ///
					`if' `in', nocons ///
					var(e.`wrady'@1) `options'					
			}
		}
		else if "`reslope'" == "reslope" & "`recons'" == "" {
			if "`radial'" == "" {
				cap `version' gsem ///
					(`genoDisease' <- `slope' `cons' c.`slope'#c.M@1) ///
					`if' `in', nocons var(e.`genoDisease'@1) ///
					`options'
				}
			else {
				cap `version' gsem ///
					(`wrady' <- `wradx' `cons' c.`wradx'#c.M@1) ///
					`if' `in', nocons var(e.`wrady'@1) ///
					`options'					
			}
		}  
		else if "`reslope'" == "reslope" & "`recons'" == "recons" {
			if "`radial'" == "" {
				cap `version' gsem (`genoDisease' <- `slope' `cons' ///
					c.`cons'#M1@1 c.`slope'#c.M2@1) `if' `in', ///
					nocons var(e.`genoDisease'@1) `options'
			}
			else {
				cap `version' gsem (`wrady' <- `wradx' `cons' ///
					c.`cons'#M1@1 c.`wradx'#c.M2@1) `if' `in', ///
					nocons var(e.`wrady'@1) `options'					
			}
		}
	}
}

// column and rownames for e(b) and e(V)
mat b = e(b)
mat V = e(V)
if "`re'" == "" {
	if "`radial'" == "" {
		if "`ivw'" == "" {
			if "`oldnames'" == "" {
				local names `1':slope `1':_cons
			}
			else {
				local names `1'*sign(`2'):slope `1'*sign(`2'):_cons
			}
		}
		else {
			local names `1':`2'
		}
	}
	else {
		if "`ivw'" == "" {
			local names radialGD:radialGP radialGD:_cons
		}
		else {
			local names radialGD:radialGP
		}
	}
}
else {
	if "`radial'" == "" {
		if "`ivw'" == "" {
			local names GD:GP GD:_cons GD:c._cons#c.M1 GD:c.GP#c.M2 /:var(M1) /:var(M2) /:cov(M1,M2) /:var(e.GD)
		}
		else {
			local names GD:GP GD:c.GP#c.M /:var(M) /:var(e.GD)
		}
	}
	else {
		if "`ivw'" == "" {
			local names radialGD:radialGP radialGD:_cons radialGD:c._cons#c.M1 radialGD:c.radialGP#c.M2 radialGD:cons /:var(M1) /:var(M2) /:cov(M1,M2) /:var(e.radialGD)
		}
		else {
			local names radialGD:radialGP radialGD:c.radialGP#c.M radialGD:_cons /:var(M) /:var(e.radialGD)
		}
	}
}
if !("`re'" == "re" & "`radial'" == "") {
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
    // use t-dist for ereturn display Wald test and CI limits
    ereturn scalar df_r  = `dfr' 
}
else {
	// if df_r == . then Stata uses Normal dist
    ereturn scalar df_r = .
}

if "`ivw'" == "ivw" & "`fe'" == "fe" {
	ereturn scalar phi = 1
}

** start of displaying output
di ""

if "`gxse'" != "" & "`ivw'" == "" {
        ** I-squared GX
        tempname gammabar nobs qgx QGX I2GX gammabarw qgxw QGXw I2GXw gpw
        
        if "`penweighted'" == "" {
			* weighted mean of genotype-exposure associations
			qui su ``2'2' [aw=1/(`gxse'^2)] `if' `in'
			scalar `nobs' = r(N)
			scalar `gammabar' = r(mean)
			
			* QGX
			qui gen double `qgx' = (``2'2' - `gammabar')^2/(`gxse'^2) `if' `in'
			
		* weighted QGX
		qui gen double `gpw' = ``2'2' / `gyse' `if' `in'
		qui su `gpw' [aw=(`gyse'/`gxse')^2] `if' `in'
			scalar `gammabarw' = r(mean)
		qui gen double `qgxw' = (`gpw' - `gammabarw')^2/(`gxse' / `gyse')^2 `if' `in'
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
		
		qui su `qgxw' `if' `in'
		scalar `QGXw' = r(sum)
        
        * I2GX
        scalar `I2GX' = (`QGX' - (`nobs' - 1))/`QGX'
        scalar `I2GX' = max(0, `I2GX')
		
		scalar `I2GXw' = (`QGXw' - (`nobs' - 1))/`QGXw'
        scalar `I2GXw' = max(0, `I2GXw')
        
		di _col(44) as txt "Q_GX statistic (weighted) =", %6.2f as res `QGXw'
        di _col(42) as txt "I^2_GX statistic (weighted) =", %6.2f as res 100*`I2GXw' as res "%"
        ereturn scalar I2GX = `I2GXw'
		ereturn scalar QGX = `QGXw'
		
		if "`unwi2gx'" == "unwi2gx" {
			di _col(43) as txt "Q_GX statistic (unweighted):", %6.2f `QGX'
			di _col(41) as txt "I^2_GX statistic (unweighted):", %6.2f 100*`I2GX' "%"
			ereturn scalar I2GXunw = `I2GX'
			ereturn scalar QGXunw = `QGX'
		}
		
        // heterogi `QGXw' `nobs', level(`level')
}

** number of genotypes
local digits : length local k
local colstart = 79 - (22 + `digits') 
di _col(`colstart') as txt "Number of genotypes = " as res %`digits'.0fc `k'

** residual standard error
if "`fe'" == "" {
    di _col(47) as txt "Residual standard error =", as res %6.3f sqrt(`phi')
    ereturn scalar phi = sqrt(`phi')
}
else {
    di _col(39) as txt "Residual standard error constrained at 1"
    ereturn scalar phi = 1
}

** heterogi
if "`heterogi'" != "" & "`penweighted'" == "" & "`re'" == "" {
	if "`ivw'" == "ivw" {
		local qname Cochran's
	}
	else {
		local qname Ruecker's
	}
    qui heterogi `qstat' `df', level(`level')
	local colstart = 79 - (44 + 16 + `=length("`r(df)'")')
	di _col(`colstart') as txt "`qname' Q for heterogeneity; chi2(" ///
		as res r(df) as txt ") =", ///
		as res %5.2f r(Q), as txt "(p = ", as res %5.4f r(pval) as txt ")"
	local colstart = 79 - 49
	di _col(`colstart') as txt "I-squared statistic =", ///
		as res %4.1f r(I2)*100 "%", ///
		as txt "(95% CI", ///
		as res %4.1f r(lb_I2_M1)*100 "%" ///
		as txt ",", ///
		as res %4.1f r(ub_I2_M1)*100 "%" ///
		as txt ")"
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

** display coefficient table
Display , `re' level(`level') `radial'

** additional e-returned items
if "`re'" == "" {
	ereturn local cmd "mregger"
	ereturn local cmdline `"mregger `0'"'
}
ereturn scalar k = `k'
end

program Display, rclass
syntax [, re Level(cilevel) radial]
if "`re'" == "re" & "`radial'" == "" {
    `version' gsem, noheader nocnsr nodvhead level(`level')
}
else {
	ereturn display, level(`level') noomitted
    return add // r(table)
}
end
exit
