* mreggerplot testcode
* 6jun2016

cd C:\Users\palmertm\Documents\all\work\mregger\code

use dodata, clear

gen byte sel1 = (ldlcp2 < 1e-8)

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, legend(off)

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, legend(on)

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, legend(on) nolci

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, gpci

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nomcis

discard
rcof "noi mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nomcis gpci" == 198

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, gpci nolci

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nolci nomcis

discard
rcof "noi mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nolci nomcis gpci" == 198

// test passing own legend
discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ///
        legend(order(5 "Instruments" 4 "95% CIs" 3 "MR-Egger" 2 "MR-Egger 95% CI"))

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, linetop

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, linetop gpci

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, linetop nomcis

discard
rcof "noi mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, linetop nomcis gpci" == 198

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, linetop nolci

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, linetop nolci gpci

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, linetop nolci nomcis

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nolci

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, gpci


discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nolci linetop

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, noline

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, noline linetop

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ellipses

discard
rcof "noi mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ellipses errorbars" == 198

discard
rcof "noi mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ivw ellipses errorbars" == 198

discard
rcof "noi mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, egger median" == 198

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, egger

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ivw

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, median

discard
rcof "noi mreggerplot chdbeta chdse ldlcbeta ldlcse, weighted" == 198

discard
rcof "noi mreggerplot chdbeta chdse ldlcbeta ldlcse, penweighted" == 198

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, median weighted

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, median penweighted

discard
rcof "noi mreggerplot chdbeta chdse ldlcbeta ldlcse, ivw median" == 198

discard
rcof "n mreggerplot chdbeta chdse ldlcbeta ldlcse, ivw egger" == 198

discard
rcof "n mreggerplot chdbeta chdse ldlcbeta ldlcse, median egger" == 198

discard
rcof "n mreggerplot chdbeta chdse ldlcbeta ldlcse, median egger ivw" == 198

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, noline

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, noline egger

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, noline ivw

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, noline ivw linetop

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, noline median

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, noline median weighted

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, noline median penweighted

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nolci

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nolci egger

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nolci ivw

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nomcis

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nomcis ivw

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nomcis median

discard 
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, legend(off)

discard 
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nomcis

discard 
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nomcis nolci legend(off)

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ellipses legend(off)

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ellipses legend(off) linetop

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ellipses legend(off) nomcis

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nomcis

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, wmarkers

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, wmarkers egger

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, wmarkers median

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, wmarkers median weighted

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, wmarkers median penweighted

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, level(50)

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, level(99)

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, mlabel(rsid)

** add ivw line to egger plot
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1
mregger chdbeta ldlcbeta [aw=1/(chdse^2)], ivw
addplot : function _b[ldlcbeta]*x, range(0 0.5) lc(gs0) lp(dash)

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, legend(off)

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse in 1/3, ellipses

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ellipses

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ivw ellipses legend(off)

// titles
discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, title("MR-Egger plot")

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, title(MR-Egger plot) ///
        subtitle(Using MR-Base data)

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ///
        xtitle("Genotype-phenotype associations")

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ///
        ytitle("Genotype-disease associations")

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ///
        mleglabel(Genotypes)

discard
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ///
        mleglabel("Genotypes")
        
discard
rcof "noi mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, errorbars ellipses" == 198

// example labelling some points
cap noi drop mlabvar
gen mlabvar = rsid if abs(ldlcbeta) > .3
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nolci ///
        mlab(mlabvar) mlabsize(vsmall) mlabp(10) mlabc(gs0)        