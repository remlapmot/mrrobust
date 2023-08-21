* render the helpfiles in the Results window, to check they are approx ok
* 2020-07-02

about

local helpfiles ///
mrrobust ///
mr ///
mrdeps ///
mregger ///
mreggersimex ///
mreggerplot ///
mrmedian ///
mrmedianobs ///
mrmodal ///
mrmodalplot ///
mrratio ///
mrivests ///
mrforest ///
mrfunnel ///
mrmvivw ///
mvivw ///
mvmr ///
mrmvegger ///
mrleaveoneout

foreach helpfile of local helpfiles {
	type ../`helpfile'.sthlp
}
