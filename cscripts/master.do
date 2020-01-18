* master do-file for running cscripts
* 2020-01-17

cap noi log close
log using master.log, text replace

cscript master

ado describe mrrobust

local cscripts mregger ///
mreggerplot ///
mreggersimex ///
mrforest ///
mrfunnel ///
mrivests ///
mrmedian ///
mrmedianobs ///
mrmodal ///
mrmodalplot ///
mrratio

foreach dofile of local cscripts {
    log using `dofile'.log, text replace
    do `dofile', nostop
	if _rc != 0 di "`dofile' returned at least one error."
    log close
}

log close _all
