* mrfunnel testcode
* 29aug2017

cscript mrfunnel adofiles mrfunnel

about

use https://raw.github.com/remlapmot/mrrobust/master/dodata.dta, clear

gen byte sel1 = (ldlcp2 < 1e-8)

// web figure a2 of bowden et al., gen epi, 2016
mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1

mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, metric(gpbeta)

mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, metric(gpbetastd)

mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, metric(invse)

rcof "mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, metric(wrongmetric)" == 198

mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, noivw

mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, nomregger

mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, noivw nomregger

mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, xscale(range(-4 4))

mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, yscale(range(0 12))

discard
mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, scatteropts(mc(red))

* legend off
discard
mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, legend(off)

* lines going down to zero
discard
mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, ///
	noivw nomregger ///
	extraplots(function .481, lp(dash) lc(gs0) hor range(0 10) || ///
		function .617, lp(longdash) lc(gs0) hor range(0 10) || ) ///
	legend(on order(1 "Genotypes" 2 "IVW" 3 "MR-Egger") rows(1))

* set the range for the lines using xlrange option
discard
mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, xlrange(0 10)

* original mrfunnel plot
discard
mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, xlrange(0 10) legend(off)

* Try different legend positions
mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, legend(pos(6))
mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, legend(pos(12))
mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, legend(pos(3))
