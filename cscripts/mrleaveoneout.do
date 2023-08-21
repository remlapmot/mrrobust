* mrleaveoneout cscript
* 2020-07-31

cscript mrleaveoneout adofiles mrleaveoneout

about

use https://raw.github.com/remlapmot/mrrobust/master/dodata.dta, clear

gen byte sel1 = (ldlcp2 < 1e-8)
count if sel1

gen byte sel2 = (ldlcp2 < 1e-25)
count if sel2

discard
mrleaveoneout chdbeta ldlcbeta if sel1==1, gyse(chdse)

discard
rcof "noi mrleaveoneout chdbeta chdse ldlcbeta ldlcse if sel1==1, gyse(chdse) method(incorrectoption)" == 198

discard
mrleaveoneout chdbeta ldlcbeta if sel2==1, gyse(chdse) method(ivw)

discard
mrleaveoneout chdbeta ldlcbeta if sel2==1, gyse(chdse) noplot

discard
mrleaveoneout chdbeta ldlcbeta if sel2==1, gyse(chdse) method(mrivw)

discard
mrleaveoneout chdbeta ldlcbeta if sel2==1, gyse(chdse) method(egger)

discard
mrleaveoneout chdbeta ldlcbeta if sel2==1, gyse(chdse) method(egger) genotype(rsid)

discard
mrleaveoneout chdbeta ldlcbeta if sel2==1, gyse(chdse) method(mregger)

discard
mrleaveoneout chdbeta ldlcbeta if sel2==1, gyse(chdse) gxse(ldlcse) method(median)

discard
mrleaveoneout chdbeta ldlcbeta if sel2==1, gyse(chdse) gxse(ldlcse) method(mode)

discard
mrleaveoneout chdbeta ldlcbeta if sel2==1, gyse(chdse) gxse(ldlcse) method(modal)

discard
mrleaveoneout chdbeta ldlcbeta hdlcbeta if sel2==1, gyse(chdse) method(mvmr)

discard
mrleaveoneout chdbeta hdlcbeta ldlcbeta if sel2==1, gyse(chdse) method(mvmr)

discard
mrleaveoneout chdbeta ldlcbeta hdlcbeta tgbeta if sel2==1, gyse(chdse) method(mvivw)

discard
mrleaveoneout chdbeta ldlcbeta hdlcbeta tgbeta if sel2==1, gyse(chdse) method(mvegger)

discard
mrleaveoneout chdbeta ldlcbeta if sel2==1, gyse(chdse) noprint

discard
mrleaveoneout chdbeta ldlcbeta if sel2==1, gyse(chdse) noprint 

discard
mrleaveoneout chdbeta ldlcbeta if sel2==1, gyse(chdse) genotype(rsid)

discard
mrleaveoneout chdbeta ldlcbeta if sel2==1, gyse(chdse) genotype(rsid) metanopts(xlabel(-.5,-.25,0,0.25,0.5))

discard
mrleaveoneout chdbeta ldlcbeta, gyse(chdse)

discard
mrleaveoneout chdbeta ldlcbeta if sel2==1, gyse(chdse) texts(50) noprint

discard
mrleaveoneout chdbeta ldlcbeta if sel2==1, gyse(chdse) texts(150) noprint

discard
mrleaveoneout chdbeta ldlcbeta, gyse(chdse) noprint
