* master do-file for running cscripts
* 2020-01-17

ado describe mrrobust

local cscripts mregger_cscript ///
mreggerplot_testcode ///
mreggersimex_cscript ///
mrforest_cscript ///
mrfunnel_cscript ///
mrivests_cscript ///
mrmedian_cscript ///
mrmedianobs_cscript ///
mrmodal_cscript ///
mrmodalplot_cscript ///
mrratio_cscript

log close _all

foreach dofile of local cscripts {
    log using `dofile'.log, text replace
    do `dofile', nostop
	if _rc != 0 di "`dofile' returned an error."
    log close
}
