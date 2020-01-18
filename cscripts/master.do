* master do-file for running cscripts
* 2020-01-17

cap noi log close _all
log using master.log, text replace name(master)

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

local errorlist ""
foreach dofile of local cscripts {
    log using `dofile'.log, text replace name(`dofile')
    do `dofile', nostop
	if _rc != 0 local errorlist `errorlist' `dofile'
    log close `dofile'
}

di "cscripts with errors:", `errorlist'

log close _all
