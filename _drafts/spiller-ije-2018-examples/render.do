if c(os) == "Windows" local path = subinstr("`c(pwd)'", "\_drafts\spiller-ije-2018-examples", "", 1)
else local path = subinstr("`c(pwd)'", "/_drafts/spiller-ije-2018-examples", "", 1)
di "`path'"
cap noi adopath ++ "`path'"

markstat using spiller-ije-2018-examples, markdown keep(do)
foreach file in spiller-ije-2018-examples.md mreggerplot-bmi.svg mrmodalplot-bmi.svg mreggerplot-height.svg mrmodalplot-height.svg {
	copy ./`file' ../../docs/`file', replace
}

cap noi adopath - "`path'"
