local path = subinstr("`c(pwd)'", "\_drafts\mrrobust-examples", "", 1)
di "`path'"
cap noi adopath ++ "`path'"

markstat using mrrobust-examples, markdown keep(do)
local filelist mrrobust-examples.md mrforest.svg mreggersimex-plot.svg mreggerplot.svg ///
	mrmodalplot.svg mrfunnel.svg mrleaveoneout-plot-01.svg mrleaveoneout-plot-02.svg
foreach file in `filelist' {
	copy ./`file' ../../docs/`file', replace
}

cap noi adopath - "`path'"
