capture log close
log using ".\mrrobust-examples\mrrobust-examples", smcl replace
//_1
* ssc install addplot
* ssc install kdens
* ssc install moremata
* ssc install heterogi
* ssc install metan
* net install grc1leg, from(http://www.stata.com/users/vwiggins)
* net install mrrobust, from(https://raw.github.com/remlapmot/mrrobust/master/) replace
//_2
mrforest chdbeta chdse ldlcbeta ldlcse if sel1==1, ivid(rsid) ///
    xlabel(-5,-4,-3,-2,-1,0,1,2,3,4,5)
gr export mrforest.png, width(500) replace
//_3
use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear
//_4
gen byte sel1 = (ldlcp2 < 1e-8)
//_5
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw fe
//_6
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1
//_7
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, gxse(ldlcse) heterogi
//_8
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, tdist
//_9
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, radial
//_10
mregger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, radial heterogi
//_11
mreggersimex chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, gxse(ldlcse) ///
    seed(12345) noboot
gr export mreggersimex-plot.png, width(500) replace
//_12
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1
gr export mreggerplot.png, width(500) replace
//_13
mrmedian chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted
//_14
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1
gr export mrmodalplot.png, width(500) replace
//_15
mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1
//_16
mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted
//_17
mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, nome
//_18
mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1
gr export mrfunnel.png, width(500) replace
//_^
log close
