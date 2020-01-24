capture log close
log using "save-estimates", smcl replace
//_1
use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear
//_2
gen byte sel1 = (ldlcp2 < 1e-8)
//_3
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw fe
mat ivw = r(table)
//_4
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1
mat mregger = r(table)
//_5
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, radial
mat radial = r(table)
//_6
mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted
mat mode = r(table)
//_7
mrmedian chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted
mat median = r(table)
//_8
mat dir
mat list ivw
mat list mregger
mat list radial
mat list mode
mat list median
//_9
mat output = (ivw, mregger, radial, mode, median)
mat colnames output = ivw_beta mregger_beta mregger_cons ///
radial_beta radial_cons mode_beta median_beta
mat coleq output = "" "" "" "" "" "" ""
mat output = output'
mat li output
//_10
drop _all
svmat output, names(col)
local rownames : rownames output
di "`rownames'"
tokenize `rownames'
gen str15 estimate = ""
forvalues i = 1/7 {
replace estimate = "``i''" in `i'
}
//_11
list estimate b se z pvalue ll ul, clean noobs
//_12
save myestimates, replace
//_13
export delimited using myestimates.txt, delimiter(tab) replace
//_^
log close
