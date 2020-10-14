* ssc install log2html

local helpfiles mrrobust mr mrdeps mregger mreggerplot mreggersimex ///
	mrmedian mrmedianobs mrmodal mrmodalplot ///
	mrratio mrivests mrforest ///
	mrfunnel ///
	mrmvivw mrmvegger ///
	mrleaveoneout
	
foreach file in `helpfiles' {
	di _n "`file'"
	copy ../../`file'.sthlp `file'.smcl, replace
	cap noi log2html `file', bold replace linesize(100)
	if _rc != 0 di as err "Conversersion of `file'.smcl failed"
	cap noi copy ./`file'.html ../../docs/helpfiles/`file'-html.html, replace
}

