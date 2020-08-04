*! 0.1.0 20jul2017 Tom Palmer
program mreggersimex, eclass
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

local mreggersimexcmd `0'

syntax varlist(min=2 max=2) [aweight] [if] [in] , gxse(varname numeric) ///
	[ivw fe re ///
	reslope recons HETerogi noRESCale PENWeighted Level(cilevel) ///
	tdist lambda(numlist) seed(string) simreps(int 50) * nodraw noboot ///
	bsopts(string) Reps(integer 25)]

local callersversion = _caller()

// check grc1leg installed
if "`draw'" == "" {
	capture which grc1leg
	if _rc {
		di as error "-grc1leg- is required; install using"
		di "{stata net install grc1leg, from(http://www.stata.com/users/vwiggins)}"
		exit 499
	}
}

if "`exp'" == "" {
	di as err "you must specify aweights"
	exit 198
}

** seed option
if "`seed'" != "" {
	version `callersversion': set seed `seed'
}

** no. observations
** number of genotypes
qui count `if' `in'
local n = r(N)

** run simex first time
mreggersimexonce `mreggersimexcmd'
mat b = (r(slope), r(cons))
mat simexests = r(simexests)

** simex plot
if "`draw'" == "" {
	mreggersimexplot, simexests(simexests)
}

* bootstrapping to obtain SEs
if "`boot'" == "" {
	bootstrap slope=r(slope) cons=r(cons), ///
		force nowarn noheader notable `bsopts' reps(`reps'): ///
		mreggersimexonce `mreggersimexcmd'
	mat V = e(V)
}
else {
	mat V = J(2,2,0)
	local reps 0
}

mat b = simexests[6,2..3]
local names slope _cons
mat colnames b = `names'
mat colnames V = `names' 
mat rownames V = `names'
ereturn post b V, obs(`n')
ereturn matrix simexests = simexests

* display results
Display, level(`level') k(`n') simreps(`simreps') reps(`reps')

ereturn local cmd "mreggersimex"
ereturn local cmdline `"mreggersimex `0'"'
ereturn sca k = `n'
ereturn sca simreps = `simreps'
ereturn sca reps = `reps'
end

program mreggersimexplot
syntax , simexests(name)
preserve
qui svmat double `simexests', names(col)
twoway scatter slope lambda in 1/4, mc(gs0) || ///
	qfit slope lambda in 1/5, range(0 2) lc(gs0) || ///
	scatter slope lambda in 6, ms(X) msize(large) mc(gs0) || ///
	qfit slope lambda in 1/5, range(-1 0) lp(dash) lc(gs0) || ///
	scatter slope lambda in 5, ms(Oh) mc(gs0) || ///
	, legend(order(3 "SIMEX" 5 "Original" 1 "Simulated" ///
		2 "Quadratic fit" 4 "Extrapolation" ) ///
	size(small) cols(3)) ///
	name(slope, replace) ///
	xtitle("{&lambda}") ///
	ytitle("MR-Egger slope")
twoway scatter cons lambda in 1/4, mc(gs0) || ///
	qfit cons lambda in 1/5, range(0 2) lc(gs0) || ///
	scatter cons lambda in 6, ms(X) msize(large) mc(gs0) || ///
	qfit cons lambda in 1/5, range(-1 0) lp(dash) lc(gs0) || ///
	scatter cons lambda in 5, ms(Oh) mc(gs0) || ///
	, legend(order(3 "SIMEX" 5 "Original" 1 "Simulated" ///
		2 "Quadratic fit" 4 "Extrapolation" ) ///
	size(small) cols(3)) ///
	name(cons, replace) ///
	xtitle("{&lambda}") ///
	ytitle("MR-Egger intercept")
grc1leg slope cons, name(mreggersimex, replace) xcommon
restore
end

program Display
syntax [, Level(cilevel) k(integer 0) simreps(integer 0) reps(integer 0)]
if "`k'" == "0" {
	local k = e(k)
}
if "`reps'" == "0" & !replay() {
	local reps = e(reps)
}
if "`simreps'" == "0" {
	local simreps = e(simreps)
}

local digits : length local k
local colstart = 79 - (22 + `digits') 
di _n(1) _col(`colstart') as txt "Number of genotypes = " as res %`digits'.0fc `k'
local digits2 : length local reps
local colstart2 = 79 - (25 + `digits2')
di _col(`colstart2') as txt "Bootstrap replications = " as res %`digits2'.0fc `reps'
local digits3 : length local simreps
local colstart3 = 79 - (26 + `digits3')
di _col(`colstart3') as txt "Simulation replications = " as res %`digits3'.0fc `simreps'
ereturn display, level(`level')
end
