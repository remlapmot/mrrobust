*! 1.0.0 Tom Palmer 30may2017, based on my old tsci.ado from 8jan2010
program mrratio, eclass 
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

syntax anything [, eform fieller Level(cilevel) NOME]
* syntax gd segd gp segp cov (if poss)

local n = wordcount("`anything'")
if `n' < 3 {
	di as err "mrratio needs at least 3 inputs: GD, SE GD, and GP values"
	exit 198
}
else if `n' > 5 {
	di as err "mrratio only accepts 5 inputs or fewer"
	exit 198
}

* only allow one of fieller or paramboot
if "`fieller'" != "" & "`paramboot'" != "" {
	di as err "The fieller and paramboot options may not both be specified"
	exit 198
}

* only allow one of fieller or nome
if "`fieller'" != "" & "`nome'" != "" {
	di as err "fieller and nome options may not be specified together"
	exit 198
}

if "`level'" == "" {
	local level c(level)
}

tokenize `anything'
tempname gd segd gp segp cov ratio seratio lowerci upperci
sca `gd' = `1'
sca `segd' = `2'
sca `gp' = `3'

if `n' == 3 & "`nome'" == "" {
	di as err "With 3 inputs please specify the nome option."
	exit 198
}

if `n' > 3 {
	sca `segp' = `4'
}

if `n' == 4 {
	sca `cov' = 0
}

if `n' == 5 {
	sca `cov' = `5'
}

sca `ratio' = `gd'/`gp'

if "`fieller'" != "" {
	tempname f0 f1 f2 D r1 r2
        local critlevel = 1 - ((100 - `level')/2)/100
	scalar `f0' = `gd'^2 - invnormal(`critlevel')^2*`segd'^2
	scalar `f1' = `gp'^2 - invnormal(`critlevel')^2*`segp'^2
	scalar `f2' = `gd'*`gp'
	scalar `D' = `f2'^2 - `f0'*`f1'
	if `D' > 0 {
		scalar `r1' = (`f2' - sqrt(`D'))/`f1'
		scalar `r2' = (`f2' + sqrt(`D'))/`f1'
		if `f1' > 0 { 
			local fiellerres 1
		}
		if `f1' < 0 {
            local fiellerres 2
		}
	}
	else {
		local fiellerres 3
	}
}
else {
	if "`nome'" == "" {
		* taylor series formula from Thomas et al. Ann Rev Epi 2007
		sca `seratio' = sqrt((`segd'^2/`gp'^2) + ///
			(`gd'^2/`gp'^4)*`segp'^2 - ///
			2*(`gd'/`gp'^3)*`cov')
	}
	else {
		sca `seratio' = `segd'/abs(`gp')
	}
}

mat b = `ratio'
local names beta
matrix colnames b = `names'

if "`fieller'" == "" {
	mat V = `seratio'^2
	matrix colnames V = `names' 
	matrix rownames V = `names'
	ereturn post b V
	eret sca fiellerres = .
}
else {
	if `fiellerres' < 3 {
		sca `lowerci' = min(`r1',`r2')
		sca `upperci' = max(`r1',`r2')
	}
	else {
		sca `lowerci' = .
		sca `upperci' = .
	}
	local fopts fiellerres(`fiellerres') lowerci(`=`lowerci'') upperci(`=`upperci'') ratio(`=`ratio'')
	ereturn post b
	eret sca lowerci = `lowerci'
	eret sca upperci = `upperci'
	eret sca fiellerres = `fiellerres'
}

Display, `eform' level(`level') `fieller' `fopts'

ereturn local cmd "mrratio"
ereturn local cmdline `"mrratio `0'"'
eret sca level = `level'
end

program Display, rclass
syntax , [fiellerres(integer 0) Level(cilevel) ///
	lowerci(real 0) upperci(real 0) fieller eform ratio(real 0) ]
if "`eform'" != "" {
	local eformopt "eform(exp())"
}         
di 
if "`fieller'" == "" {
	if inlist(`fiellerres',.,0) {
		if e(fiellerres) == . {
			ereturn display, level(`level') `eformopt'
			return add // r(table)
		}
		else {
			if `level' != e(level) {
				di as err "level() option not allowed" ///
					" with Fieller CI with estimates" ///
					" replay"
				exit 198
			}
			fieller_display, fiellerres(`=e(fiellerres)') ///
				`eform' r1(`e(lowerci)') ///
				r2(`e(upperci)') ///
				level(`level') ratio(`=_b[beta]')
		}
	}
}
else {
	fieller_display, `eform' r1(`lowerci') r2(`upperci') ///
		fiellerres(`fiellerres') level(`level') ratio(`ratio')
}
ret sca level = `level'
end

program fieller_display
syntax [, eform fiellerres(integer 0) r1(real 0) r2(real 0) ///
	ratio(real 0) Level(cilevel)]
if "`eform'" == "" {
	di "Ratio estimate:", `ratio'
}
else {
	di "exp() ratio estimate:", exp(`ratio')
}
if `fiellerres' == 1 {
        if "`eform'" == "" { 
			di "`level'% Fieller CI: [" ///
				`r1' ",", `r2' "]"
        }
        else {
		di "`level'% Fieller CI: [" ///
			exp(`r1') ",", exp(`r2') "]"
	}
}
else if `fiellerres' == 2 {
	if "`eform'" == "" {
		di "`level'% Fieller CI is the union of two open" ///
			" intervals: (-Inf, " `r1' "], [" `r2' ", +Inf)"
	}
	else {
		di "`level'% Fieller CI is the union of two open" ///
			" intervals: (-Inf, " exp(`r1') ///
			"], [" exp(`r2') ", +Inf)"
	}
}
else if `fiellerres' == 3 {
	di "Using Fieller's Theorem, no finite confidence" ///
		" interval exists" _n "other than the entire real line."
}
end
exit
