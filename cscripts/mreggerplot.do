* mreggerplot testcode
* 6jun2016

cscript mreggerplot adofiles mreggerplot mregger

about

use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear

gen byte sel1 = (ldlcp2 < 1e-8)

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, legend(off)

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, legend(on)

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, legend(on) nolci

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, gpci

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nomcis

rcof "noi mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nomcis gpci" == 198

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, gpci nolci

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nolci nomcis

rcof "noi mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nolci nomcis gpci" == 198

// test passing own legend
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ///
        legend(order(5 "Instruments" 4 "95% CIs" 3 "MR-Egger" 2 "MR-Egger 95% CI"))

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, linetop

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, linetop gpci

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, linetop nomcis

rcof "noi mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, linetop nomcis gpci" == 198

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, linetop nolci

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, linetop nolci gpci

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, linetop nolci nomcis

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nolci

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, gpci

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nolci linetop

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, noline

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, noline linetop

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ellipses

rcof "noi mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ellipses errorbars" == 198

rcof "noi mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ivw ellipses errorbars" == 198

rcof "noi mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, egger median" == 198

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, egger

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ivw

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, median

rcof "noi mreggerplot chdbeta chdse ldlcbeta ldlcse, weighted" == 198

rcof "noi mreggerplot chdbeta chdse ldlcbeta ldlcse, penweighted" == 198

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, median weighted

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, median penweighted

rcof "noi mreggerplot chdbeta chdse ldlcbeta ldlcse, ivw median" == 198

rcof "n mreggerplot chdbeta chdse ldlcbeta ldlcse, ivw egger" == 198

rcof "n mreggerplot chdbeta chdse ldlcbeta ldlcse, median egger" == 198

rcof "n mreggerplot chdbeta chdse ldlcbeta ldlcse, median egger ivw" == 198

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, noline

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, noline egger

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, noline ivw

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, noline ivw linetop

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, noline median

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, noline median weighted

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, noline median penweighted

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nolci

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nolci egger

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nolci ivw

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nomcis

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nomcis ivw

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nomcis median

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, legend(off)

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nomcis

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nomcis nolci legend(off)

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ellipses legend(off)

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ellipses legend(off) linetop

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ellipses legend(off) nomcis

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nomcis

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, wmarkers

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, wmarkers egger

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, wmarkers median

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, wmarkers median weighted

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, wmarkers median penweighted

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, level(50)

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, level(99)

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, mlabel(rsid)

** add ivw line to egger plot
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1
mregger chdbeta ldlcbeta [aw=1/(chdse^2)], ivw
addplot : function _b[ldlcbeta]*x, range(0 0.5) lc(gs0) lp(dash)

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, legend(off)

mreggerplot chdbeta chdse ldlcbeta ldlcse in 1/3, ellipses

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ellipses

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ivw ellipses legend(off)

// titles
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, title("MR-Egger plot")

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, title(MR-Egger plot) ///
        subtitle(Using MR-Base data)

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ///
        xtitle("Genotype-phenotype associations")

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ///
        ytitle("Genotype-disease associations")

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ///
        mleglabel(Genotypes)

mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ///
        mleglabel("Genotypes")

rcof "noi mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, errorbars ellipses" == 198

// example labelling some points
cap noi drop mlabvar
gen mlabvar = rsid if abs(ldlcbeta) > .3
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nolci ///
        mlab(mlabvar) mlabsize(vsmall) mlabp(10) mlabc(gs0)

// test moving legend
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, legend(pos(6))
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, legend(pos(3))
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, legend(pos(12))
mreggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1, legend(size(large))
