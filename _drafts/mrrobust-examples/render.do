local path = subinstr("`c(pwd)'", "\_drafts\mrrobust-examples", "", 1)
di "`path'"
cap noi adopath ++ "`path'"

markstat using mrrobust-examples, markdown keep(do)
foreach file in mrrobust-examples.md mrforest.svg mreggersimex-plot.svg mreggerplot.svg mrmodalplot.svg mrfunnel.svg {
	copy ./`file' ../../docs/`file', replace
}

cap noi adopath - "`path'"
