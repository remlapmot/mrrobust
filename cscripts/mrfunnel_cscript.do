* mrfunnel testcode
* 29aug2017

cscript

cd C:\Users\palmertm\Documents\all\work\mregger\code

clear all

which mrfunnel

use https://raw.github.com/remlapmot/mrrobust/master/dodata.dta, clear

gen byte sel1 = (ldlcp2 < 1e-8)

// web figure a2 of bowden et al., gen epi, 2016
mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1

mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, metric(gpbeta)

mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, metric(gpbetastd)

mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, metric(invse)

mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, noivw

mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, nomregger

mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, noivw nomregger

mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, xscale(range(-4 4))

mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, yscale(range(0 .6))

mrfunnel chdbeta chdse ldlcbeta ldlcse if sel1==1, mc(red)
