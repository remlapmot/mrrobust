* ssc install log2html

local helpfiles mrrobust mr mrdeps mregger mreggerplot mreggersimex ///
	mrmedian mrmedianobs mrmodal mrmodalplot ///
	mrratio mrivests mrforest ///
	mrfunnel ///
	mrmvivw mvivw mvmr mrmvegger ///
	mrleaveoneout
	
foreach file in `helpfiles' {
	di _n "`file'"
	copy ../../`file'.sthlp `file'.smcl, replace
	cap noi markdoc `file', export(md) ///
		pandoc("C:\\Program Files\\RStudio\\bin\\pandoc\\pandoc.exe") ///
		replace
	if _rc != 0 di as err "Conversersion of `file'.smcl failed"
	cap noi copy ./`file'.md ../../docs/helpfiles/`file'.md, replace
}

