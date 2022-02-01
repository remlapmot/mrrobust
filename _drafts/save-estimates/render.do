if c(os) == "Windows" local path = subinstr("`c(pwd)'", "\_drafts\save-estimates", "", 1)
else local path = subinstr("`c(pwd)'", "/_drafts/save-estimates", "", 1)
di "`path'"
cap noi adopath ++ "`path'"

markstat using save-estimates, markdown keep(do)
copy ./save-estimates.md ../../docs/save-estimates.md, replace

cap noi adopath - "`path'"
