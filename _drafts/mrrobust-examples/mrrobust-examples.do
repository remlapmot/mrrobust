capture log close
log using "mrrobust-examples", smcl replace
//_1
use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear
//_2
gen byte sel1 = (ldlcp2 < 1e-8)
//_3
mrforest chdbeta chdse ldlcbeta ldlcse if sel1==1, ///
ivid(rsid) ///
xlabel(-5,-4,-3,-2,-1,0,1,2,3,4,5)
qui gr export mrforest.svg, width(600) replace
//_4
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw fe
//_5
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1
//_6
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ///
gxse(ldlcse) heterogi
//_7
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, tdist
//_8
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, radial
//_9
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ///
radial heterogi
//_10
mreggersimex chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, ///
gxse(ldlcse) seed(12345) noboot
qui gr export mreggersimex-plot.svg, width(600) replace
//_11
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1
qui gr export mreggerplot.svg, width(600) replace
//_12
mrmedian chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted
//_13
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345)
qui gr export mrmodalplot.svg, width(600) replace
//_14
mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1
//_15
mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted
//_16
mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, nome
//_17
mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, xlrange(0 10)
qui gr export mrfunnel.svg, width(600) replace
//_18
gen byte sel2 = (ldlcp2 < 1e-25)
//_19
mrleaveoneout chdbeta ldlcbeta if sel2==1, gyse(chdse) genotype(rsid) noprint
qui gr export mrleaveoneout-plot-01.svg, width(600) replace
//_20
mrleaveoneout chdbeta ldlcbeta hdlcbeta tgbeta if sel2==1, ///
method(mvmr) gyse(chdse) genotype(rsid) noprint
qui gr export mrleaveoneout-plot-02.svg, width(600) replace
//_^
log close
