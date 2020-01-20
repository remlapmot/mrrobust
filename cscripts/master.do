* master do-file for running cscripts
* 2020-01-17

cap noi log close _all
log using master.log, text replace name(master)

cscript master

ado describe mrrobust

local cscripts ///
mr ///
mrdeps ///
mregger ///
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
    log using `dofile'.log, text replace name(`dofile')
    do `dofile'
    log close `dofile'
}

log close _all
