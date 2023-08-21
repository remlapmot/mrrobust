* mr cscript
* 20jan2020

cscript mr adofiles ///
mrmvegger ///
mrmvivw ///
mr ///
mrdeps ///
mregger ///
mreggerplot ///
mreggersimex ///
mreggersimexonce ///
mrforest ///
mrfunnel ///
mrivests ///
mrmedian ///
mrmedianobs ///
mrmedianobs_work ///
mrmodal ///
mrmodalplot ///
mrratio

about

rcof "noi mr incorrectsubcommandname" == 198

mr deps

** Do et al. dataset

use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear
gen byte sel1 = (ldlcp2 < 1e-8)

mr egger chdbeta ldlcbeta [aw=1/(chdse^2)] if sel1==1, ivw fe

mr eggerplot chdbeta chdse ldlcbeta ldlcse if sel1==1

mr eggersimex chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, gxse(ldlcse) seed(12345) noboot

mr forest chdbeta chdse ldlcbeta ldlcse if sel1==1, ivid(rsid)

mr funnel chdbeta chdse ldlcbeta ldlcse if sel1==1

mr ivests chdbeta chdse ldlcbeta ldlcse if sel1==1, generate(ivest ivse)

mr median chdbeta chdse ldlcbeta ldlcse if sel1==1

mr modal chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted

mr modalplot chdbeta chdse ldlcbeta ldlcse if sel1==1

mr ratio 1 .5 1 .25, eform

** mv estimators

mr mvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1

mr mvegger chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1

mr mvegger chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, orient(2)

gen byte sel2 = (ldlcp2 < 1e-25)
mr leaveoneout chdbeta ldlcbeta if sel2==1, gyse(chdse) genotype(rsid)

** mrmedianobs test dataset

use https://raw.github.com/remlapmot/mrrobust/master/mrmedianobs_testdata, clear
mr medianobs y (x = z1-z20), weighted
